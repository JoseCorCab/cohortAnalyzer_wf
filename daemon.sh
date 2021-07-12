#!/usr/bin/env bash

source ~soft_bio_267/initializes/init_autoflow
CODE_PATH=`pwd`
export PATH=$CODE_PATH/aux_scripts:$PATH
mode=$1
af_add_options=$2

if [ ! -d $CODE_PATH/cohorts ]; then
	$CODE_PATH/link_cohorts.sh
fi
custom_opt=$CODE_PATH'/custom_opt' 
cohorts_path=$CODE_PATH"/cohorts" 


###### SETTINGS TO EDIT
########################################################
########################################################

output_path=$SCRATCH/phenotypes/cohortAnalyzer_wf #define output folder
cohorts='decipher;pmm2_CDG;enod;full_id_mca' #semicolon separated names of cohorts to execute, cohorts names must match with first column in custom_opt file and PACO files in $cohorts_path (without extension)
# cohorts='%decipher;%pmm2_CDG;%full_id_mca;enod'
# cohorts='pmm2_CDG;id_mca;full_id_mca'
path_to_hpo='/mnt/home/users/bio_267_uma/elenarojano/dev_gem/pets/external_data/hp.obo' #define path to HPO file in OBO format
path_to_GO=$CODE_PATH/go-basic.obo  #define path to GO file in OBO format
path_to_annotations='/mnt/home/users/pab_001_uma/pedro/references' #define path to genome_version folder (must be configured in custom_opt file) that includes an annotation.gtf file

########################################################
########################################################

mkdir -p $output_path

if [ "$mode" == "1" ]; then


	AF_VARS=`echo -e "
			\\$all_cohorts=$cohorts, 
			\\$custom_options=$custom_opt,
			\\$HPO=$path_to_hpo, 
			\\$annotation_path=$path_to_annotations,
			\\$cohorts_path=$cohorts_path,
			\\$GO=$path_to_GO 
	 " | tr -d [:space:]`


	AutoFlow -e -w $CODE_PATH/cohortAnalyzer.af -V $AF_VARS -o $output_path/wf_performance -c 2 -m 5gb -t '03:00:00' $af_add_options

elif [ "$mode" == "2" ]; then 

	mkdir -p $output_path/results/general $output_path/results/clustering $output_path/results/fun_results
	cp $output_path/wf_performance/coPatReporter*/*.html $output_path/results
	mv $output_path/results/*clusters.html $output_path/results/clustering
	mv $output_path/results/*.html $output_path/results/general

	cp -r $output_path/wf_performance/cluster*/*functional_enrichment $output_path/results/fun_results
	rm $output_path/results/fun_results/*/enr*

fi
