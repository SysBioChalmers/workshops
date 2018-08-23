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

