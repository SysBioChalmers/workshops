% Proteomics integration
% modeling tutorial: Exercise #5 
%
%  Incorporation of proteomics data for S. cerevisiae @0.1 dilution rate,
%  growing on glucose, pH 5.5, 28 y 32 celsius
%
%
% Ivan Domenzain.	Last modified 2020-02-10

%Load models 
current = pwd;
ecModel       = open('../models/ecModel.mat');
ecModel       = ecModel.ecModel;
ecModel_batch = open('../models/ecModel_batch.mat');
ecModel_batch = ecModel_batch.ecModel_batch;

%Clone the necessary repos:
rmdir ('GECKO','s')
git('clone https://github.com/SysBioChalmers/GECKO.git')
cd GECKO
git('pull')
%Locate the correct branch
git('checkout feat-add_utilities') 
%Transfer proteomics dataset to GECKO
copyfile('../../data/abs_proteomics.txt','databases')
copyfile('../../data/fermentationData.txt','databases')
cd geckomat/utilities/integrate_proteomics

%Parameters
grouping   = [3 3];
flexFactor = 1.05;
generate_protModels(ecModel,grouping,'ecYeastGEM',flexFactor,ecModel_batch);
cd (current)

