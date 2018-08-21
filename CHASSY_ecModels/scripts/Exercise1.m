%************* CHASSY modelling tutorial: Excercise #1 ********************

% 1.1) Import the model from SBML format to a matlab structure. 
model = importModel('yeast_7.6_cobra.xml','true','false');
% 2)  Export the model to an EXCEL file to get a comprenhensible overview
%     of the contained information
exportToExcelFormat(model,'yeast_7_6.xlsx');
% 2a) How many rxns, mets, genes, comps are there in the model?
disp(model)
% For a more detailed output:
printModelStats(model,false,false);
disp(['Number of Compartments: ' num2str(length(model.comps))])
% 2b) How many rxns are reversible?
disp(['Number of reversible rxns: ' num2str(length(find(model.rev)))])
% 2c) In how many rxns is the gene YEL039C present?
YEL039C      = find(strcmpi(model.genes,'YEL039C'));
nRxnsForGene = sum(model.rxnGeneMat(:,YEL039C));
disp(['Gene YEL039C is present in ' num2str(nRxnsForGene) ' reactions'])
% 2d) Gene associations for r_0195 and r_0198
rxnPos = strcmpi(model.rxns,'r_0195');
disp(['Gene association for r_0195: ' model.grRules{rxnPos}])
rxnPos = strcmpi(model.rxns,'r_0198');
disp(['Gene association for r_0198: ' model.grRules{rxnPos}])
% 2e) r_0438 equation
printModel(model,'r_0438')
