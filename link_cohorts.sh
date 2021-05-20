#!/usr/bin/env bash

cohort_path="/mnt/home/users/bio_267_uma/elenarojano/projects/pets/CohortAnalyzer/cohorts/paper_cohorts/files_to_combine"
mkdir cohorts
cd cohorts


ln -s $cohort_path/decipher_cohort_translated.txt ./decipher.txt
ln -s $cohort_path/pmm2_paco_format.txt ./pmm2_CDG.txt
ln -s $cohort_path/hummu_congenital_full_dataset.txt ./full_id_mca.txt
ln -s $cohort_path/hummu_congenital_partial_dataset.txt ./id_mca.txt

cd ..
