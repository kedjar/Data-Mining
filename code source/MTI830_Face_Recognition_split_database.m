%% MTI830 - Forage de textes et de données audiovisuelles
% M'Hand Kedjar - August 2016
% Function that splits the database to a training and a test set
function [face_db_train,...
          label_train,...
          face_db_test,...
          label_test,...
          face_db_train_sift,...
          face_db_train_pca,...
          face_db_train_hogsvm,...
          face_db_test_sift,...
          face_db_test_pca,...
          face_db_test_hogsvm,...
          config_file,...
          img_size] = ...
              MTI830_Face_Recognition_split_database(face_db ,...
                                                     face_db_cropped_resized,...
                                                     face_db_cropped_not_resized,...
                                                     face_db_id,...
                                                     ratio_train)
    
%% Generating an imageSet
% Here we define the split between the training and the test set 
% First, we need to create an image set which will contain all the images
% The "recursive" option will create a label for each image, which will be
% very useful when calculating the final accuracy. 
imgSet = imageSet(face_db , 'recursive');
%percentage = ratio_train; 

if(face_db_id == 1) % 1. ORL Database
    n_min = 10; % Min images per person
    n_max = 10; % Max images per person
    n_people = 40; % number of different people
    n_images = 400; % total number of images
    %percentage = 80/100; % percentage of pictures to use in training
    %p = 8; %  number of pictures per person to use in training % randi([2,8]);  
    r = 112; c = 92; img_size = [r c];
end
if(face_db_id == 2) % 2. Yale Database
    n_min = 11;
    n_max = 11; %
    n_people = 15;
    n_images = 165;
    %percentage = 80/100;
    %p = 9; % randi([2,9]);    
    r = 116; c = 98; img_size = [r c];
end
if(face_db_id == 3) % 3. Caltech Database
    n_min = 1;
    n_max = 29; %
    n_people = 31;
    n_images = 450;
    %percentage = 80/100;
    %p = 9; % randi([2,9]);    
    r = 896; c = 592; img_size = [r c];
end
if(face_db_id == 4) % 4. Labelled Faces in the Wild
    n_min = 1;
    n_max = 530; %
    n_people = 5749;
    n_images = 13233;
    %percentage = 80/100;
    %p = 52; % randi([2,52]);    
    r = 250; c = 250; img_size = [r c];
end

if(face_db_id == 5) % 5. ColorFeret
    n_min = 5;
    n_max = 11; %
    n_people = 994;
    n_images = 11338;
    %percentage = 80/100;
    %p = 52; % randi([2,52]);    
    r = 512; c = 768; img_size = [r c];
end


%% Randomnly Generating the training and test Data and labels
% We will restrict the data to people who have minimum of 2 images
p = floor(ratio_train * n_max);
count_train = 0; % Nombre of training images
count_test = 0; % Nombre of test images
face_db_train = cell(1,p*n_people);
label_train = cell(1,p*n_people);
face_db_test = cell(1,(n_max-p)*n_people);
label_test = cell(1,(n_max-p)*n_people);

if(n_min ~= 1) 
    for person = 1:numel(imgSet)        
        index_random = randperm(imgSet(person).Count);
        p = floor(ratio_train * imgSet(person).Count);
        index_train = index_random(1:p);
        index_test = index_random(p+1:end);
        
        for i = 1:numel(index_train)
            count_train = count_train + 1;
            face_db_train{count_train} = imgSet(person).ImageLocation{index_train(i)};
            label_train{count_train} = imgSet(person).Description;
        end
        
        for j = 1:numel(index_test)
            count_test = count_test + 1;
            face_db_test{count_test} = imgSet(person).ImageLocation{index_test(j)};
            label_test{count_test} = imgSet(person).Description;
        end
    end
end

if(n_min == 1) 
    for person = 1:numel(imgSet) 
        if(imgSet(person).Count > 1)
            index_random = randperm(imgSet(person).Count);
            p = floor(ratio_train * imgSet(person).Count);
            index_train = index_random(1:p);
            index_test = index_random(p+1:end);
            
            for i = 1:numel(index_train)
                count_train = count_train + 1;
                face_db_train{count_train} = imgSet(person).ImageLocation{index_train(i)};
                label_train{count_train} = imgSet(person).Description;
            end
            
            for j = 1:numel(index_test)
                count_test = count_test + 1;
                face_db_test{count_test} = imgSet(person).ImageLocation{index_test(j)};
                label_test{count_test} = imgSet(person).Description;
            end
        end
    end
end

config_file = strcat(num2str(count_train),'_',...
                      num2str(count_test),'_',...
                      num2str(n_max),'_',...
                      num2str(n_people),'_',...
                      num2str(ratio_train),'_',...
                      num2str(r),'_', ...
                      num2str(c),'_');

% Removing empty cells
face_db_train = face_db_train(~cellfun('isempty',face_db_train));  
label_train = label_train(~cellfun('isempty',label_train));  
face_db_test = face_db_test(~cellfun('isempty',face_db_test));  
label_test = label_test(~cellfun('isempty',label_test));

face_db_train_sift = cell(1,numel(face_db_train));
face_db_train_pca = cell(1,numel(face_db_train));
face_db_train_hogsvm = cell(1,numel(face_db_train));

for i = 1:numel(face_db_train)
    [pathstr,name,ext] = fileparts(face_db_train{i}); 
    pathstr_split = strsplit(pathstr,'\');
    
    face_db_train_sift{i} = strcat(face_db_cropped_not_resized ,'\',pathstr_split(end),'\',name,'_cropped_not_resized',ext) ;
    face_db_train_pca{i} = strcat(face_db_cropped_resized ,'\',pathstr_split(end),'\',name,'_cropped_and_resized',ext);
    face_db_train_hogsvm{i} = strcat(face_db_cropped_resized ,'\',pathstr_split(end),'\',name,'_cropped_and_resized',ext);
end

face_db_test_sift = cell(1,numel(face_db_test));
face_db_test_pca = cell(1,numel(face_db_test));
face_db_test_hogsvm = cell(1,numel(face_db_test));

for i = 1:numel(face_db_test)
    [pathstr,name,ext] = fileparts(face_db_test{i});  
    pathstr_split = strsplit(pathstr,'\');
    face_db_test_sift{i} = strcat(face_db_cropped_not_resized ,'\',pathstr_split(end),'\',name,'_cropped_not_resized',ext) ;
    face_db_test_pca{i} = strcat(face_db_cropped_resized ,'\',pathstr_split(end),'\',name,'_cropped_and_resized',ext);
    face_db_test_hogsvm{i} = strcat(face_db_cropped_resized ,'\',pathstr_split(end),'\',name,'_cropped_and_resized',ext);
end

fprintf('\tTotal set: %d\n\tTraining subset: %d images\n\tTest subset: %d images \n',n_images, count_train, count_test)