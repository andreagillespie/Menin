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
MHC-CSCR04-K562-CAS-RING1B_S16.bw MHC-CSCR04-K562-MEN1c4-RING1B_S17.bw MHC-CSCR04-K562-EEDko-RING1B_S18.bw MHC-CSCR04-K562-EEDkoANDMEN1ko-RING1B_S19.bw \
-R /data/reference/dawson_labs/bed_files/Hg19/Hg19EnsGeneDT.bed -a 3000 -b 3000 -m 5000 -o CSCR04_RING1B_Cov_matrix_RPCGNorm_Hg19EnsGenes.gz

plotProfile -m CSCR04_RING1B_Cov_matrix_RPCGNorm_Hg19EnsGenes.gz --perGroup --samplesLabel \
CAS-RING1B MEN1c4-RING1B EEDko-RING1B EEDkoANDMEN1ko-RING1B \
-o ../../plots/Profile_CSCR04_RING1B_RPGCnorm_Hg19EnsGenes.pdf --plotTitle "Cut&Run CSCR04 RING1B All genes"

plotHeatmap -m CSCR04_RING1B_Cov_matrix_RPCGNorm_Hg19EnsGenes.gz --sortUsingSamples 1 --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CAS-RING1B MEN1c4-RING1B EEDko-RING1B EEDkoANDMEN1ko-RING1B \
-o ../../plots/Heatmap_CSCR04_RING1B_RPGCnorm_Hg19EnsGenes.pdf --plotTitle "Cut&Run CSCR04 RING1B All genes"
