#!/usr/bin/env nextflow
/*
----------------------------------------------------------------------------------------
File    :   main.nf
Time    :   2025/05/19 13:06:58
Author  :   Lei Zheng
Version :   1.0
Contact :   type.zheng@gmail.com
Github  :   https://github.com/typekey
----------------------------------------------------------------------------------------
*/
nextflow.enable.dsl = 2

include { PREDICT_RNA_STRUCTURE          } from './workflows/predict_rna_structure'

workflow ZL {
    PREDICT_RNA_STRUCTURE ()
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN ALL WORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow {
    ZL ()
}
