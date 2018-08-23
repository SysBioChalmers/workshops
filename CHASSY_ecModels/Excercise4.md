# Excercise 4: Phenotype predictions with a GECKO model
It is time to use an enzyme constrained model and identify its advantages with respect to classical GEMs. As it has been explained, ecModels contain new elements (mets, rxns, proteins) as part of the metabolic network, the introduction of proteins makes it necessary to add new fields to the model.

1. Import an ecModel and take a time for exploring its matlab structure.
    
    * a) Which are the new fields in the model and what additional information do they contain?

    * b) Which fields have changed their size? Can you explain possible reasons for these changes?

    * c) Take a look to the `rxns` and `rxnNames` fields, are the changes in the nomenclature clear for you? 


1. According to the information given in the lecture, how would you identify the following:
    
    * a) If an enzyme is a promiscuous one?

    
    * b) The number of isoenzymes linked to a reaction
    
    * c) The number of enzymatic subunits that are linked to a given reaction
    
    * hint: If this is consuming a lot of time you can run and try to read the algorithm of `rxnCounter.m` function available in the `scripts/complementary` folder

    * d) Which is the "most promiscuous" enzyme in the model?
    
    * e) Display the number of all the reactions in which this enzyme is present, any comments?

1. Reproduce the growth rate vs GUR plot in excercise2 but now with the ecModel instead of the original one. Any changes? If so, can you give a brief explanation of this?

1. Run chemostat simulations at 0.025, 0.05, 0.1, 0.15, 0.2 h^-1 for both the model and ecModel and get the mean relative errors for the prediction of glucose, oxygen and CO2 exchange fluxes according to the data provided in the script. Take a look to the `simulateChemostat` in the same script for you to know how this is done.

1. Run batch simulations with the ecModel for the different batch experiments included in the file Data_files/growthRates_data_carbonSources.txt, 
    
    * a) Get a plot that compares the simulated maximum growth rates with the experimental data.
    * b) From the previous simulations choose two different flux distributions and analyze their differences in terms of metabolism, what is significantly changing between them? Write your conclusions in a few lines and share them with the group.
    * Hint: Remember the flux distributions comparison that was done on excercise2, try to use the same `RAVEN`function, but also feel free to analyse the results matrix as you want.
    

 



