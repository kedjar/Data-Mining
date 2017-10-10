%% MTI830 - Forage de textes et de données audiovisuelles
% M'Hand Kedjar - August 2016
function [hogsvm_test_results] = HOGSVM_face_recognition_test(...
                                              hogsvm_train_results,...
                                              face_db_test,...
                                              label_test,...
                                              label_train,...
                                              face_db_id,...
                                              db_name,...
                                              config_file,...
                                              img_size,...
                                              save_Results)
                 
hogsvm_faceClassifier = hogsvm_train_results.hogsvm_faceClassifier;

count_test = numel(face_db_test);
HOGSVM_label_test_classified = zeros(1,count_test);
HOGSVM_classification_results = cell(count_test,1);

%% Tester le classifieur sur le sous-ensemble test
% tic
% Dans la première boucle, on parcourt les personnes
% Dans la deuxième boucle, on parcourt les images d'une personne
% On définit TP: le nombre d'images correctement classifiées
% On définit (num_img_test)-TP: le nombre d'images incorrectement
% classifiées

for i = 1:count_test        
        name = face_db_test{i};
        a = whos('name');
        if(strcmp(a.class ,'cell'))
           name = name{1};   
        end
        %img = imread(face_db_train{i});
        queryImage = ObjectDetection(name,'HaarCascades\haarcascade_frontalface_alt.mat');
        %queryImage = imread(face_db_test{i});        
        queryImage = imresize(queryImage, [128,128]);
        
        queryFeatures = extractHOGFeatures(queryImage);
        personLabel = predict(hogsvm_faceClassifier, queryFeatures);        
        HOGSVM_classification_results{i , 1} = face_db_test{i};        
        if(strcmp(personLabel,label_test{i}))            
            HOGSVM_label_test_classified(i) = 1; 
        end    
end

hogsvm_test_results = struct('HOGSVM_label_test_classified' , HOGSVM_label_test_classified,...
                             'HOGSVM_classification_results' , HOGSVM_classification_results);

%% Displaying the results
fprintf('HOG + SVM : Results...\n')
HOGSVM_accuracy = sum(HOGSVM_label_test_classified) / count_test;
fprintf('HOGSVM Accuracy: %d of %d images correctly classified \n',...
         sum(HOGSVM_label_test_classified),count_test)
fprintf('HOGSVM Percentage: %0.5f\n', HOGSVM_accuracy)


if(save_Results == 1)
    %% Saving the results
    filename = strcat('HOGSVM_test_',db_name,...
        '_', config_file,results_accuracy,db_record,'.mat');
    cd results
    save(filename, 'face_db_test', 'label_test', 'HOGSVM_label_test_classified',...
        'HOGSVM_classification_results','HOGSVM_accuracy','-v7.3');
    cd ..
end

%results_accuracy = strcat(num2str(sum(HOGSVM_label_test_classified)),'_',...
        %num2str(HOGSVM_accuracy),'_');
                             
                         
                         %timeElapsed = toc;
%HOGSVM_accuracy = sum(HOGSVM_label_test_classified) / count_test;
%fprintf('Phase de comparaison avec l\''ensemble test: %0.5g sec',timeElapsed)
%fprintf('Nombre d\''image correctement classifiées: %d sur un nombre total de: %d',sum(HOGSVM_label_test_classified),count_test)
%fprintf('Précision finale: %0.5g',HOGSVM_accuracy)


        
        
    
