%% MTI830 - Forage de textes et de données audiovisuelles
% M'Hand Kedjar - August 2016
function [sift_train_results] = SIFT_face_recognition_training(...
                                              face_db_train,...
                                              label_train,...
                                              face_db_id,...
                                              db_name,...
                                              config_file,...
                                              save_Results)                                        
                                     
count_train = numel(face_db_train);
sift_train_results = cell(1,count_train );
name = face_db_train{1};
a = whos('name');

if(strcmp(a.class ,'cell'))
   name = name{1};   
end
image_info = imfinfo(name);

for i = 1:count_train                
    personLabel = label_train{i};                           
    name = face_db_train{i};
    a = whos('name');

    if(strcmp(a.class ,'cell'))
        name = name{1};   
    end
    %Run the object detect on the training image.
    imgcrop = ObjectDetection(name,'HaarCascades\haarcascade_frontalface_alt.mat'); 
    
    namesplt = strsplit(name,'\');
    imgcroploc = strcat('temp\ctrain_',namesplt{end-1},'_',namesplt{end});
    imwrite(imgcrop,imgcroploc,image_info.Format);     
    %Extract the SIFT features
    [image, descrips, locs] = sift(imgcroploc);   
    %Save the feature + person label in a structure.
    sift_train_results{i} = struct('image', image,...
                                   'descriptors',descrips ,...
                                   'locs',locs,...
                                   'personLabel', personLabel,...
                                   'name',name);      
end  
    
if(save_Results == 1)
   db_record = datestr(now,'mmmm_dd_yyyy_HH_MM_SS_AM');
   filename = strcat('SIFT_train_',db_name,...
        '_', config_file, db_record,'.mat');
   cd results
        save(filename, 'SIFT_train_results','-v7.3');
   cd ..
end
