process PREDICT_RNA_STRUCTURE_RNAFOLD {
    tag "$transcript_fa"
    label 'process_medium'

    publishDir(
        path: { "${params.outdir}/rna_structure" },
        pattern: "*.r2s",
        mode: 'copy',
    )
    publishDir(
        path: { "${params.outdir}/log" },
        pattern: "*.log",
        mode: 'copy',
    )
    publishDir(
        path: { "${params.outdir}/err" },
        pattern: "*.err",
        mode: 'copy',
    )

    input:
    path transcript_fa
    path shape_bed

    output:
    path 'results/*/*.log'       , emit: log
    path 'results/*/*.err'       , emit: err
    path 'results/*/*.r2s'       , emit: r2s

    script: 
    def bin = "${params.bin}"

    """
    ${bin}/run_main_with_shape.sh ${transcript_fa} ${task.cpus} ${shape_bed}
    """
}
