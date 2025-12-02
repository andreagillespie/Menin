#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=1-0:00:00
#SBATCH --output=../../logs/DTMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix scale-regions -S \
MHC-I-CSCR03-K562-Cas9-H3K27me3_S59.bw MHC-I-CSCR03-K562-EEDko-H3K27me3_S60.bw \
-R /dawson_genomics/Projects/Menin/CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/sample_info/nonmenin_nonbivalent_DT.bed /dawson_genomics/Projects/Menin/CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/sample_info/nonmenin_bivalent_DT.bed \
/dawson_genomics/Projects/Menin/CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/sample_info/menin_nonbivalent_DT.bed /dawson_genomics/Projects/Menin/CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/sample_info/menin_bivalent_DT.bed \
-a 3000 -b 3000 -m 5000 -o CSCR03_K27_Cov_matrix_RPCGNorm_4cat_allGenes.gz

plotProfile -m CSCR03_K27_Cov_matrix_RPCGNorm_4cat_allGenes.gz --perGroup --samplesLabel \
K562-Cas9-H3K27me3 K562-EEDko-H3K27me3 \
--regionsLabel "non-Menin non-bivalent" "non-Menin bivalent" "Menin non-bivalent" "Menin bivalent" \
-o ../../plots/Profile_CSCR03_K27_RPGCnorm_4cat_allGenes.pdf --plotTitle "Cut&Run CSCR03 H3K27me3 All genes by category"

plotHeatmap -m CSCR03_K27_Cov_matrix_RPCGNorm_4cat_allGenes.gz --sortUsingSamples 1 --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
K562-Cas9-H3K27me3 K562-EEDko-H3K27me3 \
--regionsLabel "non-Menin non-bivalent" "non-Menin bivalent" "Menin non-bivalent" "Menin bivalent" \
-o ../../plots/Heatmap_CSCR03_K27_RPGCnorm_4cat_allGenes.pdf --plotTitle "Cut&Run CSCR03 H3K27me3 All genes by category"

plotProfile -m CSCR03_K27_Cov_matrix_RPCGNorm_4cat_allGenes.gz --perGroup --plotType heatmap --samplesLabel \
K562-Cas9-H3K27me3 K562-EEDko-H3K27me3 \
--regionsLabel "non-Menin non-bivalent" "non-Menin bivalent" "Menin non-bivalent" "Menin bivalent" \
-o ../../plots/Profile_Heatmap_CSCR03_K27_RPGCnorm_4cat_allGenes.pdf --plotTitle "Cut&Run CSCR03 H3K27me3 All genes by category"
