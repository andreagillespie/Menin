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
MHC-CSCT03-K562-CAS-H3K4me3_S2.RPGC.bw MHC-CSCT03-K562-EEDko-H3K4me3_S4.RPGC.bw \
MHC-CSCT03-K562-MEN1ko-H3K4me3_S3.RPGC.bw MHC-CSCT03-K562-PCGF1ko-H3K4me3_S5.RPGC.bw \
-R /dawson_genomics/Projects/Menin/ChIPseq_200320_NB501056_0470_AH5NJJBGXF/scripts/MeninGenesDT.bed -a 3000 -b 3000 -m 5000 \
-o CnTmatrix_K4_RPGCnorm_MeninGenes.gz

plotProfile -m CnTmatrix_K4_RPGCnorm_MeninGenes.gz --perGroup --samplesLabel \
CAS-H3K4me3 EEDko-H3K4me3 MEN1ko-H3K4me3 PCGF1ko-H3K4me3 \
-o ../../plots/Profile_K4_RPGCnorm_MeninGenes.pdf --plotTitle "Cut&Tag H3K4me3 Menin genes"

plotHeatmap -m CnTmatrix_K4_RPGCnorm_MeninGenes.gz --sortUsingSamples 1 --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CAS-H3K4me3 EEDko-H3K4me3 MEN1ko-H3K4me3 PCGF1ko-H3K4me3 \
-o ../../plots/Heatmap_K4_RPGCnorm_MeninGenes.pdf --plotTitle "Cut&Tag H3K4me3 Menin genes"

