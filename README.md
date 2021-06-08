# cohortAnalyzer_wf

This repository includes a workflow that automate the PETS script *coPatReorter.rb* https://github.com/ElenaRojano/pets, that can analyse and clean patient cohorts phenotyped using HPO terms. This workflow also clusterizes patients on each cohort by phenotype.
The workflow can be configured by modifying the main executable: daemon.sh

* daemon.sh can be launched in different modes (given as first argument):
	+ '1' Launches the complete workflow
	+ '2' After workflow execution, copy all readable inflormation to results folder 
