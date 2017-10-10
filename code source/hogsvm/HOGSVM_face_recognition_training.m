%% MTI830 - Forage de textes et de données audiovisuelles
% M'Hand Kedjar - August 2016
function [hogsvm_train_results] = HOGSVM_face_recognition_training(...
                                              face_db_train,...
                                              label_train,...
                                              face_db_id,...
                                              db_name,...
                                              config_file,...
                                              img_size,...
                                              save_Results)
%% Extraction des descripteurs 
% Histogram of Oriented Gradient (HOG)
% Le descripteur HOG d'une image est un vecteur à 4680 éléments
% trainingFeatures est une matrice qui va contenir les descripteurs HOG
% pour chaque image dans le sous-ensemble d'apprentissage, et sa taille est
% de: [nombre d'images dans le sous-ensemble d'apprentissage] x 4680
count_train = numel(face_db_train); 
% tic
% Choosing HOG parameters
img_size = [128,128];
CellSize = [8 8];
BlockSize = [2 2];
BlockOverlap = ceil(BlockSize/2);
NumBins = 9;
BlocksPerImage = floor((img_size./CellSize - BlockSize)./(BlockSize - BlockOverlap) + 1);
HOG_feature_length = prod([BlocksPerImage, BlockSize, NumBins]);
features_train = zeros(count_train,HOG_feature_length);

for i = 1:count_train  
        name = face_db_train{i};
        a = whos('name');
        if(strcmp(a.class ,'cell'))
           name = name{1};   
        end
        %img = imread(name);
        img = ObjectDetection(name,'HaarCascades\haarcascade_frontalface_alt.mat');
        img = imresize(img, [128,128]);
        features_train(i, :) = extractHOGFeatures(img);        
end
% timeElapsed = toc;
% disp(sprintf('Phase de calcul des descripteurs: %0.5g sec',timeElapsed))
%% Création d'un classifieur à [num_label] classes en utilisant fitcecoc
% 
% tic
hogsvm_faceClassifier = fitcecoc(features_train,label_train);
hogsvm_train_results = struct('hogsvm_faceClassifier', hogsvm_faceClassifier);
% timeElapsed = toc;
% disp(sprintf('Phase de calcul du classifieur: %0.5g sec',timeElapsed))

if(save_Results == 1)
    %% Saving the results    
    db_record = datestr(now,'mmmm_dd_yyyy_HH_MM_SS_AM');
    filename = strcat('HOGSVM_train_',db_name,'_', config_file, db_record,'.mat');
    cd results
    save(filename, 'face_db_train', 'label_train', 'hogsvm_train_results', '-v7.3');
    cd ..
end
