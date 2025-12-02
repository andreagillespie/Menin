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
MHC-CSCT05-K562-NT2-H2AK119_S8.RPGC.bw MHC-CSCT05-K562-AEBP2sgRNA-H2AK119_S9.RPGC.bw MHC-CSCT05-K562-MTF2sgRNA-H2AK119_S10.RPGC.bw \
-R /data/reference/dawson_labs/bed_files/Hg19/Hg19EnsGene1kbProm.bed -a 3000 -b 3000 -m 5000 -o CnTmatrix_K119_RPGCnorm_1kPromAllGenes.gz

plotProfile -m CnTmatrix_K119_RPGCnorm_1kPromAllGenes.gz --perGroup --samplesLabel \
NT2-H2AK119 AEBP2sgRNA-H2AK119 MTF2sgRNA-H2AK119 \
-o ../../plots/Profile_K119_RPGCnorm_1kbPromAllGenes.pdf --plotTitle "Cut&Tag H2AK119 All genes"

plotHeatmap -m CnTmatrix_K119_RPGCnorm_1kPromAllGenes.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
NT2-H2AK119 AEBP2sgRNA-H2AK119 MTF2sgRNA-H2AK119 \
-o ../../plots/Heatmap_K119_RPGCnorm_1KbPromAllGenes.pdf --plotTitle "Cut&Tag H2AK119 All genes"

