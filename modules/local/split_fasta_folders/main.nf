process SPLIT_FASTA_FOLDERS {
    tag "$transcriptome_fa"
    label 'process_medium'

    input:
    path transcriptome_fa

    output:
    path 'sequence_group'       , emit: sequence_group

    script: 
    def bin = "${params.bin}"

    """
    ${bin}/run_split_sequence.sh ${transcriptome_fa} ./transcripts
    bash ${bin}/split_fasta_folders.sh -b ./transcripts -n ${params.split_num} -o ./sequence_group
    """
}
