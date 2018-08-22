# Excercise 2: FBA simulations and visualization
Now that we have explored the whole model structure it is time to start to use the model for flux balance analysis simulations. 

1. Set the objective function to growth pseudo-reaction, a glucose uptake rate of 1 mol/gDCW/h and run FBA

   * a) Why do we set the Lower boundary to -1 rather than the upper bound to 1?

1. Have a look to the obtained flux distribution

   * a) Display exchange fluxes

   * b) Display internal fluxes

   * c) What this a batch or a chemostat cultivation simulation?

   * d) Was there any limiting compound in the simulation medium?

1. Plot the growth rate vs glucose uptake rate on the range 0 - 20 mmol/gDCW/h. Any comments about the results?

As you just saw, imposing proper constraints is crucial when running FBA. A mathematically feasible simulation doesn't necesarilly imply biological relevance!

Properly constrained GEMs allow to take a look to the metabolic network in action subject to specific environmental  conditions. Microbial growth on different carbon sources can be easily explored with the use of a GEM. Now you are going to explore the metabolic differences for yeast growing on limited carbon conditions using two different substrates. 

4. Run FBA simulations for carbon limited conditions using:

    * a) Glucose as a carbon source with an upper bound of 1 mmol/gDCW h  for its **uptake** reaction

    * b) Glycerol with an upper bound of 1 mmol/gDCW h for its **uptake** reaction 

    * c) Display the reactions which relative flux difference is, at least, 50% with respect to the glucose conditions and with an absolute difference higher than 0.5 mmol/gDCW h.

    * d) Get the reactios with significantly changing fluxes in which ATP is involved.

    * e) Take a look to this results and discuss with a partner what do you observe from a metabolic point of view, you can use the EXCEL file for interpreting the results.

By now, we have a modified model for the production of octanoic acid, its production performance for a wide range of conditions can be analysed through FBA.

5. Get a octanoic acid yield vs biomass theoretical yield plot (in terms of mass).
    * a) According to this result would it be attractive to explore octanoic acid production with *S. cerevisiae* as a cell factory?

 

