%% MTI830 - Forage de textes et de données audiovisuelles
% M'Hand Kedjar - August 2016
% Function that loads the given database
function [face_db,...
          face_db_cropped_resized,...
          face_db_cropped_not_resized,...
          db_name] = ...
              MTI830_Face_Recognition_load_database(face_db_id, software_phase)
%% Choosing the Face Database
All_face_db_path = {'01_ORLDatabase\ORLDatabase',...                    
                    '02_YALEDatabase\TheYaleFaceDatabaseCropped_old',...
                    '03_CaltechHumanFaceDatabase\caltech',...                    
                    '04_Labelled_Faces_in_the_Wild\lfw'...
                    '05_ColorFeret\ColorFeret\images'};
                % '04_Labelled_Faces_in_the_Wild\lfw-deepfunneled',...

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
                
All_face_db_name = {'ORL_db',...
                    'YALE_db',...
                    'CALTECH_db',...                    
                    'LFW_db',...
                    'ColorFeret_db'};
                % 'LFWCropped_db',...
              
% 1. ORL Database: 10 different images in PGM format, of each of 40 distinct subjects. 
% For some subjects, the images were taken at different times, varying the 
% lighting, facial expressions (open / closed eyes, smiling / not smiling)
% and facial details (glasses / no glasses). All the images were taken 
% against a dark homogeneous background with the subjects in an upright, 
% frontal position (with tolerance for some side movement).

% 2. Yale Database: Contains 165 grayscale images in GIF format of 15 
% individuals. There are 11 images per subject, one per different facial
% expression or configuration: center-light, w/glasses, happy, left-light,
% w/no glasses, normal, right-light, sad, sleepy, surprised, and wink.

% 3. Caltech Database: Contains 450 color pictures in JPEG format of 11
% women, 17 men, and 3 cartoonned faces 

% 4. Labelled Faces in the Wild: Contains 13.233 color pictures in JPG
% format of 5749 different people. 1680 subject have 2 or more pictures

% 5. ColorFeret: Contains 11338 color pictures in PPM format of 994
% different people. 

if(software_phase = 'test'){
	computer_name = getenv('COMPUTERNAME');
	db_name = All_face_db_name{face_db_id};

	if(strcmp(computer_name,'DESKTOP-L50AI85'))
		face_db_main_path = 'K:\_IMPORTANT\DATASETS';    
	end

	if(strcmp(computer_name,'LOGTI045477'))
		face_db_main_path = 'E:\datasets';   
	end
	
face_db = strcat( face_db_main_path,'\',All_face_db_path{face_db_id});
face_db_cropped_resized = strcat(face_db_main_path,'\', All_face_db_path_cropped_resized{face_db_id});
face_db_cropped_not_resized = strcat(face_db_main_path,'\', All_face_db_path_cropped_not_resized{face_db_id});
end

if(strcmp(software_phase , 'release')){
	All_face_db_path = {'orl',...                    
                    'yale',...
                    'caltech'};            
                    
	face_db_main_path = '..\datasets';

face_db = strcat( face_db_main_path,'\',All_face_db_path{face_db_id});
face_db_cropped_resized = strcat( face_db_main_path,'\',All_face_db_path{face_db_id});
face_db_cropped_not_resized = strcat( face_db_main_path,'\',All_face_db_path{face_db_id});
}


  

%face_db = strcat('E:\datasets\',All_face_db_path{face_db_choice});
