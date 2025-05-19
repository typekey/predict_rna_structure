#!/bin/bash
#SBATCH --no-requeue
#SBATCH --signal B:USR2@30
#SBATCH -c 24
#SBATCH --mem-per-cpu 2216M
#SBATCH --account=pi-mengjiechen
#SBATCH --job-name=r2s_shape_build
#SBATCH --output=r2s_shape_build.out
#SBATCH --error=r2s_shape_build.err
#SBATCH --time=36:00:00
#SBATCH --partition=caslake
#SBATCH --nodes=1
#SBATCH --mail-type=ALL
#SBATCH --mail-user=leizheng@uchicago.edu

# shape_data='/home/leizheng/data/workspace/rbrowser/rna_structure/rna_structure_db/shape_data/icSHAPE_hg38_Nature_Structural___Molecular_Biology_2019_NAI-N3_cytoplasm_invivo_both_score_cytoplasm_vivoNAIN3-score.bed'
# exon_data='/project/mengjiechen/leizheng/references/Homo_sapiens/GENCODE/GRCh38/annotation/feature/exon.bed'
shape_data=$1
exon_data=$2
output_dir=$3

./extract_shape_data.py --shape_data $shape_data \
                        --exon_data $exon_data \
                        --out_dir $output_dir