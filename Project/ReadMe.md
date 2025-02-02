# CMEE Master's Dissertation ReadMe
## Phylogenetic Backbone Reconstruction using Kmeans Clustering on Coleopteran Mitogenomes

#### Description

This is an exploratory study investigating the use of kmeans clustering for identifying representatives for phylogenetic backbone reconstruction. R and Python were predominantly used in this study. However, the SigClust algorithm written in C originally developed by Chappel et al., (2017) is included in this repo alongside its License. 

The project directory is structured as follows:

├── code

│   ├── Scripts

│   │   ├── Analysis

│   │   │   ├── **Kmeans.R** - R script for executing kmeans on entire pairwise matrix

│   │   │   ├── **Pairwise_Matrix.R** - R script for computing the distance matrix used in multiple stages of the analysis

│   │   │   └── **SigClust_centers.R** - R script for identifying the cluster centers of the SigClust clusters

│   │   ├── DataPrep - This folder is a collection of scripts in both R and python used to clean etc. the data set

│   │   ├── Plotting - This folder has scripts aptly named for their role in final report plots

│   │   │   ├── **Bar_Charts.R** 

│   │   │   ├── **Density_Plots.R**

│   │   │   ├── **Flow_Diagram.R**

│   │   │   └── **Line_Graphs.R**

│   │   └── RunProject - These shell scripts execute different parts of the products

│   │       ├── **run_clustering.sh**

│   │       └── **run_trees.sh**

│   └── SigClust 

├── data

│   ├── MitoGenomes

│   │   ├── 320_MGs

│   │   ├── Complete

│   │   └── example

│   ├── Other

│   │   └── ColeopteranSite100.csv

│   ├── PairwiseMatrices

│   ├── SigClusters

│   └── TreeBuilding

│       ├── 1_nt_raw

│       ├── 2_aa_raw

│       ├── 3_aa_aln

│       ├── 4_nt_aln

├── plots

└── Report

|   ├── Bibliography.bib
    
|   ├── CompileLaTeX.sh
    
|   └── Write_up.tex

#### Instructions

1. Firstly ensure package and language dependancies are installed and up to date.
2. Change directory to Project/code for the execution of run_clustering.sh
3. Execute bash run_clustering.sh in the terminal whilst ignoring LaTeX warnings. NB: only authorized personal with NHM database login details will be able to execute this pipeline.
4. To Compile the final report change to the Project/Report directory and execute 'bash CompileLaTex.sh Write_up.tex'

#### Program Version Requirements

* ipython3 verison 8.20.0
* R scripting front-end version 4.1.2 (2021-11-01)

#### Packages

**R**
* ggplot2 3.4.4
* parallel 4.3.3
* flexclust 1.4.2
* cluster 2.1.6
* tidyr 1.3.1
* dplyr 1.1.4

**ipython3**
* csv 
* pandas
* Bio
* os






