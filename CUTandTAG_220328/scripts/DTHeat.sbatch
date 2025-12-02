#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=0-2:00:00
#SBATCH --output=../../logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="deeptools"
#SBATCH --partition=prod_short

module load deeptools/3.5.0

plotHeatmap -m CnTmatrix_K4_RPGCnorm_1kPromAllGenes.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
NT2-H3K4me3 AEBP2sgRNA-H3K4me3 MTF2sgRNA-H3K4me3 \
--colorMap Reds Blues Oranges -o ../../plots/Heatmap_K4_RPGCnorm_1KbPromAllGenes.pdf --plotTitle "Cut&Tag H3K4me3 All genes"

plotHeatmap -m CnTmatrix_K27_RPGCnorm_1kPromAllGenes.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
NT2-H3K27me3 AEBP2sgRNA-H3K27me3 MTF2sgRNA-H3K27me3 \
-o ../../plots/Heatmap_K27_RPGCnorm_1KbPromAllGenes.pdf --plotTitle "Cut&Tag H3K27me3 All genes"

plotHeatmap -m CnTmatrix_K119_RPGCnorm_1kPromAllGenes.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
NT2-H2AK119 AEBP2sgRNA-H2AK119 MTF2sgRNA-H2AK119 \
-o ../../plots/Heatmap_K119_RPGCnorm_1KbPromAllGenes.pdf --plotTitle "Cut&Tag H2AK119 All genes"



