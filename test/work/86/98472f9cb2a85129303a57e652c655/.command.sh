#!/bin/bash -ue
# /project/mengjiechen/leizheng/pipeline/predict_rna_structure/bin/run_split_sequence.sh test.fa ./transcripts
bash /project/mengjiechen/leizheng/pipeline/predict_rna_structure/bin/split_fasta_folders.sh -b ./ -n 1 -o ./sequence_group
