% Proteomics integration
% modeling tutorial: Exercise #5 
%
%  Incorporation of proteomics data for S. cerevisiae @0.1 dilution rate,
%  growing on glucose, pH 5.5, 28 y 32 celsius
%
%
% Ivan Domenzain.	Last modified 2020-02-14

%Load models 
current = pwd;
ecModel = open('../models/ecYeastGEM.mat');
ecModel = ecModel.ecModel;
ecModel_batch = open('../models/ecYeastGEM_batch.mat');
ecModel_batch = ecModel_batch.ecModel_batch;
% Clone the necessary repos:

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

% Incorporate proteomics
grouping   = [3 3 3 3]; %Our dataset contains three replicates per condition
flexFactor = 1.05;  %Allowable flexibilization factor for fixing glucose uptake rate
%Use GECKo utilities for proteomics integration
cd geckomat/utilities/integrate_proteomics
generate_protModels(ecModel,grouping,'ecYeastGEM',flexFactor,ecModel_batch);
cd (current)
close all
%Transfer output models to the models folder in the tutorial repo
mkdir('../models/prot_constrained')
copyfile('GECKO/models/prot_constrained/ecYeastGEM/**','../models/prot_constrained')
%remove GECKO repository
rmdir('GECKO','s')
clc

% Analyze flux distributions and enzyme usages
%Create a table with all flux distributions for all condition-dependent
%models
conditions = {'Std';'HiT';'LpH';'Osm'};
cd complementary
[~,enzTable_abs,~] = compare_ecModels_fluxDist(conditions,'ecYeastProt');
%Show absolute usages for all enzymes with a coefficient of variation greater or
%equal to 1 across conditions
usages = cell2mat(table2cell(enzTable_abs(:,2:5)));
CV     = std(usages,0,2)./mean(usages,2);
CV(isnan(CV)) = 0;
[CV,sorted]= sort(CV,1,'descend');
disp('Enzyme usages sorted by their coefficient of variation across conditions')
disp(enzTable_abs(sorted(CV>=1),:))
%Run differential analysis on the flux and enzyme usage level for each
%stress condition compared to the reference
%Load ecModel+proteomics for standard conditions
ref = load('../../models/prot_constrained/ecYeastGEM_Std.mat');
ref = ref.ecModelP;
%The function diff_FluxDist_analysis performs the required analysis, in
%order to get to know its expected inputs let's display its help window
help diff_FluxDist_analysis
%Set the values for the requested inputs
bioRxn   = ref.rxns(find(strcmpi(ref.rxnNames,'growth')));
Csource  = 'D-glucose exchange (reversible)';
Drate    = 0.1; %From experiments!

for i=2:length(conditions)
    cond = conditions{i};
    condModel  = load(['../../models/prot_constrained/ecYeastGEM_' cond '.mat']);
    condModel  = condModel.ecModelP;
    outputName = ['Std_vs_' cond '.txt'];
    resultStruct = diff_FluxDist_analysis(ref,condModel,bioRxn,Csource,Drate,outputName);
    % Show the top 20 "up-regulated" fluxes and enzymes
    temp = sortrows(resultStruct.rxns,5,'descend');
    disp(['The top 10 upregulated reaction fluxes for ' cond ' are: '])
    disp(temp(1:10,:))
    disp(' ')
    temp = sortrows(resultStruct.proteins,4,'descend');
    disp(['The top 10 upregulated  enzymes for ' cond ' are: '])
    disp(temp(1:10,:))
    % Show the top 20 "down-regulated" fluxes and enzymes
    temp = sortrows(resultStruct.rxns,5,'ascend');
    disp(['The top 10 downregulated reaction fluxes for ' cond ' are: '])
    disp(temp(1:10,:))
    disp(' ')
    temp = sortrows(resultStruct.proteins,4,'ascend');
    disp(['The top 10 downregulated  enzymes for ' cond ' are: '])
    disp(temp(1:10,:))
end
cd (current)


