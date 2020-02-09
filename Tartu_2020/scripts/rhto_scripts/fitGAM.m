%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GAM = fitGAM(model)
% Returns a fitted GAM for the yeast model.
% 
% Benjamin Sanchez. Last update: 2018-10-27
% Ivan Domenzain.   Last update: 2019-07-29
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function GAM = fitGAM(model)
%Change GAM:
cd ..
parameters = getModelParameters;
cd limit_proteins
xr_pos = strcmp(model.rxns,parameters.bioRxn);
%Get biomass precursors
prec = find(model.S(:,xr_pos));
prec = prec(find(strcmpi(model.metNames(prec),'ATP')));
GAM  = abs(model.S(prec,xr_pos));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
