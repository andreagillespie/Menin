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
MHC-CSCR04-K562-CAS-RING1B_S16.bw MHC-CSCR04-K562-MEN1c4-RING1B_S17.bw MHC-CSCR04-K562-EEDko-RING1B_S18.bw MHC-CSCR04-K562-EEDkoANDMEN1ko-RING1B_S19.bw \
-R /dawson_genomics/Projects/Menin/CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/sample_info/nonmenin_nonbivalent_DT.bed /dawson_genomics/Projects/Menin/CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/sample_info/nonmenin_bivalent_DT.bed \
/dawson_genomics/Projects/Menin/CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/sample_info/menin_nonbivalent_DT.bed /dawson_genomics/Projects/Menin/CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/sample_info/menin_bivalent_DT.bed \
-a 3000 -b 3000 -m 5000 -o CSCR04_RING1B_Cov_matrix_RPCGNorm_4cat_allGenes.gz

plotProfile -m CSCR04_RING1B_Cov_matrix_RPCGNorm_4cat_allGenes.gz --perGroup --samplesLabel \
CAS-RING1B MEN1c4-RING1B EEDko-RING1B EEDkoANDMEN1ko-RING1B \
--regionsLabel "non-Menin non-bivalent" "non-Menin bivalent" "Menin non-bivalent" "Menin bivalent" \
-o ../../plots/Profile_CSCR04_RING1B_RPGCnorm_4cat_allGenes.pdf --plotTitle "Cut&Run CSCR04 RING1B All genes by category"

plotHeatmap -m CSCR04_RING1B_Cov_matrix_RPCGNorm_4cat_allGenes.gz --sortUsingSamples 1 --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CAS-RING1B MEN1c4-RING1B EEDko-RING1B EEDkoANDMEN1ko-RING1B \
--regionsLabel "non-Menin non-bivalent" "non-Menin bivalent" "Menin non-bivalent" "Menin bivalent" \
-o ../../plots/Heatmap_CSCR04_RING1B_RPGCnorm_4cat_allGenes.pdf --plotTitle "Cut&Run CSCR04 RING1B All genes by category"

plotProfile -m CSCR04_RING1B_Cov_matrix_RPCGNorm_4cat_allGenes.gz --perGroup --plotType heatmap --samplesLabel \
CAS-RING1B MEN1c4-RING1B EEDko-RING1B EEDkoANDMEN1ko-RING1B \
--regionsLabel "non-Menin non-bivalent" "non-Menin bivalent" "Menin non-bivalent" "Menin bivalent" \
-o ../../plots/Profile_Heatmap_CSCR04_RING1B_RPGCnorm_4cat_allGenes.pdf --plotTitle "Cut&Run CSCR04 RING1B All genes by category"
