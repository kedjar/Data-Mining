%function MTI830_Face_Recognition_crop_database(face_db)
%% MTI830 - Forage de textes et de données audiovisuelles
% M'Hand Kedjar - August 2016
clc;clear
%% Choosing the Face Database
All_face_db_path = {'01_ORLDatabase\ORLDatabase',...
                    '02_YALEDatabase\TheYaleFaceDatabaseCropped_old',...
                    '03_CaltechHumanFaceDatabase\caltech',...                    
                    '04_Labelled_Faces_in_the_Wild\lfw-deepfunneled'...
                    '05_ColorFeret\ColorFeret\images'};

All_face_db_path_cropped_resized = {'01_ORLDatabase\ORLDatabaseCroppedResized',...
                    '02_YALEDatabase\TheYaleFaceDatabaseCroppedResized',... 
                    '03_CaltechHumanFaceDatabase\caltechCroppedResized',...                    
                    '04_Labelled_Faces_in_the_Wild\lfw-deepfunneledCroppedResized'...
                    '05_ColorFeret\ColorFeret\imagesCroppedResized'};
                
All_face_db_path_cropped_not_resized = {'01_ORLDatabase\ORLDatabaseCroppedNotResized',...
                    '02_YALEDatabase\TheYaleFaceDatabaseCroppedNotResized',... 
                    '03_CaltechHumanFaceDatabase\caltechCroppedNotResized',...                    
                    '04_Labelled_Faces_in_the_Wild\lfw-deepfunneledCroppedNotResized'...
                    '05_ColorFeret\ColorFeret\imagesCroppedNotResized'};

addpath('pca','sift','hogsvm')
face_db_main_path = 'E:\datasets';

for face_db_id = 4:5
    face_db = strcat(face_db_main_path,'\',All_face_db_path{face_db_id});
    face_db_cropped_resized = strcat(face_db_main_path,'\', All_face_db_path_cropped_resized{face_db_id});
    face_db_cropped_not_resized = strcat(face_db_main_path,'\', All_face_db_path_cropped_not_resized{face_db_id});
    
    imgSet = imageSet(face_db , 'recursive');
    image_path = imgSet(1).ImageLocation{1};
    image_info = imfinfo(image_path);
    
    if(face_db_id == 1)
        r = image_info.Height;
        c = image_info.Width;
    end
    
    if(face_db_id == 2)
        r = 82;
        c = 82;
    end
    
    if(face_db_id == 3)
        r = 342;
        c = 342;
    end
    
    if(face_db_id == 4)
        r = 146;
        c = 146;
    end
    
     if(face_db_id == 5)
        r = 384;
        c = 256;
     end
    for i = 1:numel(imgSet)
        mkdir(face_db_cropped_resized,imgSet(i).Description)
        mkdir(face_db_cropped_not_resized,imgSet(i).Description)
        for j = 1:imgSet(i).Count;
            image_path = imgSet(i).ImageLocation{j};
            [pathstr,name,ext] = fileparts(image_path);
            pathstr_split = strsplit(pathstr,'\');
            
            image_crop_not_resized = ObjectDetection(image_path,'HaarCascades\haarcascade_frontalface_alt.mat');
            image_crop_path_not_resized = strcat(face_db_main_path,'\',All_face_db_path_cropped_not_resized{face_db_id}, '\', pathstr_split{end},'\',name,'_cropped_not_resized',ext);
            
            image_crop_resized = imresize(image_crop_not_resized, [r c]);
            image_crop_path_resized = strcat(face_db_main_path,'\',All_face_db_path_cropped_resized{face_db_id}, '\', pathstr_split{end},'\',name,'_cropped_and_resized',ext);           
            
            imwrite(image_crop_not_resized,image_crop_path_not_resized,image_info.Format);
            imwrite(image_crop_resized,image_crop_path_resized,image_info.Format);
        end
    end
end
            
clc            
       