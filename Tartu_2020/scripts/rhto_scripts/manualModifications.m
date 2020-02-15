function [model,modifications] = manualModifications(model)
%
% Ivan Domenzain.      Last edited: 2020-02-07

modifications{1} = [];
modifications{2} = [];
disp('Improving model with curated data')
[newValue,modifications] = curation_growthLimiting(model,modifications);
% Remove repeated reactions (2017-01-16):
rem_rxn = false(size(model.rxns));
for i = 1:length(model.rxns)-1
    for j = i+1:length(model.rxns)
        if isequal(model.S(:,i),model.S(:,j)) && model.lb(i) == model.lb(j) && ...
                model.ub(i) == model.ub(j)
            rem_rxn(j) = true;
            disp(['Removing repeated rxn: ' model.rxns{i} ' & ' model.rxns{j}])
        end
    end
end
model=removeReactions(model,model.rxns(rem_rxn),true,true,true);
% Merge arm reactions to reactions with only one isozyme (2017-01-17):
arm_pos = zeros(size(model.rxns));
p       = 0;
for i = 1:length(model.rxns)
    rxn_id = model.rxns{i};
    if contains(rxn_id,'arm_')
        rxn_code  = rxn_id(5:end);
        k         = 0;
        for j = 1:length(model.rxns)
            if contains(model.rxns{j},[rxn_code 'No'])
                k   = k + 1;
                pos = j;
            end
        end
        if k == 1
            %Condense both stoichiometries in one:
            armSvector = model.S(:,i);
            newSvector = model.S(:,i) + model.S(:,pos);
            model.S(:,pos) = newSvector;
            %Identify pMet and remove it
            [~,ia] = setdiff(logical(armSvector),logical(newSvector));
            model  = removeMets(model,ia);
            p          = p + 1;
            arm_pos(p) = i;
            disp(['Merging reactions: ' model.rxns{i} ' & ' model.rxns{pos}])
        end
    end
end
% Remove saved arm reactions:
model=removeReactions(model,model.rxns(arm_pos(1:p)),true,true,true);
%Change gene rules:
if isfield(model,'rules')
    for i = 1:length(model.rules)
        if ~isempty(model.rules{i})
            %Change gene ids:
            model.rules{i} = strrep(model.rules{i},'x(','');
            model.rules{i} = strrep(model.rules{i},')','');
            genes          = strsplit(model.rules{i},' & ');
            newStr         = [];
            for gene = genes
                if ~isempty(newStr)
                    newStr = gene{1};
                else
                    newGene = model.genes{str2double(gene)};
                    newStr  = [newStr ' & ' gene{1}];
                end
            end
            model.rules{i}  = newStr;
        end
    end
end
% Remove unused enzymes after manual curation (2017-01-16):
rem_enz = false(size(model.enzymes));
for i = 1:length(model.enzymes)
    pos_met = strcmp(model.mets,['prot_' model.enzymes{i}]);
    if sum(model.S(pos_met,:)~=0) == 1
        rem_enz(i) = true;
    end
end
rem_enz = model.enzymes(rem_enz);
for i = 1:length(rem_enz)
    model = deleteProtein(model,rem_enz{i});
    disp(['Removing unused protein: ' rem_enz{i}])
end
% Map the index of the modified Kcat values to the new model (after rxns
% removals).
modifications = mapModifiedRxns(modifications,model);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modify the top growth limiting enzymes that were detected by the
% modifyKcats.m script in a preliminary run.
function [newModel,modifications] = curation_growthLimiting(model,modifications)
% 3-hydroxy-3-methylglutaryl coenzyme A reductase (M7XI04/EC1.1.1.34):
% Only kcat available in BRENDA was for Rattus Norvegicus. Value
% corrected with max. s.a. in Rattus norvegicus [0.03 umol/min/mg, Mw=226 kDa]
% from BRENDA (2018-01-27)
 rxnIndex = find(contains(model.rxnNames,'hydroxymethylglutaryl CoA reductase (No1)'));
 %find limiting enzyme 
 enzIndex = contains(model.metNames,'prot_M7XI04');
 %In this case the limiting enzyme will be forced to remain the same, as
 %the automatically curated value exceeds this one by several orders of
 %magnitude
 newValue = -(0.023*3600)^-1;
 %Save changes
 modifications{1} = [modifications{1}; "M7XI04"];
 modifications{2} = [modifications{2}; model.rxnNames(rxnIndex)];
 %Modify Kcat in the S matrix
 model.S(enzIndex,rxnIndex) = newValue;

newModel = model;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modify those kcats involved in extreme misspredictions for growth on
% several carbon sources. This values were obtained by specific searches on
% the involved pathways for the identification of the ec numbers and then
% its associated Kcat values were gotten from BRENDA.
function [newValue,modifications] = curation_carbonSources(reaction,enzName,MW_set,modifications)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% After the growth limiting Kcats analysis and the curation for several
% carbon sources, a simulation for the model growing on minimal glucose
% media yielded a list of the top used enzymes (mass-wise), those that were
% taking more than 10% of the total proteome are chosen for manual curation
function [newValue,modifications] = curation_topUsedEnz(reaction,enzName,MW_set,modifications)

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function modified = mapModifiedRxns(modifications,model)
modified = [];
for i=1:length(modifications{1})
    rxnIndex = find(strcmp(model.rxnNames,modifications{2}(i)),1);
    str      = {horzcat(modifications{1}{i},'_',num2str(rxnIndex))};
    modified = [modified; str];
end
end