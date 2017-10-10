% Programme Matlab pour la reconnaissance de visage. 
% M'Hand Kedjar - August 2016
%% �tAPE 1: iMPORTATION DE LA BASE DE DONN�E
% imgFolder est le dossier qui contient la base de donn�es
% imgFolder contient des sous-dossiers
% Chaque sous-dossier contient un nombre d'images associ�es � une seule
% personne
% imageSet cr�e une structure qui contient toutes les images, et le
% param�tre 'recursive' signifie qu'� chaque image extraite sera assign�e
% une �tiquette qui sera le nom du sous-dossier. 
clear all, close all, clc
tic
imgFolder = 'E:\_IMPORTANT\DATASETS\01_ORLDatabase\ORLDatabase';
faceDatabase = imageSet(imgFolder,'recursive');

%% Affichage des caract�ristiques de la base de donn�es
% Nombre d'images
num_img = 0;
for i = 1:numel(faceDatabase)
    num_img = num_img + faceDatabase(i).Count; 
end
% Nombre d'�tiquettes
num_label = numel(faceDatabase);
disp(sprintf('Nombre d\''images: %d, Nombre d\''�tiquettes: %d',num_img, num_label))

%% Division de la base de donn�es en deux sous-ensembles
% le premier pour l'apprentissage (80%), et le deuxi�me pour le test (20%)
[training,test] = partition(faceDatabase,[0.6 0.4]);
num_img_test = 0;
num_img_training = 0;
% nombre d'image dans le sous-ensemble d'apprentissage
for i = 1:numel(training)
    num_img_training = num_img_training + training(i).Count; 
end
% nombre d'image dans le sous-ensemble test
for i = 1:numel(test)
    num_img_test = num_img_test + test(i).Count; 
end
timeElapsed = toc;
disp(sprintf('Nombre d\''images apprentissage: %d, Nombre d\''images test: %d',num_img_training, num_img_test))
disp('Temps de calcul')
disp(sprintf('Phase de pr�paration des donn�es: %0.5g sec',timeElapsed))
