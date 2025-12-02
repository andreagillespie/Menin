#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=1-0:00:00
#SBATCH --output=../../logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix scale-regions -S \
MHC-CSCT05-K562-NT2-H3K27me3_S5.RPGC.bw MHC-CSCT05-K562-AEBP2sgRNA-H3K27me3_S6.RPGC.bw MHC-CSCT05-K562-MTF2sgRNA-H3K27me3_S7.RPGC.bw \
-R ../../reference_files/Hg19EnsGeneDT_K27peaks.bed -a 3000 -b 3000 -m 5000 -o CnTmatrix_K27_RPGCnorm_K27PeaksGenes.gz

plotProfile -m CnTmatrix_K27_RPGCnorm_K27PeaksGenes.gz --perGroup --samplesLabel \
NT2-H3K27me3 AEBP2sgRNA-H3K27me3 MTF2sgRNA-H3K27me3 \
-o ../../plots/Profile_K27_RPGCnorm_K27PeaksGenes.pdf --plotTitle "Cut&Tag H3K27me3 Peaks genes"

plotHeatmap -m CnTmatrix_K27_RPGCnorm_K27PeaksGenes.gz --sortUsingSamples 1 --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
NT2-H3K27me3 AEBP2sgRNA-H3K27me3 MTF2sgRNA-H3K27me3 \
--colorMap Oranges \
-o ../../plots/Heatmap_K27_RPGCnorm_K27PeaksGenes.pdf --plotTitle "Cut&Tag H3K27me3 Peaks genes"



