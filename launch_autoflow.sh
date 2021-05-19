#!/usr/bin/env bash

source ~soft_bio_267/initializes/init_autoflow
CODE_PATH=`pwd`
if [ ! -d $CODE_PATH/cohorts ]; then
	$CODE_PATH/link_cohorts.sh
fi

output_path=$SCRATCH/phenotypes/cohortAnalyzer_wf
cohorts_path=$CODE_PATH"/cohorts"
cohorts='decipher;pmm2_CDG;id_mca'
cohorts='pmm2_CDG;id_mca'
custom_opt=$CODE_PATH'/custom_opt'

AF_VARS=`echo -e "
			\\$all_cohorts=$cohorts,
			\\$custom_options=$custom_opt,
			\\$HPO='/mnt/home/users/bio_267_uma/elenarojano/dev_gem/pets/external_data/hp.obo',
			\\$cohorts_path=$cohorts_path
 " | tr -d [:space:]`


AutoFlow -e -w $CODE_PATH/cohortAnalyzer.af -V $AF_VARS -o $output_path -c 2 -m 5gb -t '03:00:00' $1
