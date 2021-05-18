#!/usr/bin/env bash

cohort_path="/mnt/home/users/bio_267_uma/elenarojano/projects/pets/CohortAnalyzer/cohorts/paper_cohorts"
mkdir cohorts
cd cohorts


ln -s $cohort_path/../newrelease_decipher_all.txt ./decipher.txt
ln -s $cohort_path/pmm2_paco_format.txt ./pmm2_CDG.txt
ln -s $cohort_path/gold_standard_humu22442_results_phens.txt ./id_mca.txt

cd ..
