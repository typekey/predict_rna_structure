module load singularity
BASEPATH=/project/mengjiechen/leizheng/workspace/rbrowser/rna_structure/rna_structure_prediction
WORKDIR=$BASEPATH/work_icSHAPE_cytoplasm_v2
OUTDIR=$BASEPATH/results_icSHAPE_cytoplasm_v2
TRANSCRIPTOME_FASTA="/project/mengjiechen/leizheng/pipeline/predict_rna_structure/test/rawdata/test_m.fa"

shape_data='/home/leizheng/data/workspace/rbrowser/rna_structure/rna_structure_db/shape_data/icSHAPE_hg38_Nature_Structural___Molecular_Biology_2019_NAI-N3_cytoplasm_invivo_both_score_cytoplasm_vivoNAIN3-score.bed'
exon_data='/project/mengjiechen/leizheng/references/Homo_sapiens/GENCODE/GRCh38/annotation/feature/exon.bed'

current_datetime=$(date "+%Y%m%d%H%M%S")
LOGPATH=$BASEPATH/log

# !!! Use Mouse
# nextflow clean -f
nextflow -log $LOGPATH/${current_datetime}.log \
        run main.nf \
        --outdir $OUTDIR \
        -work-dir $WORKDIR \
        --transcriptome_fa $TRANSCRIPTOME_FASTA \
        --split_num 100 \
        --shape_data $shape_data \
        --exon_data $exon_data \
        -resume 
