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
-R ../../reference_files/CSCT03_CAS_bivalent_genes_2kTSS.bed -a 3000 -b 3000 -m 5000 -o CnTmatrix_K119_RPGCnorm_bivalentGenes_3samples.gz

plotHeatmap -m CnTmatrix_K119_RPGCnorm_bivalentGenes_3samples.gz --sortUsingSamples 1 --sortUsing sum --samplesLabel \
NT2-H2AK119 AEBP2sgRNA-H2AK119 MTF2sgRNA-H2AK119 \
--colorMap Purples --regionsLabel "bivalent genes" --heatmapHeight 14 --heatmapWidth 4 \
-o ../../plots/Heatmap_K119_RPGCnorm_bivalentGenes_3samples.pdf --plotTitle "Cut&Tag H2AK119 bivalent genes"
