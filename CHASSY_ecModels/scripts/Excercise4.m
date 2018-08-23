%%************* CHASSY modelling tutorial: Excercise #4 *******************
%Save current folder path
current = pwd;
%% 1) Load models
load('../models/ecGEMs/ecYeastGEM_batch.mat');
load('../models/GEMs/yeast_7_6.mat');
ecModel = ecModel_batch;

%% 2a-c) 
cd complementary
[isoEnzymes,Promiscuous,Complexes,RxnWithKcat] =  rxnCounter(ecModel,model);

% 2 d) Which is the most promiscuous enzyme?
enzIndexes = find(contains(ecModel.metNames,'prot_'));
% Exclude the protein pool pseudometabolite
enzIndexes = enzIndexes(1:end-1);
% Extract the enzyme rows from the S matrix (excluding the protein pool
% pseudoreaction column)
protMatrix = ecModel.S(enzIndexes,1:end-1);
protMatrix = logical(protMatrix);
for i=1:length(enzIndexes)
    Promiscuous(i) = sum(protMatrix(i,:));
end
[maxValue, index] = max(Promiscuous);
disp([ecModel.enzymes{index} ': present in ' num2str(Promiscuous(index)) ' reactions']);
% 2 e) Display the reaction in which this enzyme is present
ecModel.rxnNames(protMatrix(index,:))

%% 3) Plot growth rate vs GUR
gRates      = [];
GURates     = [];
ecModel     = setParam(ecModel,'obj','r_4041',1);
growthIndex = strcmpi(ecModel.rxnNames,'growth');
glucIndex   = strcmpi(ecModel.rxnNames,'D-glucose exchange (reversible)');
iterations  = 20;
for i=1:iterations+1
    %Set new lb for glucose uptake at every iteration
    GUR       = (20)*(i-1)/iterations;
    tempModel = setParam(ecModel,'ub','r_1714_REV',GUR);
    sol       = solveLP(tempModel);
    %If the simulation was feasible then save the results
    if ~isempty(sol.f)
        gRates  = [gRates; sol.x(growthIndex)];
        GURates = [GURates;sol.x(glucIndex)];
    end
end
%Plot results
plot2D(GURates,gRates,'','GUR [mmol/gDw h]','Growth rate [g/gDCW h]',false)
clear all

%% 4) Run chemostat simulations and compare exchange fluxes predictions 
%     between the ecModel and the original one

load('../../models/ecGEMs/ecYeastGEM_batch.mat');
load('../../models/GEMs/yeast_7_6.mat');
ecModel = ecModel_batch;
Drates  = [0.025 0.05 0.1 0.15 0.2];
GlucUpt = [0.3 0.6 1.1 1.7 2.30];
O2Prod  = [0.8 1.3 2.5 3.9 5.30];
CO2Prod = [0.8 1.4 2.7 4.2 5.7];

exchIndexes(1) = find(strcmpi(model.rxnNames,'D-glucose exchange'));
exchIndexes(3) = find(strcmpi(model.rxnNames,'carbon dioxide exchange'));
exchIndexes(2) = find(strcmpi(model.rxnNames,'oxygen exchange'));

ECexchIndexes(1) = find(strcmpi(ecModel.rxnNames,'D-glucose exchange (reversible)'));
ECexchIndexes(3) = find(strcmpi(ecModel.rxnNames,'carbon dioxide exchange'));
ECexchIndexes(2) = find(strcmpi(ecModel.rxnNames,'oxygen exchange (reversible)'));

for i=1:length(Drates)
    D    = Drates(i);
    data = [GlucUpt(i) O2Prod(i) CO2Prod(i)];
    [sol,meanError(i)]   = simulateChemostat(model,exchIndexes,D,false,data);
    [sol,meanErrorEC(i)] = simulateChemostat(ecModel,ECexchIndexes,D,false,data);

end
% Plot results in a stacked bar graph
Drates = ({'D=0.025','D=0.05','D=0.1','D=0.15','D=0.2'});
bar([meanErrorEC;meanError]','stacked')
set(gca,'xticklabel',Drates)
title('Exchange fluxes prediction','FontSize',18)
ylabel('Mean relative error','FontSize',18)
legend({'ecYeast','YeastGEM'},'FontSize',16)
clear all

%% 5) Simulate batch growth on different carbon source (file: growthRates_data_carbonSources.txt)
load('../../models/ecGEMs/ecYeastGEM_batch.mat');
load('../../models/GEMs/yeast_7_6.mat');
% 5a) Get a plot that compares the simulated maximum growth rates with the 
%     experimental data
[flux_dist, conditions] = Csources_simulations(ecModel_batch);
% "flux_dist" is a matrix with the resulting flux distribution for each
%condition in its columns, each row represent a rxn in the model and the
%order is consistent with the rxn-related fields in the ecModel. The cell
%"conditions" contains the name of the simulated media and its respective
%carbon sources.

% 5b) From the previous simulations choose two different flux distributions 
%     and analyze their differences in terms of metabolism.






%%



function [sol,error] = simulateChemostat(model,exchIndexes,Drate,EC,data)
    %Fix growthRate = Dilution rate
    tempModel = setParam(model,'eq','r_4041',Drate);
    % Set bounds and objective depending on the type of model
    if EC
        glucIndex = strcmpi(model.rxnNames,'D-glucose exchange (reversible)');
        tempModel = setParam(tempModel,'ub',tempModel.rxns(glucIndex),10);
        tempModel = setParam(tempModel,'obj',tempModel.rxns(glucIndex),-1);
    else
        glucIndex = strcmpi(model.rxnNames,'D-glucose exchange');
        tempModel = setParam(tempModel,'lb',tempModel.rxns(glucIndex),-10);
        tempModel = setParam(tempModel,'obj',tempModel.rxns(glucIndex),1); 
    end
    
    sol = solveLP(tempModel,1);
    if ~isempty(sol.f)
        sol = sol.x(exchIndexes);
        % For the ecModel a second optimization is performed, fixing the
        % predicted GUR and then minimizing for the total protein usage.
        if EC
            glucUptake = sol.x(glucIndex);
            tempModel  = setParam(tempModel,'eq',tempModel.rxns(glucIndex),glucUptake);
            tempModel  = setParam(tempModel,'obj',model.rxns(prot_pool_exchange),-1);
            sol        = solveLP(tempModel,1);
            sol        = sol.x(exchIndexes);
        end
    else
        sol = zeros(length(exchIndexes));
    end 
    sol = abs(sol);
    % Calculate mean relative error for the given D rate
    for i=1:length(data)
        error(i) = abs(sol(i)-data(i))/data(i);
    end 
    error = mean(error);
end







