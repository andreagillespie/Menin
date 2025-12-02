#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=1-0:00:00
#SBATCH --output=../../logs/DTMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix scale-regions -S \
MHC-CSCR01-K562-CAS-SUZ12_S3.bw MHC-CSCR01-K562-MEN1c4-KO-SUZ12_S8.bw \
-R /data/reference/dawson_labs/bed_files/Hg19/Hg19EnsGeneDT.bed -a 3000 -b 3000 -m 5000 -o CSCR01_SUZ12_Cov_matrix_RPCGNorm_Hg19EnsGenes.gz

#CSCR01
plotProfile -m CSCR01_SUZ12_Cov_matrix_RPCGNorm_Hg19EnsGenes.gz --perGroup --samplesLabel \
CAS-SUZ12 MEN1c4-KO-SUZ12 \
-o ../../plots/Profile_CSCR01_SUZ12_RPGCnorm_Hg19EnsGenes.pdf --plotTitle "Cut&Run CSCR01 SUZ12 All genes"

plotHeatmap -m CSCR01_SUZ12_Cov_matrix_RPCGNorm_Hg19EnsGenes.gz --sortUsingSamples 1 --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CAS-SUZ12 MEN1c4-KO-SUZ12 \
-o ../../plots/Heatmap_CSCR01_SUZ12_RPGCnorm_Hg19EnsGenes.pdf --plotTitle "Cut&Run CSCR01 SUZ12 All genes"
