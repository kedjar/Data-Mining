%% MTI830 - Forage de textes et de données audiovisuelles
% M'Hand Kedjar - August 2016
% this script runs three matlab function
% the 1st will load the database, crop all the images, 
% and save them to a new database
% the 2nd generate sift features for all the images in the 
% database and save the results
% the 3rd runs the main program for face recognition
MTI830_Face_Recognition_crop_database;
MTI830_Face_Recognition_generate_sift_database;
MTI830_Face_Recognition_main;