%%************* CHASSY modelling tutorial: Excercise #1 ********************
% 1.1) Load the model MATLAB structure
load('../models/GEMs/yeast_7_6.mat')
% 2)  Export the model to an EXCEL file to get a comprenhensible overview
%     of the contained information
exportToExcelFormat(model,'../models/GEMs/yeast_7_6.xlsx');
% 3a) How many rxns, mets, genes, comps are there in the model?
disp(model)
% For a more detailed output:
printModelStats(model,false,false);
disp(['Number of Compartments: ' num2str(length(model.comps))])
fprintf('\n')
% 3b) How many rxns are reversible?
disp(['Number of reversible rxns: ' num2str(length(find(model.rev)))])
fprintf('\n')
% 3c) In how many rxns is the gene YEL039C present?
YEL039C      = find(strcmpi(model.genes,'YEL039C'));
nRxnsForGene = sum(model.rxnGeneMat(:,YEL039C));
disp(['Gene YEL039C is present in ' num2str(nRxnsForGene) ' reactions'])
fprintf('\n')
% 3d) Gene associations for r_0195 and r_0198
rxnPos = strcmpi(model.rxns,'r_0195');
disp(['Gene association for r_0195: ' model.grRules{rxnPos}])
fprintf('\n')
rxnPos = strcmpi(model.rxns,'r_0198');
disp(['Gene association for r_0198: ' model.grRules{rxnPos}])
fprintf('\n')
% 3e) r_0438 equation
printModel(model,'r_0438')
fprintf('\n')
%% Keeping track of GEMs modifications with GitHub

% 5) Lets introduce a heterologous set of reactions for the production of
% octanoic acid

% Define reactions equations
synthesisRxn = 'H2O[p] + octanoyl-CoA[p] => octanoic acid[p] + acetyl-CoA[p]';
transportP   = 'octanoic acid[p] => octanoic acid[c]';
transportC   = 'octanoic acid[c] => octanoic acid[e]';
exchangeRxn  = 'octanoic acid[e] => ';

rxnsToAdd.equations = {synthesisRxn; transportP; transportC; exchangeRxn}; 
% Define reactions name
synthesisRxn = 'octanoic acid synthesis';
transportP   = 'octanoic acid transport p';
transportc   = 'octanoic acid transport c';
exchangeRxn  = 'octanoic acid exchange';
rxnsToAdd.rxns     = {synthesisRxn; transportP; transportC; exchangeRxn};
rxnsToAdd.rxnNames = rxnsToAdd.rxns;
% Define objective and bounds
rxnsToAdd.c  = [0 0 0 0];
rxnsToAdd.lb = [0 0 0 0];
rxnsToAdd.ub = [1000 1000 1000 1000];
% Metabolites to Add
metsToAdd.mets          = {'s_3717';'s_3718';'s_3719'};
metsToAdd.metNames      = {'octanoic acid';'octanoic acid';'octanoic acid'};
metsToAdd.compartments  = {'p';'c';'e'};
% Introduce changes to the model
octModel = addMets(model,metsToAdd);
octModel = addRxns(octModel,rxnsToAdd,3);
% Export to SBML format and save MATLAB structure of the new model
current = pwd;
cd ../models
% Restore COBRA fields removed by addRxns
octModel.rules = model.rules;
saveModelSBML(octModel,'yeast_7_6',false)
save('octAcidModel.mat','octModel')
cd (current)
clear
% Check changes in GitHub desktop
