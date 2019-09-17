%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [absValues, pIDs, genes] = convert2Abs(avgd_data,avgd_ids,avgdGenes,Ptot,f)
load('../../Databases/sce_ProtDatabase.mat')
observations = length(avgd_ids);
%Normalize with respect to the total counts in the dataset
avgd_data = avgd_data*f*Ptot/sum(avgd_data);
pIDs= {};
genes= {};
absValues = {};
MWs_swiss = swissprot(:,5);
MWs_kegg = kegg(:,4);

meanValue = mean(cell2mat(MWs_swiss));

for i=1:observations
    identifier = avgd_ids{i};
    gene       = avgdGenes{i};
    if ~isempty(identifier) && ~isempty(gene)
        MW = meanValue;
        index = find(strcmpi(swissprot(:,1),identifier));
        %If the proteind was found in the databases the MW is extracted, if
        %not the average MW for the model enzymes will be used instead (in
        %kDa)
        if ~isempty(index)
            MW  = MWs_swiss{index}/1000;
        else
            index = find(strcmpi(kegg(:,1),identifier),1);
            if ~isempty(index)
                if ~isempty(MWs_kegg{index})
                    MW = MWs_kegg{index}/1000;
                end
            end
        end
        value     = avgd_data(i)/MW;
        pIDs      = [pIDs; identifier];
        absValues = [absValues; value];
        genes     = [genes; gene];
    end
end
end