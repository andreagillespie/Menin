#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=0-2:00:00
#SBATCH --output=../../logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTHeat"
#SBATCH --partition=prod_short

module load deeptools/3.5.0

plotProfile -m CnTmatrix_K4_RPGCnorm_1kPromAllGenes.gz --perGroup --samplesLabel \
CAS-H3K4me3 EEDko-H3K4me3 MEN1ko-H3K4me3 PCGF1ko-H3K4me3 \
-o ../../plots/Profile_K4_RPGCnorm_1kbPromAllGenes.pdf --plotTitle "Cut&Tag H3K4me3 All genes"

plotHeatmap -m CnTmatrix_K4_RPGCnorm_1kPromAllGenes.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CAS-H3K4me3 EEDko-H3K4me3 MEN1ko-H3K4me3 PCGF1ko-H3K4me3 \
-o ../../plots/Heatmap_K4_RPGCnorm_1KbPromAllGenes.pdf --plotTitle "Cut&Tag H3K4me3 All genes"

plotHeatmap -m CnTmatrix_K27_RPGCnorm_1kPromAllGenes.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CAS-H3K27me3 MEN1ko-H3K27me3 PCGF1ko-H3K27me3 \
-o ../../plots/Heatmap_K27_RPGCnorm_1KbPromAllGenes.pdf --plotTitle "Cut&Tag H3K27me3 All genes"

plotHeatmap -m CnTmatrix_K119_RPGCnorm_1kPromAllGenes.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CAS-H2AK119 EEDko-H2AK119 MEN1ko-H2AK119 PCGF1ko-H2AK119 \
-o ../../plots/Heatmap_K119_RPGCnorm_1KbPromAllGenes.pdf --plotTitle "Cut&Tag H2AK119 All genes"
