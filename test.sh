module load singularity
BASEPATH=/project/mengjiechen/leizheng/pipeline/predict_rna_structure/test
WORKDIR=$BASEPATH/work_test
OUTDIR=$BASEPATH/results_test
TRANSCRIPTOME_FASTA="/project/mengjiechen/leizheng/references/Homo_sapiens/GENCODE/GRCh38/sequence/transcriptome/gencode.v44.transcripts.fa"
TRANSCRIPTOME_FASTA="/project/mengjiechen/leizheng/pipeline/predict_rna_structure/test/test.fa"
TRANSCRIPTOME_FASTA="/project/mengjiechen/leizheng/pipeline/predict_rna_structure/test/rawdata/test_m.fa"

shape_data='/project/mengjiechen/leizheng/pipeline/predict_rna_structure/test/rawdata/test_shape.bed'
exon_data='/project/mengjiechen/leizheng/pipeline/predict_rna_structure/test/rawdata/test_exon.bed'

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
