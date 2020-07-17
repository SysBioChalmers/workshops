% Explore C intermedia model
%  - FBA simulations and visualization of results. 
%  - Flux distributions comparisons across experimental conditions
%  - Production yields calculations
%  
%  Based on the latest version of yeastGEM (GitHub: https://github.com/SysBioChalmers/yeast-GEM)
%
% Ivan Domenzain.	Last modified 2020-07-17

% 1. Biomass maximization and exploration of solution structure
%%Save current folder path
current = pwd;
% Load model
model = importModel('../models/Candida_intermedia.xml');
% 1) Set the objective function to growth pseudo-reaction
growthRxn = model.rxns{strcmpi(model.rxnNames,'growth')};
tempModel = setParam(model,'obj',growthRxn,1);
% As an alternative way
tempModel.c(:) = 0;
growthIndex    = strcmpi(model.rxnNames,'growth');
tempModel.c(growthIndex) = 1;
% Take a look into the model's biomass composition
printModel(model,growthRxn)
fprintf('\n')
% Set glucose uptake rate
glucIN    = model.rxns{strcmpi(model.rxnNames,'D-glucose exchange')};
tempModel = setParam(model,'lb',glucIN,-1);
% As an alternative way
glucIndex = strcmpi(model.rxnNames,'D-glucose exchange');
tempModel.lb(glucIndex) = -1;
% run FBA
solution = solveLP(tempModel);
% Explore solution structure
colNames        = {'reactions' 'fluxes' 'grRules'};
solution_Fluxes = table(model.rxnNames,solution.x,model.grRules,'VariableNames',colNames);

% 2a) Display exchange fluxes
printFluxes(tempModel,solution.x);
fprintf('\n')

% 2b) Display internal fluxes
%%%%% For this you should take a look into the printFluxes function and
%%%%% call it accordingly
cutOffFlux = 1E-2;
printFluxes(model,solution.x,false,cutOffFlux);

% comparing FBA and pFBA solutions

%3. Run the same simulation using pFBA and repeat steps 2a and 2b, then show 
%the solution vectors as cumulative distribution plots. 
solution_pFBA = solveLP(tempModel,1);
% Explore solution structure
colNames             = {'reactions' 'fluxes' 'grRules'};
solution_pFBA_Fluxes = table(tempModel.rxnNames,solution_pFBA.x,tempModel.grRules,'VariableNames',colNames);
% 3a) Display exchange fluxes
printFluxes(tempModel,solution_pFBA.x);
fprintf('\n')
% 3b) Display internal fluxes
%For this you should take a look into the printFluxes function and
%call it accordingly
cutOffFlux = 1E-2;
printFluxes(tempModel,solution_pFBA.x,false,cutOffFlux);
%As you have seen there are many reactions that have -1000 or 1000 flux.
%This is because there are loops in the solution. In order to clean up the
%solution we can minimize the sum of all the fluxes. This is done by
%setting the second argument to solveLP to 1 (take a look at solveLP, there
%are other options as well)

% Visualizing solution vectors as cumulative distributions

%This will show a cumulative distribution of the absolute values of the
%fluxes in the simulation
cd complementary
FluxDist = solution.x;%(abs(solution.x)>1E-7);
plot2D(abs(FluxDist),[],'FBA simulation','Fluxes value [mmol/gDCW h]','Cumulative distribution',true)
%Look at the new flux cumulative distribution
FluxDist = solution_pFBA.x;%(abs(solution_pFBA.x)>1E-7);
plot2D(abs(FluxDist),[],'pFBA simulation','Fluxes value [mmol/gDCW h]','Cumulative distribution',true)

% Growth rate vs Glucose uptake rate

% 5) Plot growth rate vs GUR
gRates  = [];
GURates = [];
for i=1:20+1
    %Set new lb for glucose uptake at every iteration
    GUR = i-1;
    tempModel = setParam(model,'lb',glucIN,-GUR);
    solution = solveLP(tempModel);
    %If the simulation was feasible then save the results
    if ~isempty(solution.f)
        gRates  = [gRates; solution.x(growthIndex)];
        GURates = [GURates;-solution.x(glucIndex)];
    end
end
%Plot results
plot2D(GURates,gRates,'','GUR [mmol/gDw h]','Growth rate [g/gDCW h]',false)
    
% Comparing metabolism for growth on two different carbon sources

% 6) Compare flux distributions for growth on glucose and glycerol

% First get the flux distribution on glucose
glyIN         = model.rxns{strcmpi(model.rxnNames,'glycerol exchange')};
tempModel     = setParam(model,'lb',{glucIN glyIN},[-1 0]);
glucIndex     = find(strcmpi(model.rxns,glucIN));
glycIndex     = find(strcmpi(model.rxns,glyIN));
grwtIndex     = find(strcmpi(model.rxns,growthRxn));
solGluc       = solveLP(tempModel,1);
bioYieldGluc  = solGluc.x(grwtIndex)/(solGluc.x(glucIndex)*0.18);
% Get the flux distribution on glycerol
tempModel     = setParam(model,'lb',{glucIN glyIN},[0 -1]);
solGly        = solveLP(tempModel,1);
bioYieldGlyc  = solGly.x(grwtIndex)/(solGly.x(glycIndex)*0.09209);
%Print results
disp('******************* Growth on Glucose *************************')
printFluxes(tempModel, solGluc.x, true, 10^-6);
fprintf('\n')
disp(['The biomass yield is: ' num2str(bioYieldGluc) ' [g biomass/g Glucose]'])
fprintf('\n')
disp('******************* Growth on Glycerol ************************')
printFluxes(tempModel, solGly.x, true, 10^-6);
fprintf('\n')
disp(['The biomass yield is: ' num2str(bioYieldGlyc) ' [g biomass/g Glycerol]'])
fprintf('\n')
%What if you are interested in how metabolism changes between the two
%conditions. followChanged takes two flux distributions and lets you
%select which reactions to print. Here we show reactions that differ with
%more than 50%, have a flux higher than 0.5 mmol/gDW/h and an absolute
%difference higher than 0.5 mmol/gDW/h.
followChanged(tempModel,solGly.x,solGluc.x, 50, 0.5, 0.5);
fprintf('\n')
%Say that we are particularly interested in how ATP metabolism
%changes. Then we can show its related reactions by writing,
followChanged(tempModel,solGly.x,solGluc.x, 30, 0.4, 0.4,{'ATP'});
fprintf('\n')
     