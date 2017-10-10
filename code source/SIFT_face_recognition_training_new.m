                 
count_train = numel(face_db_train);
sift_train_results = cell(1,count_train );

name = face_db_train{1};
image_info = imfinfo(name);

for i = 1:count_train                
    personLabel = label_train{i};                           
    name = face_db_train{i};    
    sift_train_results{i} = load();      
end  
    
