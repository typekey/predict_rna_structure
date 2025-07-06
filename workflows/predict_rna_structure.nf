#!/usr/bin/env nextflow
/*
----------------------------------------------------------------------------------------
File    :   predict_rna_structure.nf
Time    :   2025/05/19 13:09:29
Author  :   Lei Zheng
Version :   1.0
Contact :   type.zheng@gmail.com
Github  :   https://github.com/typekey
----------------------------------------------------------------------------------------
*/

include { SPLIT_FASTA_FOLDERS            } from '../modules/local/split_fasta_folders'
include { EXTRACT_SHAPE_DATA             } from '../modules/local/extract_shape_data'
include { PREDICT_RNA_STRUCTURE_RNAFOLD  } from '../modules/local/predict_rna_structure_rnafold'

workflow PREDICT_RNA_STRUCTURE {

    SPLIT_FASTA_FOLDERS(
        params.transcriptome_fa
    )
    ch_split_fasta_folders = SPLIT_FASTA_FOLDERS.out.sequence_group.flatten()

    EXTRACT_SHAPE_DATA(
        params.shape_data,
        params.exon_data
    )
    ch_extract_shape_data = EXTRACT_SHAPE_DATA.out.shape

    ch_split_fasta_folders

    PREDICT_RNA_STRUCTURE_RNAFOLD(
        ch_split_fasta_folders,
        ch_extract_shape_data
    )
    
    // Extract shape data

}