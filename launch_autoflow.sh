#!/usr/bin/env bash

source ~soft_bio_267/initializes/init_autoflow

CODE_PATH=`pwd`
output_path=$SCRATCH/phenotypes/cohortAnalyzer_wf
cohorts_path=$CODE_PATH"/cohorts"
cohorts='decipher;pmm2_CDG;id_mca'
custom_opt=$CODE_PATH'/custom_opt.txt'

AF_VARS=`echo -e "
			\\$all_cohorts=$cohorts,
			\\$custom_options=$custom_opt,
			\\$HPO='/mnt/home/users/bio_267_uma/elenarojano/dev_gem/pets/external_data/hp.obo'
 " | tr -d [:space:]`


AutoFlow -w $CODE_PATH/cohortAnalyzer.af -V $AF_VARS -o $output_path -c 2 -m 20gb -t '1-00:00:00' $1
