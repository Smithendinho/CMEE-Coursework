# **CMEE Mini Project ReadMe**
## Temperature Does Not Affect Model Performance when Predicting Microbial Population Growth

### Description

This study implicated model selection methods to identify a trend between model performances for Gompertz, Linear and Cubic models and temperature. Model fitting, analysis and plotting was carried out using python3 and R. The write up, in latex, may be compiled following the instructions below. 

The project directory is structured as follows within the MiniProject directory:

├── code

│   ├── **DataWrangling.py** - Python script for initial data wrangling and inspection

│   ├── **Fitting_Models.R** - R script for NLLS fitting

│   ├── **Plotting.R** - R script for results anlaysis and plotting

├── report - this subdirectory contains the tex and bib files for the final write up compilation

│   ├── **Bibliography.bib** - contains bibliography compiled at the end of the report

│   ├── **Run_MiniProject.sh** - bash script that executes the python and R script and compiles the Final report

│   ├── **Write_up.tex** - write up in LaTeX format

│   ├── **SI.tex** - Supplimentary information tex file

│   ├── **SIbibliography.bib** - Supplimentary information bibliography

│   ├── **FinalReport.tex** - tex files that concatenates the SI to the end of the report

├── data - this subdirectory will be additionally populated with a csv containing the model performance results

│   ├── **LogisticGrowthData.csv** - Original data set

│   ├── **LogisticGrowthMetaData.csv** - Meta data set containing information explaining the main dataset

├── plots - this subdirectory will be populated with plots illustrating every single subset.

├── results - this subdirectory will be populated with the plots that appear in the final write-up.

├── sandbox - this subdirectory contained code that was not ultimately used for the report.

├── ReadMe.md

### Instructions

1. First ensure package and language dependancies are up to date and installed.
2. Change to the MiniProject/report directory and find Run_MiniProject.sh.
3. Execute **bash Run_MiniProject.sh** in the terminal - ignore LaTeX warnings.

### Programming Language Requirements
* Python 3.10.12
    * Used in DataWrangling.py
* R scripting front-end version 4.1.2 (2021-11-01)
    * Used in Fitting_Models.R and Plotting.R
* pdfTex 3.141592653-2.6-1.40.22
    * Used for Document compilation.

### Packages and Scripts
* DataWrangling.py
    * Pandas 2.1.1 
* Fitting_Models.R
    * dplyr 1.1.3 (Wickham et al., 2023) 
    * purrr 1.1.2 (Wickham & Henry, 2023)
    * minpack.lm 1.2.4 (Elzhov et al., 2023)
* Plotting.R
    * ggplot2 3.4.4 (Wickham, 2016)
    * purrr 1.1.2 (Wickham & Henry, 2023)

*NB: all package versions and citations were generated using the base R functions packageVersion() and citation() respectively.*
#### References 

Timur V. Elzhov, Katharine M. Mullen, Andrej-Nikolai Spiess and Ben Bolker (2023).minpack.lm: R Interface to the Levenberg-Marquardt Nonlinear Least-Squares Algorithm Found in MINPACK, Plus Support for Bounds. R package version 1.2-4. https://CRAN.R-project.org/package=minpack.lm

H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York, 2016.

Hadley Wickham, Romain François, Lionel Henry, Kirill Müller and Davis Vaughan (2023). dplyr: A Grammar of Data Manipulation. R package version 1.1.3. https://CRAN.R-project.org/package=dplyr

Hadley Wickham and Lionel Henry (2023). purrr: Functional Programming Tools. R package version 1.0.2. https://CRAN.R-project.org/package=purrr

