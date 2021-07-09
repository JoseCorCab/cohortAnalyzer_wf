# cohortAnalyzer_wf

This repository includes a workflow that automate the PETS script *coPatReorter.rb* https://github.com/ElenaRojano/pets, that can analyse and clean patient cohorts phenotyped using HPO terms. This workflow also clusterizes patients on each cohort by phenotype.

*Installation and dependencies:* 

1: Clone this repository*

	$ git clone https://github.com/JoseCorCab/cohortAnalyzer_wf.git

2: Install PETS tool following the instuctions from https://github.com/ElenaRojano/pets.git

3: Install ExpHunter suite following the instructions from https://github.com/seoanezonjic/ExpHunterSuite.git

*Setting and launching*
The workflow can be configured by modifying variables on the main executable: daemon.sh

* daemon.sh can be launched in different modes (given as first argument):
	+ '1' Launches the complete workflow
	+ '2' After workflow execution, copy all readable inflormation to results folder 
