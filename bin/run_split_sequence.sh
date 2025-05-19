#!/bin/bash

# 输入的多序列FASTA文件
# input_fasta="./raw_data/gencode.v44.transcripts.fa"
input_fasta=$1

# 输出目录（可选），如果想把输出文件放到一个单独的目录中
# output_dir="./raw_data/transcript"
output_dir=$2

# 创建输出目录（如果需要）
mkdir -p $output_dir

# 读取FASTA文件，按">"分割每个序列，并处理名称分割
awk '/^>/ {
    split($0, a, "."); 
    if(x>0) close(out); 
    x++; 
    out=sprintf("%s/%s.fasta", "'$output_dir'", substr(a[1], 2)); 
    print a[1] > out
} 
!/^>/ {print > out}' $input_fasta
