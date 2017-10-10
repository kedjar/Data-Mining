clear; close all;clc;
% Choosing the path of the datasets
face_db_main_path = '..\datasets'; 
face_db_path1 = 'caltech';
face_db_path2 = 'orl';
face_db_path3 = 'yale';



for pth = 1:3
   
    face_db_path = strcat('face_db_path', num2str(pth));
    face_db = strcat( face_db_main_path,'\', eval(face_db_path));
    ratio = 0.5:0.2:0.9;
    sift_mean_accuracy = zeros(numel(ratio),10);
    
    for s = 1:numel(ratio);
        p = ratio(s);
        mean_accuracy = zeros(1,10);
        for q = 1:10;
            imgSet = imageSet(face_db , 'recursive');
            [train , test] = partition(imgSet , [p 1-p],'randomized');
            
            % sift
            count_person = numel(train);
            count_img_train = train(1).Count;
            sift_train_results = cell(1, count_person * count_img_train );
            sift_count = 0;
            
            % Load training results
            for i = 1:count_person
                personLabel = train(i).Description;
                sift_feature_path = strcat(face_db , '\' , personLabel ,  '\' ,...
                    personLabel,'_sift_features.mat');
                load(sift_feature_path);
                
                for j = 1:train(i).Count
                    
                    name = train(i).ImageLocation{j};
                    
                    for k = 1 : numel(image_sift_features)
                        if(strcmp(image_sift_features{k}.name, name))
                            break;
                        end
                    end
                    
                    sift_train_results{sift_count + 1} = struct('image', image_sift_features{k}.image,...
                        'descriptors',image_sift_features{k}.descriptors ,...
                        'locs',image_sift_features{k}.locs,...
                        'personLabel',image_sift_features{k}.personLabel,...
                        'name',image_sift_features{k}.name);
                    sift_count = sift_count + 1 ;
                end
            end
            
            sift_train_results =  sift_train_results(~cellfun('isempty', sift_train_results));
            
            distRatio = 0.6;
            TP = 0;
            TN = 0;
            for i = 1:count_person            
                personLabel = test(i).Description;
                if(~isempty(personLabel))
                    sift_feature_path = strcat(face_db , '\' , personLabel ,  '\' ,...
                        personLabel,'_sift_features.mat');
                    load(sift_feature_path);
                    
                    for j = 1:test(i).Count
                        
                        name = test(i).ImageLocation{j};
                        
                        for k = 1 : numel(image_sift_features)
                            if(strcmp(image_sift_features{k}.name, name))
                                break;
                            end
                        end
                        
                        des = image_sift_features{k}.descriptors;
                        
                        for l = 1:numel(sift_train_results)
                            desc = sift_train_results{l}.descriptors; % load the descriptor of the training image
                            dest = desc';                             % Precompute matrix transpose
                            
                            for m = 1 : size(des,1)
                                dotprods = des(m,:) * dest;           % Computes vector of dot products
                                [vals,indx] = sort(acos(dotprods));   % Take inverse cosine and sort results
                                % Check if nearest neighbor has angle less than distRatio times 2nd.
                                if (numel(vals) >=2 && vals(1) < distRatio * vals(2))
                                    match(m) = indx(1);
                                else
                                    match(m) = 0;
                                end
                            end
                            
                            keypoint(1,l) = sum(match > 0); %compute the total number of matches found.
                            %fprintf('Found %d matches with training image %d.\n', Kpoint(1,count),count);
                        end
                        [~,index] = sort(keypoint,'descend'); %Compute the highest number of matches
                        
                        recognized_index = index(1);
                        
                        lp = sift_train_results{recognized_index}.personLabel;
                        recognized_img = sift_train_results{recognized_index}.name;
                        
                        if(strcmp(personLabel,lp))
                            TP = TP +1;
                        else
                            TN = TN + 1;
                        end
                        
                    end
                end
                
            end
            
            TP;
            TN;
            SIFT_Accuracy  = TP/(TP+TN);
            mean_accuracy(q) = SIFT_Accuracy
            %fprintf('p: %0.5f, TP: %d, TN: %d, sift_accuracy: %0.5f\n' , p, TP, TN,SIFT_Accuracy)
        end
        %fprintf('p: %0.5f, mean_accuracy: %0.5f\n' , p, mean(mean_accuracy))
        sift_mean_accuracy(s,:) = mean_accuracy
    end
end


