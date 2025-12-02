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
MHC-CSCR04-K562-CAS-MLL1_S12.bw MHC-CSCR04-K562-MEN1c4-MLL1_S13.bw MHC-CSCR04-K562-EEDko-MLL1_S14.bw MHC-CSCR04-K562-EEDkoANDMEN1ko-MLL1_S15.bw \
MHC-CSCR04-K562-CAS-RING1B_S16.bw MHC-CSCR04-K562-MEN1c4-RING1B_S17.bw MHC-CSCR04-K562-EEDko-RING1B_S18.bw MHC-CSCR04-K562-EEDkoANDMEN1ko-RING1B_S19.bw \
-R /data/reference/dawson_labs/bed_files/Hg19/Hg19EnsGene1kbProm.bed -a 3000 -b 3000 -m 5000 -o CSCR04_Cov_matrix_RPCGNorm_all_Genes.gz

plotProfile -m CSCR04_Cov_matrix_RPCGNorm_all_Genes.gz --perGroup --samplesLabel \
CAS-MLL1 MEN1c4-MLL1 EEDko-MLL1 EEDkoANDMEN1ko-MLL1 \
CAS-RING1B MEN1c4-RING1B EEDko-RING1B EEDkoANDMEN1ko-RING1B \
-o ../../plots/Profile_CSCR04_RPGCnorm_AllGenes.pdf --plotTitle "Cut&Run All genes"

plotHeatmap -m CSCR04_Cov_matrix_RPCGNorm_all_Genes.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CAS-MLL1 MEN1c4-MLL1 EEDko-MLL1 EEDkoANDMEN1ko-MLL1 \
CAS-RING1B MEN1c4-RING1B EEDko-RING1B EEDkoANDMEN1ko-RING1B \
--colorMap Greens Greens Greens Greens Oranges Oranges Oranges Oranges -o ../../plots/Heatmap_CSCR04_RPGCnorm_AllGenes.pdf --plotTitle "Cut&Run All genes"
