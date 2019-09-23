%YeastDoc modelling tutorial: Excercise #2 
% Exercise2
%
%  - FBA simulations and visualization of results. 
%  - Batch and chemostat simulations
%  
%  based on the latest
%  version of yeastGEM (GitHub: https://github.com/SysBioChalmers/yeast-GEM)
%
% Ivan Domenzain.	Last modified 2019-09-23

%% 1. Biomass maximization and exploration of solution structure
%%Save current folder path
current = pwd;
% Load model
load('../models/model_3HP.mat')
% 1) Set the objective function to growth pseudo-reaction
growthRxn = model_3HP.rxns{strcmpi(model_3HP.rxnNames,'growth')};
tempModel = setParam(model_3HP,'obj',growthRxn,1);
% As an alternative way
tempModel.c(:) = 0;
growthIndex    = strcmpi(model_3HP.rxnNames,'growth');
tempModel.c(growthIndex) = 1;
% Take a look into the model's biomass composition
printModel(model_3HP,growthRxn)
fprintf('\n')
% Set glucose uptake rate
glucIN    = model_3HP.rxns{strcmpi(model_3HP.rxnNames,'D-glucose exchange')};
tempModel = setParam(model_3HP,'lb',glucIN,-1);
% As an alternative way
glucIndex = strcmpi(model_3HP.rxnNames,'D-glucose exchange');
tempModel.lb(glucIndex) = -1;
% run FBA
solution = solveLP(tempModel)
% Explore solution structure
colNames        = {'reactions' 'fluxes' 'grRules'};
solution_Fluxes = table(model_3HP.rxnNames,solution.x,model_3HP.grRules,'VariableNames',colNames);

% 2a) Display exchange fluxes
printFluxes(tempModel,solution.x);
fprintf('\n')

% 2b) Display internal fluxes
%%%%%% For this you should take a look into the printFluxes function and
%%%%%% call it accordingly
cutOffFlux = 1E-2;
printFluxes(model_3HP,solution.x,false,cutOffFlux);

%% comparing FBA and pFBA solutions

%3. Run the same simulation using pFBA and repeat steps 2a and 2b, then show 
%the solution vectors as cumulative distribution plots. 
solution_pFBA = solveLP(tempModel,1);
% Explore solution structure
colNames             = {'reactions' 'fluxes' 'grRules'};
solution_pFBA_Fluxes = table(model_3HP.rxnNames,solution_pFBA.x,model_3HP.grRules,'VariableNames',colNames);
% 3a) Display exchange fluxes
printFluxes(model_3HP,solution_pFBA.x);
fprintf('\n')
% 3b) Display internal fluxes
%For this you should take a look into the printFluxes function and
%call it accordingly
cutOffFlux = 1E-2;
printFluxes(model_3HP,solution_pFBA.x,false,cutOffFlux);
%As you have seen there are many reactions that have -1000 or 1000 flux.
%This is because there are loops in the solution. In order to clean up the
%solution we can minimize the sum of all the fluxes. This is done by
%setting the second argument to solveLP to 1 (take a look at solveLP, there
%are other options as well)

%% Visualizing solution vectors as cumulative distributions

%This will show a cumulative distribution of the absolute values of the
%fluxes in the simulation
cd complementary
FluxDist = solution.x(abs(solution.x)>1E-7);
plot2D(abs(FluxDist),[],'FBA simulation','Fluxes value [mmol/gDCW h]','Cumulative distribution',true)
%Look at the new flux cumulative distribution
FluxDist = solution_pFBA.x(abs(solution_pFBA.x)>1E-7);
plot2D(abs(FluxDist),[],'pFBA simulation','Fluxes value [mmol/gDCW h]','Cumulative distribution',true)

%% Growth rate vs Glucose uptake rate

% 5) Plot growth rate vs GUR
gRates  = [];
GURates = [];
for i=1:20+1
    %Set new lb for glucose uptake at every iteration
    GUR = i-1;
    tempModel = setParam(model_3HP,'lb',glucIN,-GUR);
    solution = solveLP(tempModel);
    %If the simulation was feasible then save the results
    if ~isempty(solution.f)
        gRates  = [gRates; solution.x(growthIndex)];
        GURates = [GURates;-solution.x(glucIndex)];
    end
end
%Plot results
plot2D(GURates,gRates,'','GUR [mmol/gDw h]','Growth rate [g/gDCW h]',false)
    
%% Comparing metabolism for growth on two different carbon sources

% 6) Compare flux distributions for growth on glucose and glycerol

% First get the flux distribution on glucose
glyIN         = model_3HP.rxns{strcmpi(model_3HP.rxnNames,'glycerol exchange')};
tempModel     = setParam(model_3HP,'lb',{glucIN glyIN},[-1 0]);
glucIndex     = find(strcmpi(model_3HP.rxns,glucIN));
glycIndex     = find(strcmpi(model_3HP.rxns,glyIN));
grwtIndex     = find(strcmpi(model_3HP.rxns,growthRxn));
solGluc       = solveLP(tempModel,1);
bioYieldGluc  = solGluc.x(grwtIndex)/(solGluc.x(glucIndex)*0.18);
% Get the flux distribution on glycerol
tempModel     = setParam(model_3HP,'lb',{glucIN glyIN},[0 -1]);
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
followChanged(tempModel,solGluc.x,solGly.x, 50, 0.5, 0.5);
fprintf('\n')
%Say that we are particularly interested in how ATP metabolism
%changes. Then we can show its related reactions by writing,
followChanged(tempModel,solGluc.x,solGly.x, 30, 0.4, 0.4,{'ATP'});
fprintf('\n')


%% Exploring production yield for 3HP

% 7) Get a yield vs gRate plot for 3-Hydroxypropionic acid
BioYield    = [];
yield       = [];
Index3HP    = find(strcmpi(model_3HP.rxnNames,'3HP exchange'));
iterations  = 10;
Dmax        = 0.2;
%Get a maximum GUR
tempModel = setParam(model_3HP,'lb',model_3HP.rxns(growthIndex),0.9999*Drate);
tempModel = minimal_Y6(tempModel,glucIN,-1000);
tempModel = setParam(tempModel,'obj',glucIN,1);
sol       = solveLP(tempModel,1);
GURopt    = sol.x(glucIndex);

for i=1:iterations+1
    % Set the objective function to the added 3HP exchange rxn
    tempModel = setParam(model_3HP,'obj',model_3HP.rxns{Index3HP},1);
    % Set a minimal glucose media (
    tempModel = minimal_Y6(tempModel,glucIN,GURopt);
    % Fix dilution rate at every iteration
    Drate     = Dmax*(i-1)/iterations;
    tempModel = setParam(tempModel,'lb',model_3HP.rxns(growthIndex),0.9999*Drate);
    solution  = solveLP(tempModel);
    if ~isempty(solution.f)
        Exc_3HP  = solution.x(Index3HP);
        % Fix maximal production rate for 3HP
        tempModel = setParam(tempModel,'eq','3HP exchange',Exc_3HP);
        % Fix objective for glucose uptake rate minimization
        tempModel = setParam(tempModel,'obj',glucIN,1);
        solution  = solveLP(tempModel,1);
        GUR       = abs(solution.x(glucIndex));
        % Calculate biomass yield (g biomass/g glucose)
        value     = Drate/(GUR*0.18);
        BioYield  = [BioYield; value];
        % Calculate 3HP yield [mmol 3HP/mmol glucose]
        value     = Exc_3HP*0.0908/(GUR*0.180);
        yield     = [yield; value];
    end
end
plot2D(BioYield,yield,'','Biomass yield [g biomass/g gluc]','3HP yield [g/g glucose]',false)
cd (current)

        
        
        
     