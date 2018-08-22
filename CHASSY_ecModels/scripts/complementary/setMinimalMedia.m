function model = setMinimalMedia(model,Csource,bound)

% Block uptake for all exchange metabolites and allow excretion
exchangeRxns = getExchangeRxns(model);
model = setParam(model, 'lb', exchangeRxns, 0);
model = setParam(model, 'ub', exchangeRxns, 1000);
model = setParam(model, 'lb', 'r_1654', -1000); % 'ammonium exchange';
model = setParam(model, 'lb', 'r_2100', -1000); % 'water exchange' ;
model = setParam(model, 'lb', 'r_1861', -1000); % 'iron(2+) exchange';
model = setParam(model, 'lb', 'r_1992', -1000); % 'oxygen exchange';
model = setParam(model, 'lb', 'r_2005', -1000); % 'phosphate exchange';
model = setParam(model, 'lb', 'r_2060', -1000); % 'sulphate exchange';
model = setParam(model, 'lb', 'r_1832', -1000); % 'H+ exchange' ;
model = setParam(model, 'lb', Csource, bound); % 'D-glucose exchange' ;
 
end