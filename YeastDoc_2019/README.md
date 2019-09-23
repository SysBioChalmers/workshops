# Doctoral School in Yeast Industrial Biotechnology
## Metabolic modelling workshop
This repository is aimed to be used as an online resource for the **Modelling Workshop** at the doctoral summer school on September 24th, 2019. The workshop consists on the following sessions of 45 minutes each:

1. **Genome-scale mEtabolic Models and FBA:** 
    - Metabolic networks reconstruction 
    - Linear Programming
    - Flux Balance Analysis (FBA)
    - Alternate optima and Flux Variability Analysis (FVA)
2. **Playing with GEMs:** (Live Demo) 
    - Model structure exploration with `MATLAB` and the [RAVEN toolbox](https://github.com/SysBioChalmers/RAVEN/wiki) 
    - Imposition of experimental constraints into GEMs
    - FBA, production rates and yields calculations
    - *In-silico* metabolic engineering and genetic modifications
    - Phenotypes comparison across strains and conditions
3. **Aplications of Metabolic Modelling:**
    - Optimal strains design algorithms
    - Incorporation of Omics data into GEMs
    - Enzyme-Constrained models
    - Other simulation tools

### Reading materials
In order to accomplish a better understanding of the workshop's topics the following papers are recommended as preparatory readings:

- Orth, J. D., Thiele, I., & Palsson, B. O. (2010, March). [What is flux balance analysis?](https://github.com/SysBioChalmers/workshops/blob/feat/YeastDoc_2019/YeastDoc_2019/reading_materials/whatIsFBA.pdf) Nature Biotechnology.
- Price, N. D., Reed, J. L., & Palsson, B. (2004, November). [Genome-scale models of microbial cells: Evaluating the consequences of constraints](https://github.com/SysBioChalmers/workshops/blob/feat/YeastDoc_2019/YeastDoc_2019/reading_materials/palsson_constraints.pdf). Nature Reviews Microbiology.
- Lewis, N. E., Nagarajan, H., & Palsson, B. O. (2012). [Constraining the metabolic genotype-phenotype relationship using a phylogeny of in silico methods](https://github.com/SysBioChalmers/workshops/blob/feat/YeastDoc_2019/YeastDoc_2019/reading_materials/phylogeny_of_inSilico_methods.pdf). Nature Reviews Microbiology. Nature Publishing Group.
- Sánchez, B. J., Zhang, C., Nilsson, A., Lahtvee, P., Kerkhoven, E. J., & Nielsen, J. (2017). [Improving the phenotype predictions of a yeast genome‐scale metabolic model by incorporating enzymatic constraints](https://github.com/SysBioChalmers/workshops/blob/feat/YeastDoc_2019/YeastDoc_2019/reading_materials/GECKO.pdf). Molecular Systems Biology, 13(8), 935.

Optional:

- Wang, H., Marcišauskas, S., Sánchez, B. J., Domenzain, I., Hermansson, D., Agren, R., … Kerkhoven, E. J. (2018). [RAVEN 2.0: A versatile toolbox for metabolic network reconstruction and a case study on Streptomyces coelicolor](https://github.com/SysBioChalmers/workshops/blob/feat/YeastDoc_2019/YeastDoc_2019/reading_materials/RAVEN_2.pdf). PLoS Computational Biology, 14(10).
- Lu, H., Li, F., Sánchez, B. J., Zhu, Z., Li, G., Domenzain, I., … Nielsen, J. (2019). [A consensus S. cerevisiae metabolic model Yeast8 and its ecosystem for comprehensively probing cellular metabolism](https://github.com/SysBioChalmers/workshops/blob/feat/YeastDoc_2019/YeastDoc_2019/reading_materials/yeastGEM.pdf). Nature Communications, 10(1), 3586.

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
