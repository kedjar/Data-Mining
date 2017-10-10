%% MTI830 - Forage de textes et de données audiovisuelles
% M'Hand Kedjar - August 2016
function [sift_test_results] = SIFT_face_recognition_test(...
                                              sift_train_results,...
                                              face_db_test,...
                                              label_test,...
                                              face_db_train,...
                                              label_train,...
                                              config_file,...
                                              save_Results )                                             
                                             
count_train = numel(face_db_train); % number of training images
count_test = numel(face_db_test);
distRatio = 0.6;  % 0.8 % threshold which determine which matches to keep.

SIFT_label_test_classified= zeros(1,count_test);
SIFT_classification_results = cell(count_test,2);

for i = 1:count_test              
        personLabel = label_test{i};        
        name = face_db_test{i};
        a = whos('name');

        if(strcmp(a.class ,'cell'))
            name = name{1};   
        end
        img = ObjectDetection(name,'HaarCascades\haarcascade_frontalface_alt.mat');
        imwrite(img,'caa.pgm','pgm'); %Save the cropped test face image to a temporary file.
        
        [~, des, ~] = sift('caa.pgm'); %Extract the SIFT features of the test image.
        
        for j=1:1:count_train
            desc = sift_train_results{j}.descriptors; % Load the descriptor of the training image
            dest = desc';                             % Precompute matrix transpose
            
            for k = 1 : size(des,1)
                dotprods = des(k,:) * dest;           % Computes vector of dot products
                [vals,indx] = sort(acos(dotprods));   % Take inverse cosine and sort results
                % Check if nearest neighbor has angle less than distRatio times 2nd.
                if (numel(vals) >=2 && vals(1) < distRatio * vals(2))
                    match(k) = indx(1);
                else
                    match(k) = 0;
                end
            end
            
            keypoint(1,j) = sum(match > 0); % Compute the total number of matches found.            
        end  
        
        [~,index] = sort(keypoint,'descend'); %Compute the highest number of matches
         
         recognized_index = index(1);
         lp = label_train{recognized_index};         
         recognized_img = face_db_train{recognized_index};
         
         SIFT_classification_results{i , 1} = name; 
         SIFT_classification_results{i , 2} = recognized_img;    
     
         if(strcmp(personLabel,lp))             
             SIFT_label_test_classified(i) = 1;  
         end
end
sift_test_results = struct('SIFT_label_test_classified', SIFT_label_test_classified,...
                           'SIFT_classification_results', SIFT_classification_results);

%% Displaying the results
fprintf('SIFT : Results...\n')
SIFT_accuracy = sum(SIFT_label_test_classified) / count_test;
fprintf('SIFT Accuracy: %d of %d images correctly classified \n',...
        sum(SIFT_label_test_classified),count_test)
fprintf('SIFT Percentage: %0.5f\n', SIFT_accuracy)
    
results_accuracy = strcat(num2str(sum(SIFT_label_test_classified)),'_',...
        num2str(SIFT_accuracy),'_');

%% Saving the results
if(save_Results == 1)    
    filename = strcat('SIFT_test_',db_name,...
        '_', config_file,results_accuracy,db_record,'.mat');
    cd results
    save(filename, 'face_db_test', 'label_test', 'SIFT_label_test_classified',...
        'SIFT_classification_results','SIFT_accuracy','-v7.3');
    cd ..
end
