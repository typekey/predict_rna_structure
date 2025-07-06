process PREDICT_RNA_STRUCTURE_RNAFOLD {
    tag "$transcript_fa"
    label 'process_medium'

    errorStrategy 'ignore'

    publishDir(
        path: { "${params.outdir}/rna_structure/r2s" },
        pattern: "*.r2s",
        mode: 'copy',
    )

    publishDir(
        path: { "${params.outdir}/log" },
        pattern: "*.err",
        mode: 'copy',
    )

    // publishDir(
    //     path: { "${params.outdir}/log" },
    //     pattern: "*.log",
    //     mode: 'copy',
    // )
    // publishDir(
    //     path: { "${params.outdir}/err" },
    //     pattern: "*.err",
    //     mode: 'copy',
    // )

    input:
    path transcript_fa
    path shape_bed

    output:
    // path 'results/*/*.log'       , emit: log
    path '*.err'       , emit: err
    path '*.r2s'       , emit: r2d

    script: 
    def bin = "${params.bin}"

    """
    ${bin}/run_main_with_shape.sh ${transcript_fa} ${task.cpus} ${shape_bed}
    mv ./results/*/*.r2s ./
    mv ./results/*/*.err ./
    rm -rf ./results ./shape ./group*
    """
}
