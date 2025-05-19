process EXTRACT_SHAPE_DATA {
    tag "$shape_bed"
    label 'process_medium'

    input:
    path shape_bed
    path exon_bed

    output:
    path 'shape'       , emit: shape

    script: 
    def bin = "${params.bin}"

    """
    ${bin}/extract_shape_data.py \
            --shape_data ${shape_bed} \
            --exon_data ${exon_bed} \
            --out_dir ./shape
    """
}
