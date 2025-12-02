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
MHC-CSCT03-K562-CAS-H3K27me3_S6.RPGC.bw \
MHC-CSCT03-K562-MEN1ko-H3K27me3_S7.RPGC.bw MHC-CSCT03-K562-PCGF1ko-H3K27me3_S9.RPGC.bw \
-R /dawson_genomics/Projects/Menin/ChIPseq_200320_NB501056_0470_AH5NJJBGXF/scripts/MeninGenes2DT.bed -a 3000 -b 3000 -m 5000 \
-o CnTmatrix_K27_RPGCnorm_MeninGenes2.gz

plotProfile -m CnTmatrix_K27_RPGCnorm_MeninGenes2.gz --perGroup --samplesLabel \
CAS-H3K27me3 MEN1ko-H3K27me3 PCGF1ko-H3K27me3 \
-o ../../plots/Profile_K27_RPGCnorm_MeninGenes2.pdf --plotTitle "Cut&Tag H3K27me3 Menin genes LFC < -1"

plotHeatmap -m CnTmatrix_K27_RPGCnorm_MeninGenes2.gz --sortUsingSamples 1 --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CAS-H3K27me3 MEN1ko-H3K27me3 PCGF1ko-H3K27me3 \
-o ../../plots/Heatmap_K27_RPGCnorm_MeninGenes2.pdf --plotTitle "Cut&Tag H3K27me3 Menin genes LFC < -1"

