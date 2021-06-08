#!/usr/bin/env bash
hostname
. ~soft_bio_267/initializes/init_pets
PATH="~pedro/dev_gems/pets/bin:~josecordoba/software/cohortAnalyzer_wf/aux_scripts":$PATH
export PATH

pat_cluster_file=$1
cohort_name=$2 
cluster_to_filter=$3
cohorts_path="/mnt/home/users/bio_267_uma/josecordoba/software/cohortAnalyzer_wf/cohorts"

extract_cluster_PACO.rb $cohorts_path'/'$cohort_name'.txt' $pat_cluster_file $cluster_to_filter > $cluster_to_filter'_'$cohort_name'.txt'
get_sorted_profs.rb -c 'chr' -d 'patient_id' -p 'phenotypes' -S '|' -P $cluster_to_filter'_'$cohort_name'.txt' -L 20,40
