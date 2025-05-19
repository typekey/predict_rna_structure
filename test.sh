# module load singularity
BASEPATH=./test
WORKDIR=$BASEPATH/work
OUTDIR=$BASEPATH/results
TRANSCRIPTOME_FASTA="/home/leizheng/workspace/pipeline/predict_rna_structure/test/rawdata/test_m.fa"

shape_data='/home/leizheng/workspace/pipeline/predict_rna_structure/test/rawdata/test_shape.bed'
exon_data='/home/leizheng/workspace/pipeline/predict_rna_structure/test/rawdata/test_exon.bed'

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
