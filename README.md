# cohortAnalyzer_wf

This repository includes a workflow that automate the PETS script *coPatReorter.rb* https://github.com/ElenaRojano/pets, that can analyse and clean patient cohorts phenotyped using HPO terms. This workflow also clusterizes patients on each cohort by phenotype.

Downloading and configuration:

* git clone cohortAnalyzer_wf --recurse-submodules

* gem install pets

* Rscript -e 'install.packages("devtools", repos="http://cran.us.r-project.org")'
* Rscript -e 'devtools::install_github("seoanezonjic/ExpHunterSuite", dependencies=TRUE)'

* export PATH=/path/to/cohortAnalyzer_wf/sys_bio_lab_scripts/scripts:$PATH
* export PATH=/path/to/R/libs/ExpHunterSuite/scripts:$PATH


The workflow can be configured by modifying the main executable: daemon.sh

* daemon.sh can be launched in different modes (given as first argument):
	+ '1' Launches the complete workflow
	+ '2' After workflow execution, copy all readable inflormation to results folder 
