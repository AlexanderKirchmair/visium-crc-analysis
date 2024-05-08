#!/bin/bash
#SBATCH --job-name=SPACERANGER
#SBATCH --output=SPACERANGER_%j.out
#SBATCH --partition=medium
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=96
#SBATCH --mem=950G
#SBATCH --time=20:00:00

module purge
source ~/.bashrc

conda activate visium-crc-analysis
export PATH="/home/kirchmair/code/visium-crc-analysis/lib/spaceranger-3.0.0":$PATH

spaceranger count \
                       --transcriptome=/data/databases/CellRanger/refdata-gex-GRCh38-2020-A \
                       --id=$1 \
                       --fastqs=$2 \
                       --cytaimage=$3 \
                       --slidefile=$4 \
                       --probe-set=$5 \
                       --create-bam=false \
                       --jobmode=local \
                       --localcores=96 \
                       --localmem=900 \
                       --disable-ui

