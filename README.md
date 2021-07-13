# cohortAnalyzer_wf

This repository includes a workflow that automate the PETS script *coPatReorter.rb* https://github.com/ElenaRojano/pets, that can analyse and clean patient cohorts phenotyped using HPO terms. This workflow also clusterizes patients on each cohort by phenotype. Analysis and clustering of cohorts included in the paper are stored in **results_paper** folder

## *Installation and dependencies:* 
N.B. The user must have Ruby and R installed.

1: Clone this repository*

	$ git clone git@github.com:JoseCorCab/cohortAnalyzer_wf.git --recurse-submodules

2: Install the workflow manager Autoflow throught:
	
	$gem install autoflow 

3: Install PETS tool following the instuctions from https://github.com/ElenaRojano/pets.git

4: Install ExpHunter suite following the instructions from https://github.com/seoanezonjic/ExpHunterSuite.git

5: Add the next folders to PATH variable.
	
	$ export PATH=/path/to/Ruby/gems/pets/external_code/:$PATH
	$ export PATH=/path/to/R/libs/ExpHunterSuite/scripts:$PATH
	$ export PATH=/path/to/cohortAnalyzer_wf/sys_bio_lab_scripts/scripts:$PATH

## *Settings*

### Download
* First you need to download and rename some files to launch the workflow:
	+ HPO obo file -> **folder_to_HPO/hpo.obo**
	+ GO obo file -> **path_to_GO/go-basic.obo**
	+ Annotation of reference genome -> **path_to_genomes**/**genome_name**/annotation.gtf

After that you need to create a *cohorts* folder inside cohortAnalyzer_wf directory. 

In this tutorial we are setting workflow to launch hummu_congenital_full_dataset taken from Vulto-van Silfhout, A.T.; Hehir-Kwa, J.Y.; van Bon, B.W.M.; Schuurs-Hoeijmakers, J.H.M.; Meader, S.; Hellebrekers, C.J.M.; Thoonen, I.J.M.; de Brouwer, A.P.M.; Brunner, H.G.; Webber, C.; Pfundt, R.; de Leeuw, N.; De Vries, B.B.A. Clinical Significance of De Novo and Inherited Copy-Number Variation. Human Mutation 2013, 34, 1679–1687. doi:10.1002/humu.22442.
You can download this example from https://github.com/ElenaRojano/pets/blob/master/example_datasets/hummu_congenital_full_dataset.txt :

	$ mkdir cohorts
	$ curl -L https://github.com/ElenaRojano/pets/blob/master/example_datasets/hummu_congenital_full_dataset.txt -o cohorts/hummu_congenital_full_dataset.txt


### Defining variables of daemon.sh

* Once requested files have been configured some variables from daemon.sh must be correctly defined:
	+ **output_path**: define output folder
	+ **cohorts**: semicolon separated names of cohorts to execute. If there are more than one cohort, names must be separated by semicolon. In the case of the example: cohorts='hummu_congenital_full_dataset'
	+ **path_to_hpo**: define path to HPO file in OBO format (where it was downloaded in the previous section **folder_to_HPO/hpo.obo** )
	+ **path_to_GO**: define path to GO file in OBO format (where it was downloaded in the previous section **path_to_GO/go-basic.obo** )
	+ **path_to_annotations**: define path to genomes folder. This variable is equal to **path_to_genomes** from the previous section. **genome_name** must be configured in *custom_opt*


### Additional options for cohorts
When working with different cohorts, sometimes you need to configure custom options for each. We create the *custom_opt* file to solve this problem. 

* This file has 4 columns separated by tabs:
	+ cohort # name of the cohort. On this example would be hummu_congenital_full_dataset
	+ coPatReporter_custom_options	#additional options for coPatReporter.rb script. See https://github.com/ElenaRojano/pets for more information. Set an empty string to ignore
	+ genome_version # Define the **genome_name** where you saved the annotation.gtf 
	+ min_pat_by_gene # extra options for get_cluster_genes.rb script. Set an empty string to ignore

## Launch workflow

This workflow is divided in two steps. 1º: Main cohortAnalyzer workflow can be executed giving '1' as fisrt argument to daemon.sh. 2º: Results are summarized executing daemon.sh with '2' as first argument:

	$ ./daemon.sh 1 #launches complete workflow
	$ ./daemon.sh 2 #Sumarizes all results from main workflow



