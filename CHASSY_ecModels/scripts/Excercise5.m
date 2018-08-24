%%************* CHASSY modelling tutorial: Excercise #5 *******************
%Paste your GECKO folder here
GECKOpath  = '/Users/ivand/Documents/GitHub/GECKO';
%Save current folder path
current = pwd;
%% 1) Load models
load('../models/ecGEMs/ecYeastGEM.mat');
load('../models/ecGEMs/ecYeastGEM_batch.mat');
load('../models/GEMs/yeast_7_6.mat');

cd ([GECKOpath '/Matlab_Module/limit_proteins'])
[ecModelProt,enzUsages,modifications] = constrainEnzymes(ecModel,0.4245,0.5,pIDs,cell2mat(absValues),0.1,1.1);




