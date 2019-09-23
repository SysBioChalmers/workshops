%YeastDoc modelling tutorial: Excercise #1 
% Exercise1
%
%  Model structure exploration and modification. based on the latest
%  version of yeastGEM (GitHub: https://github.com/SysBioChalmers/yeast-GEM)
%
% Ivan Domenzain.	Last modified 2019-09-23
%

%% Model exploration

% 3) Load the model MATLAB structure
load('../models/yeastGEM.mat')
% 3a) How many rxns, mets, genes, comps are there in the model?
disp(model)
% For a more detailed output:
printModelStats(model,false,false);
% 3b) How many rxns are reversible?
%First approach, using the REV field
disp(['Number of reversible rxns: ' num2str(length(find(model.rev)))])
fprintf('\n')
%Second approach, using the LB values
disp(['Number of reversible rxns: ' num2str(length(find(model.lb<0)))])
fprintf('\n')
% 3c) In how many rxns is the gene YEL039C present?
YEL039C      = find(strcmpi(model.genes,'YEL039C'));
nRxnsForGene = sum(model.rxnGeneMat(:,YEL039C));
shortName    = model.geneShortNames{YEL039C};
disp(['Gene YEL039C (' shortName ') is present in ' num2str(nRxnsForGene) ' reactions'])
fprintf('\n')
% 3d) Gene associations for r_0195 and r_0198
rxnPos = strcmpi(model.rxns,'r_0109');
disp(['Gene association for r_0109: ' model.grRules{rxnPos}])
fprintf('\n')
rxnPos = strcmpi(model.rxns,'r_0112');
disp(['Gene association for r_0112: ' model.grRules{rxnPos}])
fprintf('\n')
% 3e) r_0438 equation
printModel(model,'r_0438')
fprintf('\n')
%% Keeping track of GEMs modifications with GitHub

% 5) Lets introduce a heterologous set of reactions for the production of
% octanoic acid

% Define reactions equations
MCR_rxn        = 'malonyl-CoA[c] + 2 NADPH[c] => 3-hydroxypropionic acid[c] + 2 NADP(+)[c]';
transport_3HP  = '3-hydroxypropionic acid[c] => 3-hydroxypropionic acid[e]';
exchange_3HP   = '3-hydroxypropionic acid[e] => ';
rxnsToAdd.equations = {MCR_rxn; transport_3HP; exchange_3HP}; 
% Define reaction names
MCR_rxn       = '3HP synthesis';
transport_3HP = '3HP transport';
exchange_3HP  = '3HP exchange';
rxnsToAdd.rxns     = {MCR_rxn; transport_3HP; exchange_3HP};
rxnsToAdd.rxnNames = rxnsToAdd.rxns;
% Define objective and bounds
rxnsToAdd.c  = [0 0 0];
rxnsToAdd.lb = [0 0 0];
rxnsToAdd.ub = [1000 1000 1000];

% Metabolites to Add
metsToAdd.mets          = {'s_3HP_c' 's_3HP_e'};
metsToAdd.metNames      = {'3-hydroxypropionic acid' '3-hydroxypropionic acid'};
metsToAdd.compartments  = {'c' 'e'};

%genes to add
genesToAdd.genes          = {'MCR'};
genesToAdd.geneShortNames = {'MCR'};
rxnsToAdd.grRules         = {'MCR' '' ''};
% Introduce changes to the model
model_3HP = addGenesRaven(model,genesToAdd);
model_3HP = addMets(model_3HP,metsToAdd);
model_3HP = addRxns(model_3HP,rxnsToAdd,3);
%Standardize gene related fields
[grRules, rxnGeneMat] = standardizeGrRules(model_3HP,true);
model_3HP.grRules     = grRules;
model_3HP.rxnGeneMat  = rxnGeneMat;

% Export to SBML format and save MATLAB structure of the new model
exportModel(model_3HP,'../models/yeastGEM.xml')
save('../models/model_3HP.mat',' model_3HP')
cd (current)
clear
% Check changes in GitHub desktop
