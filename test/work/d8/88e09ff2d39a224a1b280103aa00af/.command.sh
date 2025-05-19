#!/bin/bash -ue
/project/mengjiechen/leizheng/pipeline/predict_rna_structure/bin/run_split_sequence.sh test_m.fa ./transcripts
bash /project/mengjiechen/leizheng/pipeline/predict_rna_structure/bin/split_fasta_folders.sh -b ./transcripts -n 100 -o ./sequence_group
