% Proteomics integration
% modeling tutorial: Exercise #5 
%
%  Incorporation of proteomics data for S. cerevisiae @0.1 dilution rate,
%  growing on glucose, pH 5.5, 28 y 32 celsius
%
%
% Ivan Domenzain.	Last modified 2020-02-12

%Load models 
current = pwd;
ecModel       = open('../models/ecYeastGEM.mat');
ecModel_batch = open('../models/ecYeastGEM_batch.mat');

%% Clone the necessary repos:

%delete GECKO in case that a previous copy exists here
if isfolder('GECKO') 
    rmdir ('GECKO','s')
end
git('clone https://github.com/SysBioChalmers/GECKO.git')
cd GECKO
git('pull')
%checkout the correct branch for proteomics incorporation
git('checkout feat-add_utilities') 
%Transfer proteomics dataset and fermentation data (exchange fluxes, Ptot and
% dilution rates) from ../data to GECKO/databases
copyfile('../../data/abs_proteomics.txt','databases')
copyfile('../../data/fermentationData.txt','databases')

%% Incorporate proteomics
grouping   = [3 3]; %Our dataset contains three replicates per condition
flexFactor = 1.05;  %Allowable flexibilization factor for fixing glucose uptake rate
%Use GECKo utilities for proteomics integration
cd geckomat/utilities/integrate_proteomics
generate_protModels(ecModel,grouping,'ecYeastGEM',flexFactor,ecModel_batch);
cd (current)
%Transfer output models to the models folder in the tutorial repo
mkdir('../models/prot_constrained')
copyfile('GECKO/models/prot_constrained/ecYeastGEM/**','../models/prot_constrained')
%remove GECKO repository
rmdir('GECKO','s')

%% Analyze flux distributions and enzyme usages
clc
%Run differential analysis on the flux and enzyme usage level
model_Std = load('../models/prot_constrained/ecYeastGEM_Std.mat');
model_HiT = load('../models/prot_constrained/ecYeastGEM_HiT.mat');
model_Std = model_Std.ecModelP;
model_HiT = model_HiT.ecModelP;
cd complementary
%The function diff_FluxDist_analysis performs the required analysis, in
%order to get to know its expected inputs let's display its help window
help diff_FluxDist_analysis
%Retrieve the necessary inputs from the models
bioRxn  = model_Std.rxns(find(strcmpi(model_Std.rxnNames,'growth')));
Csource = 'D-glucose exchange (reversible)';
Drate   = 0.1; %From experiments!
fileName = 'Std_vs_HiT.txt';
resultStruct = diff_FluxDist_analysis(model_Std,model_HiT,'r_2111','D-glucose exchange (reversible)',0.099,'Std_vs_HiT.txt');

% Show the top 20 "up-regulated" fluxes and enzymes
temp = sortrows(resultStruct.rxns,5,'descend');
disp('The top 20 upregulated reaction fluxes are: ')
disp(temp(1:20,:))
disp(' ')
temp = sortrows(resultStruct.proteins,4,'descend');
disp('The top 20 upregulated  enzymes are: ')
disp(temp(1:20,:))
% Show the top 20 "down-regulated" fluxes and enzymes
temp = sortrows(resultStruct.rxns,5,'ascend');
disp('The top 20 downregulated reaction fluxes are: ')
disp(temp(1:20,:))
disp(' ')
temp = sortrows(resultStruct.proteins,4,'ascend');
disp('The top 20 downregulated  enzymes are: ')
disp(temp(1:20,:))
