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

computeMatrix reference-point -S \
MHC-CSCT05-K562-NT2-H3K4me3_S2.RPGC.bw MHC-CSCT06-K562-CAS-EZH2i-H3K4me3_S12.RPGC.bw MHC-CSCT06-K562-MLL1-2ko-EZH2i-H3K4me3_S14.RPGC.bw \
-R ../../../CUTandRUN_220310_NB501056_0771_AHMVHHBGXL/reference_files/CSCR01_1RPM_MLL_UP_K4only_TSS2k_K4_counts.bed \
--referencePoint center -a 3000 -b 3000 -o CnTmatrix_EZH2i_K4_RPGCnorm_MLL_UP_Genes.gz

plotHeatmap -m CnTmatrix_EZH2i_K4_RPGCnorm_MLL_UP_Genes.gz --sortUsingSamples 1 --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
NT2-H3K4me3 CAS-EZH2i-H3K4me3 MLL1-2ko-EZH2i-H3K4me3 --colorMap Oranges --regionsLabel "MLL1 gain" --refPointLabel peak.center --heatmapHeight 6 \
-o ../../plots/Heatmap_EZH2i_K4_RPGCnorm_MLL_UP_Genes.pdf --plotTitle "Cut&Tag H3K4me3 MLL1 up genes"


