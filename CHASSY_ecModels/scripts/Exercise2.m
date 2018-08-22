%%************* CHASSY modelling tutorial: Excercise #2 *******************
%Save current folder path
current = pwd;
% Load model
load('../models/GEMs/octAcidModel.mat')
% 1) Set the objective function to growth pseudo-reaction
    tempModel = setParam(octModel,'obj','r_4041',1);
    % As an alternative way
    tempModel.c(:) = 0;
    growthIndex    = strcmpi(octModel.rxnNames,'growth');
    tempModel.c(growthIndex) = 1;
    % Take a look into the model's biomass composition
    printModel(octModel,'r_4041')
    fprintf('\n')
    % Set glucose uptake rate
    tempModel = setParam(octModel,'lb','r_1714',-1);
    % As an alternative way
    glucIndex = strcmpi(octModel.rxnNames,'D-glucose exchange');
    tempModel.lb(glucIndex) = -1;
    % run FBA
    sol = solveLP(tempModel);

% 2a) Display exchange fluxes
    printFluxes(octModel,sol.x);
    fprintf('\n')
    
    % 2b) Display internal fluxes
    %%%%%% For this you should take a look into the printFluxes function and 
    %%%%%% call it accordingly 

    %As you have seen there are many reactions that have -1000 or 1000 flux.
    %This is because there are loops in the solution. In order to clean up the
    %solution we can minimize the sum of all the fluxes. This is done by
    %setting the second argument to solveLP to 1 (take a look at solveLP, there
    %are other options as well)
    sol = solveLP(tempModel,1);
    printFluxes(octModel,sol.x,false, 10^-7);
    fprintf('\n')
    %Internal loops have been removed now. Take a look to the exchange fluxes
    printFluxes(octModel,sol.x,true, 10^-7);
    fprintf('\n')

% 3) Plot growth rate vs GUR
    gRates  = [];
    GURates = [];    
    for i=1:20
        %Set new lb for glucose uptake at every iteration
        GUR = i;
        tempModel = setParam(octModel,'lb','r_1714',-GUR);
        sol = solveLP(tempModel);
        %If the simulation was feasible then save the results
        if ~isempty(sol.f)
            gRates  = [gRates; sol.x(growthIndex)];
            GURates = [GURates;-sol.x(glucIndex)];
        end
    end
    %Plot results
    cd complementary
    plot2D(GURates,gRates,'','GUR [mmol/gDw h]','Growth rate [mmol/gDCW h]')
    
% 4) Compare flux distributions for growth on glucose and glycerol
    % First get the flux distribution on glucose
    glyIN     = octModel.rxns{strcmpi(octModel.rxnNames,'glycerol exchange')};
    tempModel = setParam(octModel,'lb',{'r_1714' glyIN},[-1 0]);
    solGluc   = solveLP(tempModel,1);
    % Get the flux distribution on glycerol
    tempModel = setParam(octModel,'lb',{'r_1714' glyIN},[0 -1]);
    solGly    = solveLP(tempModel,1);
    %Print results
    disp('******************* Growth on Glucose *************************')
    printFluxes(tempModel, solGluc.x, true, 10^-7);
    fprintf('\n')
    disp('******************* Growth on Glycerol ************************')
    printFluxes(tempModel, solGly.x, true, 10^-7);
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

% 5) Get a yield vs gRate plot for octanoic acid   
    BioYield    = [];
    Octyield    = [];
    ocAcidIndex = find(strcmpi(octModel.rxnNames,'octanoic acid exchange'));
    iterations  = 20;
    miuMax      = 0.41;
    for i=1:iterations+1
        % Set the objective function to the added octanoic acid exchange rxn
        tempModel = setParam(octModel,'obj','octanoic acid exchange',1);
        % Set a minimal glucose media
         tempModel = setMinimalMedia(tempModel,'r_1714',-4);
        % Fix dilution rate at every iteration
        Drate     = miuMax*(i-1)/iterations;
        tempModel = setParam(tempModel,'eq','r_4041',Drate);
        sol       = solveLP(tempModel,1);
        if ~isempty(sol.f)
            ocAcidEx  = sol.x(ocAcidIndex);
            % Fix maximal production rate for octanoic acid
            tempModel = setParam(tempModel,'eq','octanoic acid exchange',ocAcidEx);
            % Fix objective for glucose uptake rate minimization
            tempModel = setParam(tempModel,'obj','r_1714',1);
            sol       = solveLP(tempModel,1);
            GUR       = abs(sol.x(glucIndex));
            % Calculate biomass yield (g biomass/g glucose)
            value     = Drate/(GUR*0.18);
            BioYield  = [BioYield; value];
            % Calculate octanoic acid yield [mmol octanoic acid/mmol glucose]
            value     = ocAcidEx*0.144/(GUR*0.180);
            Octyield  = [Octyield; value];
        end
    end
    plot2D(BioYield,Octyield,'','Biomass yield [g biomass/g gluc]','Octanoic acid yield [g/g glucose]')
    cd (current)    
        
        
        
     