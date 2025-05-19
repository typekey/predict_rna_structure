#!/bin/bash
#----------------------------------------------------------------------------------------
# File    :   split_folders.sh
# Time    :   2025/02/06 14:59:47
# Author  :   Lei Zheng
# Version :   1.0
# Contact :   type.zheng@gmail.com
# Github  :   https://github.com/typekey
# ----------------------------------------------------------------------------------------


# 解析参数
while getopts "b:n:o:" opt; do
  case $opt in
    b) base_dir="$OPTARG" ;;
    n) num_groups="$OPTARG" ;;
    o) output_path="$OPTARG" ;;
    *) echo "Usage: $0 -b <base_dir> -n <num_groups> -o <output_path>"; exit 1 ;;
  esac
done

# 检查参数
if [ -z "$base_dir" ] || [ -z "$num_groups" ] || [ -z "$output_path" ]; then
  echo "Missing required arguments. Usage: $0 -b <base_dir> -n <num_groups> -o <output_path>"
  exit 1
fi

# 获取 .fasta 文件总数
total_files=$(find "$base_dir" -type f -name "*.fasta" | wc -l)

# 计算每组的文件数（向上取整）
files_per_group=$(( (total_files + num_groups - 1) / num_groups ))

echo "Total files: $total_files"
echo "Files per group: $files_per_group"

# 创建临时分割文件列表
mkdir -p "$output_path/split"
find "$base_dir" -type f -name "*.fasta" | split -l "$files_per_group" - "$output_path/split/group_"

# 按组移动文件
count=1
for group in "$output_path"/split/group_*; do
    mkdir -p "$output_path/group_$count"
    xargs -a "$group" mv -t "$output_path/group_$count/"
    ((count++))
done

echo "Files have been successfully split into $num_groups groups."

# 清理临时文件
rm -rf "$output_path/split"
