# CHASSY project
## Metabolic modelling workshop
This repository was used as an online resource for the CHASSY **Modelling Workshop** on August 2018. The workshop consists on the following sessions:

1. **Genome-scale mEtabolic Models and FBA:** 
    - Metabolic networks reconstruction 
    - Linear Programming
    - Flux Balance Analysis (FBA)
    - Alternate optima and Flux Variability Analysis (FVA)
2. **Playing with GEMs:**
    - Model structure exploration with `MATLAB` and the [RAVEN toolbox](https://github.com/SysBioChalmers/RAVEN/wiki) 
    - Imposition of experimental constraints into GEMs
    - FBA, production rates and yields calculations
    - *In-silico* metabolic engineering and genetic modifications
    - Phenotypes comparison across strains and conditions
3. **Enzyme-constrained models:**
    - Incorporation of Omics data into GEMs
    - Enzyme-Constrained models exploration
    - Comparing flux distributions GEMs vs ecModels

### Required Software
The computational part of this workshop (session 2) consists of a live demo about models manipulation and simulation for which all the necessary scripts, models and datasets should be provided in this repo. However, if you would lie to run all the material uploaded to this repository you would need the following software:
- A functional `MATLAB` installation (version 2013b or later).
- The [RAVEN toolbox](https://github.com/SysBioChalmers/RAVEN). Please read its documentation for installation and required dependencies.

Dependencies:

- [libSBML MATLAB API](https://sourceforge.net/projects/sbml/files/libsbml/5.16.0/stable/MATLAB%20interface/) (version 5.16 is recommended), which is utilised for importing and exporting GEMs in SBML format. 
- At least one solver for linear programming:
  * Preferred: [Gurobi Optimizer](http://www.gurobi.com/downloads/gurobi-optimizer) (version 7.5 or higher), academic license is available [here](https://www.gurobi.com/downloads/end-user-license-agreement-academic/).
  * Alternative/legacy: [MOSEK](https://www.mosek.com/downloads/list/7/) (version 7 only), academic license is available [here](https://www.mosek.com/products/academic-licenses/).
  * If the user has [COBRA Toolbox](https://github.com/opencobra/cobratoolbox) installed, it is possible to use the default COBRA solver (the one which is set by _changeCobraSolver_).

Last but not least, things are going to be easier and faster if you get your own [GitHub free account](https://github.com/join?source=header-home) and download an online version of [GitHub desktop](https://desktop.github.com/).

### Continuous assessment and tech-support
As a result of this workshop a modelling community has been created for the utilization of ecModels in the CHASSY project context. Continuous assessment about the workshop learning outcomes and technical support for the attendees/users is being provided and it is publicly available on: [![Gitter](https://badges.gitter.im/CHASSY_modeling/community.svg)](https://gitter.im/CHASSY_modeling/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

### Contributors
- Iván Domenzain [(@IVANDOMENZAIN)](https://github.com/IVANDOMENZAIN), Chalmers University of Technology, Gothenburg Sweden
