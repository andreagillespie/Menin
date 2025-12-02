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
MHC-CSCT05-K562-NT2-H3K4me3_S2.RPGC.bw MHC-CSCT05-K562-AEBP2sgRNA-H3K4me3_S3.RPGC.bw MHC-CSCT05-K562-MTF2sgRNA-H3K4me3_S4.RPGC.bw \
-R ../../reference_files/CSCT03_CAS_bivalent_genes_2kTSS.bed -a 3000 -b 3000 -m 5000 -o CnTmatrix_K4_RPGCnorm_bivalentGenes.gz

plotHeatmap -m CnTmatrix_K4_RPGCnorm_bivalentGenes.gz --sortUsingSamples 1 --sortUsing sum --samplesLabel \
NT2-H3K4me3 AEBP2sgRNA-H3K4me3 MTF2sgRNA-H3K4me3 \
--colorMap Oranges --regionsLabel "bivalent genes" \
--heatmapHeight 11 --heatmapWidth 4 \
-o ../../plots/Heatmap_K4_RPGCnorm_bivalentGenes.pdf --plotTitle "Cut&Tag H3K4me3 bivalent genes"

