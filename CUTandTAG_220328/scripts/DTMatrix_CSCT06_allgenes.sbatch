#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=1-0:00:00
#SBATCH --output=../../logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="deeptools"
#SBATCH --partition=prod_med

module load deeptools/3.5.0


computeMatrix scale-regions -S \
MHC-CSCT06-K562-CAS-EZH2i-H3K4me3_S12.RPGC.bw MHC-CSCT06-K562-MLL1-2ko-EZH2i-H3K4me3_S14.RPGC.bw \
MHC-CSCT06-K562-CAS-EZH2i-IFN-H3K4me3_S13.RPGC.bw MHC-CSCT06-K562-MLL1-2ko-EZH2i-IFN-H3K4me3_S15.RPGC.bw \
-R /data/reference/dawson_labs/bed_files/Hg19/Hg19EnsGeneDT.bed -a 3000 -b 3000 -m 5000 -o CnTmatrix_CSCT06_RPGCnorm_Hg19EnsGenes.gz

plotProfile -m CnTmatrix_CSCT06_RPGCnorm_Hg19EnsGenes.gz --perGroup --samplesLabel \
CAS-EZH2i-H3K4me3 MLL1-2ko-EZH2i-H3K4me3 \
CAS-EZH2i-IFN-H3K4me3 MLL1-2ko-EZH2i-IFN-H3K4me3 \
-o ../../plots/Profile_CSCT06_RPGCnorm_Hg19EnsGenes.pdf --plotTitle "Cut&Tag H3K4me3 All genes"

plotHeatmap -m CnTmatrix_CSCT06_RPGCnorm_Hg19EnsGenes.gz --sortUsingSamples 1 --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CAS-EZH2i-H3K4me3 MLL1-2ko-EZH2i-H3K4me3 \
CAS-EZH2i-IFN-H3K4me3 MLL1-2ko-EZH2i-IFN-H3K4me3 \
-o ../../plots/Heatmap_CSCT06_RPGCnorm_Hg19EnsGenes.pdf --plotTitle "Cut&Tag H3K4me3 All genes"
