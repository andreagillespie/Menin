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
MHC-CSCR01-K562-CAS-H3K27me3_S4.bw MHC-CSCR01-K562-MEN1c4-KO-H3K27me3_S9.bw \
MHC-CSCR01-K562-CAS-MLL1_S2.bw MHC-CSCR01-K562-MEN1c4-KO-MLL1_S7.bw \
MHC-CSCR01-K562-CAS-SUZ12_S3.bw MHC-CSCR01-K562-MEN1c4-KO-SUZ12_S8.bw \
-R /data/reference/dawson_labs/bed_files/Hg19/Hg19EnsGene1kbProm.bed -a 3000 -b 3000 -m 5000 -o CSCR01_Cov_matrix_RPCGNorm_all_Genes.gz

#CSCR01
plotProfile -m CSCR01_Cov_matrix_RPCGNorm_all_Genes.gz --perGroup --samplesLabel \
CAS-H3K27me3 MEN1c4-KO-H3K27me3 CAS-MLL1 MEN1c4-KO-MLL1 CAS-SUZ12 MEN1c4-KO-SUZ12 \
-o ../../plots/Profile_CSCR01_RPGCnorm_AllGenes.pdf --plotTitle "Cut&Run All genes"

plotHeatmap -m CSCR01_Cov_matrix_RPCGNorm_all_Genes.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CAS-H3K27me3 MEN1c4-KO-H3K27me3 CAS-MLL1 MEN1c4-KO-MLL1 CAS-SUZ12 MEN1c4-KO-SUZ12 \
--colorMap Reds Reds Greens Greens Purples Purples -o ../../plots/Heatmap_CSCR01_RPGCnorm_AllGenes.pdf --plotTitle "Cut&Run All genes"
