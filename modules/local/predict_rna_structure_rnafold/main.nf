process PREDICT_RNA_STRUCTURE_RNAFOLD {
    tag "$transcript_fa"
    label 'process_medium'

    input:
    path transcript_fa
    path shape_bed

    output:
    path 'output.log'       , emit: output

    script: 
    def bin = "${params.bin}"

    """
    ${bin}/run_main_with_shape.sh ${transcript_fa} ${task.cpus} ${shape_bed}

    echo "" > output.log
    """
}
