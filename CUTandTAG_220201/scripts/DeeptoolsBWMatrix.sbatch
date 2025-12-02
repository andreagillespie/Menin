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
MHC-CSCT03-K562-CAS-H2AK119_S10.bw MHC-CSCT03-K562-EEDko-H2AK119_S12.bw \
MHC-CSCT03-K562-MEN1ko-H2AK119_S11.bw MHC-CSCT03-K562-PCGF1ko-H2AK119_S13.bw \
MHC-CSCT03-K562-CAS-H3K27me3_S6.bw MHC-CSCT03-K562-EEDko-H3K27me3_S8.bw \
MHC-CSCT03-K562-MEN1ko-H3K27me3_S7.bw MHC-CSCT03-K562-PCGF1ko-H3K27me3_S9.bw \
MHC-CSCT03-K562-CAS-H3K4me3_S2.bw MHC-CSCT03-K562-EEDko-H3K4me3_S4.bw \
MHC-CSCT03-K562-MEN1ko-H3K4me3_S3.bw MHC-CSCT03-K562-PCGF1ko-H3K4me3_S5.bw \
-R /data/reference/dawson_labs/bed_files/Hg19/Hg19EnsGene1kbProm.bed -a 3000 -b 3000 -m 5000 \
-o CnTmatrix_CUTandTAG_RPGCnorm_1kPromAllGenes.gz

plotProfile -m CnTmatrix_CUTandTAG_RPGCnorm_1kPromAllGenes.gz --perGroup --samplesLabel \
CAS-H2AK119 EEDko-H2AK119 MEN1ko-H2AK119 PCGF1ko-H2AK119 \
CAS-H3K27me3 EEDko-H3K27me3 MEN1ko-H3K27me3 PCGF1ko-H3K27me3 \
CAS-H3K4me3 EEDko-H3K4me3 MEN1ko-H3K4me3 PCGF1ko-H3K4me3 \
-o ../../plots/Profile_CnT_RPGCnorm_1kbPromAllGenes.pdf --plotTitle "Cut&Tag All genes"

plotHeatmap -m CnTmatrix_CUTandTAG_RPGCnorm_1kPromAllGenes.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CAS-H2AK119 EEDko-H2AK119 MEN1ko-H2AK119 PCGF1ko-H2AK119 \
CAS-H3K27me3 EEDko-H3K27me3 MEN1ko-H3K27me3 PCGF1ko-H3K27me3 \
CAS-H3K4me3 EEDko-H3K4me3 MEN1ko-H3K4me3 PCGF1ko-H3K4me3 \
--colorMap Reds Reds Reds Reds Blues Blues Blues Blues Oranges Oranges Oranges Oranges \
-o ../../plots/Heatmap_CnT_RPGCnorm_1KbPromAllGenes.pdf --plotTitle "Cut&Tag All genes"
