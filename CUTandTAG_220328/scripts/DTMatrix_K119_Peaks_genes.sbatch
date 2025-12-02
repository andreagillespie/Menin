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
-R ../../reference_files/Hg19EnsGeneDT_K119peaks.bed -a 3000 -b 3000 -m 5000 -o CnTmatrix_K119_RPGCnorm_K119PeaksGenes.gz

plotProfile -m CnTmatrix_K119_RPGCnorm_K119PeaksGenes.gz --perGroup --samplesLabel \
NT2-H2AK119 AEBP2sgRNA-H2AK119 MTF2sgRNA-H2AK119 \
-o ../../plots/Profile_K119_RPGCnorm_K119PeaksGenes.pdf --plotTitle "Cut&Tag H2AK119 Peaks genes"

plotHeatmap -m CnTmatrix_K119_RPGCnorm_K119PeaksGenes.gz --sortUsingSamples 1 --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
NT2-H2AK119 AEBP2sgRNA-H2AK119 MTF2sgRNA-H2AK119 \
--colorMap Purples \
-o ../../plots/Heatmap_K119_RPGCnorm_K119PeaksGenes.pdf --plotTitle "Cut&Tag H2AK119 Peaks genes"

