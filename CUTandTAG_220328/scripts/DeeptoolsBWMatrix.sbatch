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
MHC-CSCT05-K562-NT2-H3K4me3_S2.RPGC.bw MHC-CSCT05-K562-AEBP2sgRNA-H3K4me3_S3.RPGC.bw MHC-CSCT05-K562-MTF2sgRNA-H3K4me3_S4.RPGC.bw \
MHC-CSCT05-K562-NT2-H3K27me3_S5.RPGC.bw MHC-CSCT05-K562-AEBP2sgRNA-H3K27me3_S6.RPGC.bw MHC-CSCT05-K562-MTF2sgRNA-H3K27me3_S7.RPGC.bw \
MHC-CSCT05-K562-NT2-H2AK119_S8.RPGC.bw MHC-CSCT05-K562-AEBP2sgRNA-H2AK119_S9.RPGC.bw MHC-CSCT05-K562-MTF2sgRNA-H2AK119_S10.RPGC.bw \
-R /data/reference/dawson_labs/bed_files/Hg19/Hg19EnsGene1kbProm.bed -a 3000 -b 3000 -m 5000 -o CnTmatrix_CUTandTAG_RPGCnorm_1kPromAllGenes.gz

plotProfile -m CnTmatrix_CUTandTAG_RPGCnorm_1kPromAllGenes.gz --perGroup --samplesLabel \
NT2-H3K4me3 AEBP2sgRNA-H3K4me3 MTF2sgRNA-H3K4me3 \
NT2-H3K27me3 AEBP2sgRNA-H3K27me3 MTF2sgRNA-H3K27me3 \
NT2-H2AK119 AEBP2sgRNA-H2AK119 MTF2sgRNA-H2AK119 \
-o ../../plots/Profile_CnT_RPGCnorm_1kbPromAllGenes.pdf --plotTitle "Cut&Tag All genes"

plotHeatmap -m CnTmatrix_CUTandTAG_RPGCnorm_1kPromAllGenes.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
NT2-H3K4me3 AEBP2sgRNA-H3K4me3 MTF2sgRNA-H3K4me3 \
NT2-H3K27me3 AEBP2sgRNA-H3K27me3 MTF2sgRNA-H3K27me3 \
NT2-H2AK119 AEBP2sgRNA-H2AK119 MTF2sgRNA-H2AK119 \
--colorMap Reds Reds Reds Blues Blues Blues Oranges Oranges Oranges -o ../../plots/Heatmap_CnT_RPGCnorm_1KbPromAllGenes.pdf --plotTitle "Cut&Tag All genes"

# now for CSCT06
computeMatrix scale-regions -S \
MHC-CSCT06-K562-CAS-EZH2i-H3K4me3_S12.RPGC.bw MHC-CSCT06-K562-MLL1-2ko-EZH2i-H3K4me3_S14.RPGC.bw \
MHC-CSCT06-K562-CAS-EZH2i-IFN-H3K4me3_S13.RPGC.bw MHC-CSCT06-K562-MLL1-2ko-EZH2i-IFN-H3K4me3_S15.RPGC.bw \
-R /data/reference/dawson_labs/bed_files/Hg19/Hg19EnsGene1kbProm.bed -a 3000 -b 3000 -m 5000 -o CnTmatrix_CSCT06_RPGCnorm_1kPromAllGenes.gz

plotProfile -m CnTmatrix_CSCT06_RPGCnorm_1kPromAllGenes.gz --perGroup --samplesLabel \
CAS-EZH2i-H3K4me3 MLL1-2ko-EZH2i-H3K4me3 \
CAS-EZH2i-IFN-H3K4me3 MLL1-2ko-EZH2i-IFN-H3K4me3 \
-o ../../plots/Profile_CSCT06_RPGCnorm_1kbPromAllGenes.pdf --plotTitle "Cut&Tag All genes"

plotHeatmap -m CnTmatrix_CSCT06_RPGCnorm_1kPromAllGenes.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CAS-EZH2i-H3K4me3 MLL1-2ko-EZH2i-H3K4me3 \
CAS-EZH2i-IFN-H3K4me3 MLL1-2ko-EZH2i-IFN-H3K4me3 \
--colorMap Reds Reds Reds Reds -o ../../plots/Heatmap_CSCT06_RPGCnorm_1KbPromAllGenes.pdf --plotTitle "Cut&Tag All genes"
