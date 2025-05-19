#!/usr/bin/env python3
# -*- encoding: utf-8 -*-
'''
@File    :   extract_shape_data.py
@Time    :   2024/04/27 18:53:42
@Author  :   Lei Zheng
@Version :   2.0
@Contact :   type.zheng@gmail.com
'''
import os
import pandas as pd
from multiprocessing import Pool
import argparse

# 获取 SHAPE signals
def get_score(rna_id, out_dir):
    rna_res = exon_df.query(f"rna_id=='{rna_id}'")
    rna_shape_df = pd.DataFrame(columns=['index', 'start', 'score'])
    index = 0
    ctotal = 0
    pos_total = []

    if not os.path.exists(out_dir):
        os.makedirs(out_dir)

    for cds in rna_res.iterrows():
        cds = cds[1]
        chrom = cds['chrom']
        start = cds['start']
        end = cds['end']
        strand = cds['strand']
    
        cds_len = end - start
        ctotal += cds_len
        # print(i, id, chrom, start, end,strand, cds_len, ctotal)
        
        score_df = shape_df.query(f"start>={start} & end<{end} &  strand=='{strand}' & chrom=='{chrom}'")
        score_count = score_df.shape[0]
        scores = []
        for pos in range(cds_len):
            pos = start + pos
            pos_total.append(pos)
            
        if score_count == 0:
            scores = [-999 for ele in range(end - start)]
        elif score_count < cds_len:
            for pos in range(cds_len):
                pos = start + pos
                current_score_df = score_df.query(f"start=={pos}")
                if current_score_df.shape[0] == 0:
                    scores.append(-999)
                else:
                    scores.append(current_score_df['score'].iloc[0])
        elif score_count == cds_len:
            scores = [ele for ele in score_df['score']]
    
        # to bed
        k=0
        for j, score in enumerate(scores):
            rna_shape_df.loc[index] = [index+1, start+k, score]
            k+=1
            index += 1
    rna_shape_df = rna_shape_df.loc[:, ['index', 'score']]
    rna_shape_df['index'] = rna_shape_df['index'].astype(int)
    rna_id = rna_id.split(".")[0]
    rna_shape_df.to_csv(f'{out_dir}/{rna_id}.shape', sep="\t", index=False, header=False)

# Helper function for multiprocessing
def process_rna(args):
    rna, out_dir = args
    rna_id = rna['rna_id']
    print(f"Processing {rna_id}")
    get_score(rna_id, out_dir)

# Main data and directory settings
def main():
    parser = argparse.ArgumentParser(description="Process RNA SHAPE signals.")
    parser.add_argument('--shape_data', type=str, required=True, help="Path to the SHAPE data file.")
    parser.add_argument('--exon_data', type=str, required=True, help="Path to the exon data file.")
    parser.add_argument('--out_dir', type=str, required=True, help="Output directory for SHAPE results.")
    parser.add_argument('--threads', type=int, default=24, help="Number of threads for parallel processing.")
    args = parser.parse_args()

    global shape_df, exon_df

    shape_df = pd.read_csv(args.shape_data, sep='\t', names=['chrom', 'start', 'end', 'name', 'score', 'strand'])
    exon_df = pd.read_csv(args.exon_data, sep='\t', names=['chrom', 'start', 'end', 'name', 'score', 'strand'])
    exon_df['rna_id'] = exon_df['name'].apply(lambda x: x.split("_")[1])
    exon_df.drop_duplicates(subset=["rna_id"], inplace=True)

    rna_list = exon_df.drop_duplicates(subset=["rna_id"])
    target_df = rna_list

    with Pool(args.threads) as pool:
        pool.map(process_rna, [(rna[1], args.out_dir) for rna in target_df.iterrows()])

if __name__ == "__main__":
    main()



