# Excercise 1: Exploring a GEM EXCEL file
A GEM can be considered as an extensive knowledge database for the whole metabolism of an organism, not only as a catalogue of its constituent parts but also containing information that connects each of its different elements:
* Genes
* Reactions
* Metabolites
* Cellular compartments
* Additional information (annotation, external id's, proteins structure, etc.)

GEMs can come in a wide variety of formats, a widely accepted and used by the community is SBML (Systems Biology Markup Language), often using the `.xml` file extension.
SBML files are not meant to be human readable, for this purpose many people find it helpful to inspect models in a much more user friendly format, `EXCEL`. 

As a first approach to GEMs we are going to inspect the structure and element in the consensus model for _S. cerevisiae_ metabolism (`yeastGEM`). 

1. Open the excel file `models/yeastGEM.xlsx`. 

2. Now you can take a look into the various tabs, each containing different types of information in the model.
   * a) How many reactions, metabolites, compartments and genes are there in the model?
   * b) With the available information, is there a way to know how many reactions are reversible?
   * c) In how many reactions is the gene `YEL039C` (CYC/) present?
   * d) Can you explain the difference between `r_0193` and `r_0194` genes association?
   * e) Take a look into `r_0438` equation, can you say what is happening in terms of metabolites compartmentalization?
   
3. Now you are ready for inspecting the model `.mat` file (MATLAB structure). Take your time for looking at its multiple fields: model.mets, model.rxns, model.S, model.grRules, etc. You can find all the fields that are supported by the `RAVEN` toolbox by entering `help importModel` in your MATLAB command line. 
    
    For illustrating some of the advantages of dealing with a GEM in a MATLAB structure instead of an EXCEL model, repeat the tasks 2a-e (go to the excercise script).

4. If a reaction is properly removed or added to the model, which fields should be affected in the MATLAB structure?

## Keeping track of model changes with GitHub
One of the main pitfalls of introducing changes to GEMs on the EXCEL format is that this procedure doesn't leave a trace in which all the modifications can be seen and one can easily end up with multiple model files, which could be inconvenient for colaborative or long-term projects.

For this purpose, the use of GitHub and the SBML format are suggested as a standard practice in the nowadays GEMs community. The creation and modification of this kind of files can be done through MATLAB commands, which makes it even more attractive because extensive tasks can be automated.

5. Lets introduce a modification in our original model. 3-Hydroxypropionic acid can be produced from cytosolic malonyl-CoA through the expression of a heterologous bi-functional Malonyl-Coenzyme A Reductase from *Chloroflexus aurantiacus* [Borodina et al., 2015](https://doi.org/10.1016/j.ymben.2014.10.003). A transport reaction from the cytosol to extracellular compartment and an exchange reaction should be added for the cell to be able to secrete the product.

6. Export the model to SBML format and commit the changes in GitHub desktop

