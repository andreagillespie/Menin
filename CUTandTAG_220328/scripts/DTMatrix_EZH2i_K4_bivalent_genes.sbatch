#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=1-0:00:00
#SBATCH --output=../../logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTmatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix scale-regions -S \
MHC-CSCT05-K562-NT2-H3K4me3_S2.RPGC.bw MHC-CSCT06-K562-CAS-EZH2i-H3K4me3_S12.RPGC.bw MHC-CSCT06-K562-MLL1-2ko-EZH2i-H3K4me3_S14.RPGC.bw \
-R ../../../CUTandTAG_220328_NB501056_0777_AHNGTWBGXL/reference_files/CSCT03_CAS_bivalent_genes_2kTSS.bed -a 3000 -b 3000 -m 5000 \
-o CnTmatrix_EZH2i_K4_RPGCnorm_bivalentGenes.gz

plotHeatmap -m CnTmatrix_EZH2i_K4_RPGCnorm_bivalentGenes.gz --sortUsingSamples 1 --sortUsing sum --samplesLabel \
NT2-H3K4me3 CAS-EZH2i-H3K4me3 MLL1-2ko-EZH2i-H3K4me3 --colorMap Oranges --regionsLabel "bivalent genes" \
--heatmapHeight 6 --heatmapWidth 4 \
-o ../../plots/Heatmap_EZH2i_K4_RPGCnorm_bivalentGenes.pdf --plotTitle "Cut&Tag H3K4me3 bivalent genes"


