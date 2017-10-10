%% MTI830 - Forage de textes et de données audiovisuelles
% M'Hand Kedjar - August 2016
function [pca_test_results] = PCA_face_recognition_test(...
                                               pca_train_results,...
                                               face_db_train,...
                                               face_db_test,...
                                               label_test,...
                                               label_train,...
                                               face_db_id,...
                                               db_name,...
                                               config_file,...
                                               img_size,...
                                               save_Results)
           
mean_img = pca_train_results.mean_img;
projectimg = pca_train_results.projectimg;
eigenfaces = pca_train_results.eigenfaces;
                    
count_test = numel(face_db_test);
PCA_label_test_classified= zeros(1,count_test);
PCA_classification_results = cell(count_test,2);

for i = 1:count_test 
     name = face_db_test{i};
     a = whos('name');
    if(strcmp(a.class ,'cell'))
        name = name{1};   
    end
     %
     %test_image = ObjectDetection(name,'HaarCascades\haarcascade_frontalface_alt.mat');
     %test_image = imresize(test_image, [img_size(1),img_size(2)]);        
     %
     %
     test_image = imread(name);
     %
     
     test_image = test_image(:,:,1);
     
    
%     if(face_db_id == 3 && size(test_image,2) ~= 192)
%        test_image = imresize(test_image, [168,192]);
%     end
    
    [r , c] = size(test_image);
    
    temp = reshape(test_image',r*c,1); 
    temp = double(temp)-mean_img;
    projtestimg = eigenfaces'*temp; 
     
    euclide_dist = [ ];
    for j = 1:size(eigenfaces,2)
        temp = (norm(projtestimg-projectimg(:,j)))^2;
        euclide_dist = [euclide_dist temp];
    end
    [~ , recognized_index] = min(euclide_dist);
    
    recognized_img = face_db_train{recognized_index};
    PCA_classification_results{i , 1} = face_db_test{i};
    PCA_classification_results{i , 2} = recognized_img;
    
    if(strcmp(label_train{recognized_index},label_test{i}))
        PCA_label_test_classified(i) = 1;        
    end    
end

pca_test_results = struct('PCA_label_test_classified' , PCA_label_test_classified,...
                          'PCA_classification_results' , PCA_classification_results);

%% Displaying the results  
fprintf('PCA : Results...\n')
PCA_accuracy = sum(PCA_label_test_classified) / count_test;
fprintf('PCA Accuracy: %d of %d images correctly classified \n',...
         sum(PCA_label_test_classified),count_test)
fprintf('PCA Percentage: %0.5f\n', PCA_accuracy)
    
results_accuracy = strcat(num2str(sum(PCA_label_test_classified)),'_',...
        num2str(PCA_accuracy),'_');
    
if(save_Results == 1)    
    %% Saving the results
    filename = strcat('PCA_test_',db_name,'_', config_file,results_accuracy,db_record,'.mat');
    cd results
    save(filename, 'face_db_test', 'label_test', 'PCA_label_test_classified',...
        'PCA_classification_results','PCA_accuracy','-v7.3');
    cd ..
end