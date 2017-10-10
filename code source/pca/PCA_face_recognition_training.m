%% MTI830 - Forage de textes et de données audiovisuelles
% M'Hand Kedjar - August 2016
function [pca_train_results] = PCA_face_recognition_training(...
                                               face_db_train,...
                                               label_train,...
                                               face_db_id,...
                                               db_name,...
                                               config_file,...
                                               img_size,...
                                               save_Results) %#ok<INUSL>
count_train = numel(face_db_train);
%img_size = 128*128;

name = face_db_train{1};
a = whos('name');
if(strcmp(a.class ,'cell'))
   name = name{1};   
end

img = imread(name);
r_temp = size(img,1);
c_temp = size(img,2);
X = zeros(r_temp * c_temp,count_train);
for i = 1 : count_train   
    name = face_db_train{i};
    a = whos('name');
    if(strcmp(a.class ,'cell'))
        name = name{1};   
    end
    %
    %img = ObjectDetection(name,'HaarCascades\haarcascade_frontalface_alt.mat');
    %img = imresize(img, [img_size(1),img_size(2)]);
    % 
    %        
    img = imread(name);
    %
    img_info = imfinfo(name);
    if(~strcmp(img_info.ColorType,'grayscale'))
        img = rgb2gray(img);
    end
     
        
%     if(face_db_id == 3 && size(img,2) ~= 192)
%         img = imresize(img, [168,192]);
%     end
   [r , c] = size(img);
    temp = reshape(img',r*c,1);        
      
    X(:,i) = temp;               
end
mean_img = mean(X,2);
% count_train = size(X,2);
A = zeros(r_temp * c_temp,count_train);
for i=1 : count_train
    %i
    temp = double(X(:,i)) - mean_img;
    A(:,i) = temp; 
end
L= A' * A;
[V,D]=eig(L); 

L_eig_vec = [];
for i = 1 : size(V,2) 
    %i
    if( D(i,i) > 1 )
        L_eig_vec = [L_eig_vec V(:,i)];
    end
end
eigenfaces = A * L_eig_vec;
projectimg = [ ];  
for i = 1 : size(eigenfaces,2)
    %i
    temp = eigenfaces' * A(:,i);
    projectimg = [projectimg temp];
end

[pca_train_results] = struct('mean_img' , mean_img , 'projectimg', projectimg , 'eigenfaces' , eigenfaces);

if(save_Results == 1)
    %% Saving the results    
    db_record = datestr(now,'mmmm_dd_yyyy_HH_MM_SS_AM');
    filename = strcat('PCA_train_',db_name,'_', config_file, db_record,'.mat');
    cd results
    save(filename, 'face_db_train', 'label_train', 'mean_img',  'projectimg', 'eigenfaces','-v7.3');
    cd ..
end




