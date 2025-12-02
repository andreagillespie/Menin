#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=40G
#SBATCH --time=1-0:00:00
#SBATCH --output=../../logs/DTMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

#computeMatrix reference-point -S \
#MHC-ReChIP2-K562-SINGLE-H3K27me3_S3.bw MHC-ReChIP2-K562-SINGLE-H3K4me3_S2.bw MHC-ReChIP2-K562-ReChIP-with-clear-H3K4me3_S5.bw \
#-R ../../../CUTandTAG_220328_NB501056_0777_AHNGTWBGXL/reference_files/CSCT03_CAS_bivalent_genes_2kTSS.bed \
#--referencePoint TSS -a 3000 -b 3000 -o Rechip_Cov_matrix_RPCGNorm_bivalent_Genes.gz

#plotProfile -m Rechip_Cov_matrix_RPCGNorm_bivalent_Genes.gz --perGroup --samplesLabel \
#SINGLE-H3K27me3 SINGLE-H3K4me3 ReChIP-H3K4me3-H3K27me3 \
#-o ../../plots/Profile_ReChIP_RPGCnorm_bivalent_Genes.pdf --plotTitle "ReChIP bivalent genes"

plotHeatmap -m Rechip_Cov_matrix_RPCGNorm_bivalent_Genes.gz --sortUsing sum --sortUsingSamples 3 --samplesLabel \
SINGLE-H3K27me3 SINGLE-H3K4me3 ReChIP-H3K27me3-H3K4me3 \
--zMin 0 0 0 \
--zMax 15 75 30 \
--yMin 0 0 0 \
--yMax 10 35 30 \
--refPointLabel TSS.center --regionsLabel "bivalent genes" --heatmapHeight 19 \
--colorMap Greens Oranges pink_r -o ../../plots/Heatmap_ReChIP_RPGCnorm_bivalent_Genes_rescale.pdf --plotTitle "ReChIP bivalent genes"
