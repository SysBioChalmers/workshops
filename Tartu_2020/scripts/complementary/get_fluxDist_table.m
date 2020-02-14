function [rxnsTable,enzTable_abs,enzTable_rel] = get_fluxDist_table(ecModelP)
%get_fluxDist_table
%   
% Function that gets an ecModel and constructs tables for fluxes and enzyme
% usages in absolute and relative terms (if proteomics were incorporated).
%
% Usage:  [rxnsTable,enzTable_abs,enzTable_rel] = get_fluxDist_table(ecModelP)
%
% Last modified. Ivan Domenzain 2020-02-14
%

enzIndx = [];
enzymes = ecModelP.enzymes;
for i=1:numel(enzymes)
    enz  = enzymes(i);
    indx = find(contains(ecModelP.rxnNames,enz{1}),1);
    enzIndx = [enzIndx;indx];
end
rxnIndxs = 1:length(ecModelP.rxns);
rxnIndxs = setdiff(rxnIndxs,enzIndx);
%Get a solution
solution = solveLP(ecModelP,1);
if ~isempty(solution.x)
    solVec = solution.x;
    %Get rxns table
    varNames  = {'rxns','rxnNames','formulas','flux','grRules','subSystems'};
    rxnsTable = getSubsetTable(rxnIndxs,ecModelP,solVec,varNames,false);
    %Get absolute enzyme usages table
    varNames     = {'enzymes','abs_usage','genes','shortNames','subSystems'};
    enzTable_abs = getSubsetTable(enzIndx,ecModelP,solVec,varNames,true);
    %Get relative enzyme usages table
    varNames = {'enzymes','rel_usage','genes','shortNames','subSystems'};
    relUsage = solVec./ecModelP.ub;
    relUsage(ecModelP.ub>=1000) =  NaN;
    enzTable_rel = getSubsetTable(enzIndx,ecModelP,relUsage,varNames,true);
end
end

function results = getSubsetTable(indxs,model,solution,varNames,enz)
%get model grRules
if ~enz
    formulas = constructEquations(model,indxs);
    subSystems = {};
    for i=1:length(indxs)
        indx   = indxs(i);
        if isempty(model.subSystems{indx})
            str = ' ';
        else
            str = strjoin(model.subSystems{indx},' // ');
        end
        subSystems = [subSystems; {str}];
    end
    results = table(model.rxns(indxs),model.rxnNames(indxs),formulas,solution(indxs),model.grRules(indxs),subSystems,'VariableNames',varNames);
else
    prots = model.rxnNames(indxs);
    prots = strrep(prots,'prot_','');
    prots = strrep(prots,'draw_','');
    prots = strrep(prots,'_exchange','');
    subSystems = mapEnzymeSubSystems(prots,model);
    %Map gene short names
    geneShortNames = [];
    for i=1:length(indxs)
        gene  = model.grRules{indxs(i)};
        index = find(strcmpi(model.genes,gene),1);
        geneShortNames = [geneShortNames;model.geneShortNames(index)];
    end
    results = table(prots,solution(indxs),model.grRules(indxs),geneShortNames,subSystems,'VariableNames',varNames);
end
end