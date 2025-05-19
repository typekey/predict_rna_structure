#!/bin/bash
#SBATCH --no-requeue
#SBATCH --signal B:USR2@30
#SBATCH -c 24
#SBATCH --mem-per-cpu 2160M
#SBATCH --account=pi-mengjiechen
#SBATCH --job-name=r2s_shape_build
#SBATCH --output=r2s_shape_build.out
#SBATCH --error=r2s_shape_build.err
#SBATCH --time=36:00:00
#SBATCH --partition=caslake
#SBATCH --nodes=1
#SBATCH --mail-type=ALL
#SBATCH --mail-user=leizheng@uchicago.edu

RNAfold="/scratch/midway3/leizheng/mambaforge/envs/rna_structure/bin/RNAfold"
RNAplot="/scratch/midway3/leizheng/mambaforge/envs/rna_structure/bin/RNAplot"
RNAfold_b2mt="/scratch/midway3/leizheng/mambaforge/envs/rna_structure/share/ViennaRNA/bin/b2mt.pl"
bprna="/home/leizheng/data/workspace/rbrowser/rna_structure/rna_structure_db/bpRNA/bpRNA.pl"
perl="/scratch/midway3/leizheng/mambaforge/bin/perl"

base_dir=/home/leizheng/data/workspace/rbrowser/rna_structure/rna_structure_db
shape_dir=/home/leizheng/data/workspace/rbrowser/rna_structure/analysis/build_r2s_file_with_shape/shape_icSHAPE_MB2019

base_dir=$1
threads=$2
shape_dir=$3

process_rna() {
    rna_fasta=$1
    rna_id=$(basename "$rna_fasta" ".fasta")
    rna_dir=$(realpath "./results/${rna_id}")
    echo "Processing: $rna_id"
    mkdir -p $rna_dir

    structure_path="$rna_dir/$rna_id.structure"
    dbn_file="$rna_dir/$rna_id.dbn"
    score_file="$rna_dir/$rna_id.score"
    plot_svg_file="$rna_dir/$rna_id.svg"
    anno_file="$rna_dir/$rna_id.anno"
    r2s_file="$rna_dir/$rna_id.r2s"
    shape_file="$shape_dir/$rna_id.shape"

    # Compute MEA (maximum expected accuracy) structure
    echo "Compute MEA: $rna_id"
    $RNAfold --MEA -i "$rna_fasta" --shape "$shape_file" > $structure_path

    # Format dbn structure
    echo "Extract structure: $rna_id"
    awk 'NR<=3 {if (NR==3) {gsub(/^[ \t]+|[ \t]+$/, "", $0); split($0, arr, " "); print arr[1]} else {print $0}}' $structure_path > $dbn_file

    # Produce coordinates for a mountain plot from bracket notation
    echo "Produce structure score: $rna_id"
    $RNAfold_b2mt "$structure_path" > "$score_file"

    # Plot structure svg
    echo "Plot structure svg: $rna_id"
    $RNAplot --output-format svg < $dbn_file
    mv ./${rna_id}_dp.ps $rna_dir/${rna_id}_dp.ps
    mv ./${rna_id}_ss.ps $rna_dir/${rna_id}_ss.ps
    mv ./${rna_id}_ss.svg $plot_svg_file

    # Annotate structure
    echo "Annotate structure: $rna_id"
    $perl $bprna "$dbn_file"
    mv ./${rna_id}.st $anno_file

    # Build r2s file
    echo "Build r2s file: $rna_id"
    ./build_r2s.py --svg_file $plot_svg_file --dbn_file $dbn_file --anno_file $anno_file --score_file $score_file --output_path $rna_dir
}

export -f process_rna
export RNAfold RNAplot RNAfold_b2mt bprna perl base_dir

find ${base_dir} -name "*.fasta" | xargs -n 1 -P $threads -I {} bash -c 'process_rna "$@"' _ {}
