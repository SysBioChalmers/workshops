# Excercise 1: Exploring a GEM EXCEL file
A GEM can be considered as an extensive knowledge database for the whole metabolism of an organism, not only as a catalogue of its constituent parts but also containing information that connects each of its different elements:
* Genes
* Reactions
* Metabolites
* Cellular compartments
* Additional information (annotation, external id's, proteins structure, etc.)

GEMs can come in a wide variety of formats, a widely accepted and used by the community is SBML (Systems Biology Markup Language), often using the `.xml` file extension.
SBML files are not meant to be human readable, for this purpose many people find it helpful to inspect models in a much more user friendly format, `EXCEL`. 

As a first approach to GEMs we are going to inspect the structure and element in the consensus model for _S. cerevisiae_ metabolism (`yeast 7.6`). 

1. Execute 1.1 and 1.2 instructions in the provided script for this excercise, if one of these fails it might be related with libSBML not working properly for you, if this was your case you can also directly open the excel file `yeast_7_6.xlsx`. 

1. Now you can take a look into the various tabs, each containing different types of information in the model.
   * a) How many reactions, metabolites, compartments and genes are there in the model?
   * b) With the available information, is there a way to know how many reactions are reversible?
   * c) In how many reactions is the gene `YEL039C` (CYC/) present?
   * d) Can you explain the difference between `r_0195` and `r_0198` genes association?
   * e) Take a look into `r_0438` equation, can you say what is happening in terms of metabolites compartmentalization?
   
1. Now you are ready for inspecting the model `.mat` file (MATLAB structure). Take your time for looking at its multiple fields: model.mets, model.rxns, model.S, model.grRules, etc. You can find all the fields that are supported by the `RAVEN` toolbox by entering `help importModel` in your MATLAB command line. 
    
    For illustrating some of the advantages of dealing with a GEM in a MATLAB structure instead of an EXCEL model, repeat the tasks 2a-e (go to the excercise script).
1. If a reaction is properly removed from the model, which fields sj be affected in the MATLAB structure?  



