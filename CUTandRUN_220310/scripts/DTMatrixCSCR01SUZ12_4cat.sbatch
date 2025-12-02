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
MHC-CSCR01-K562-CAS-SUZ12_S3.bw MHC-CSCR01-K562-MEN1c4-KO-SUZ12_S8.bw \
-R /dawson_genomics/Projects/Menin/CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/sample_info/nonmenin_nonbivalent_DT.bed /dawson_genomics/Projects/Menin/CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/sample_info/nonmenin_bivalent_DT.bed \
/dawson_genomics/Projects/Menin/CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/sample_info/menin_nonbivalent_DT.bed /dawson_genomics/Projects/Menin/CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/sample_info/menin_bivalent_DT.bed \
-a 3000 -b 3000 -m 5000 -o CSCR01_SUZ12_Cov_matrix_RPCGNorm_4cat_allGenes.gz

#CSCR01
plotProfile -m CSCR01_SUZ12_Cov_matrix_RPCGNorm_4cat_allGenes.gz --perGroup --samplesLabel \
CAS-SUZ12 MEN1c4-KO-SUZ12 \
--regionsLabel "non-Menin non-bivalent" "non-Menin bivalent" "Menin non-bivalent" "Menin bivalent" \
-o ../../plots/Profile_CSCR01_SUZ12_RPGCnorm_4cat_allGenes.pdf --plotTitle "Cut&Run CSCR01 SUZ12 All genes by category"

plotHeatmap -m CSCR01_SUZ12_Cov_matrix_RPCGNorm_4cat_allGenes.gz --sortUsingSamples 1 --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CAS-SUZ12 MEN1c4-KO-SUZ12 \
--regionsLabel "non-Menin non-bivalent" "non-Menin bivalent" "Menin non-bivalent" "Menin bivalent" \
-o ../../plots/Heatmap_CSCR01_SUZ12_RPGCnorm_4cat_allGenes.pdf --plotTitle "Cut&Run CSCR01 SUZ12 All genes by category"

plotProfile -m CSCR01_SUZ12_Cov_matrix_RPCGNorm_4cat_allGenes.gz --perGroup --plotType heatmap --samplesLabel \
CAS-SUZ12 MEN1c4-KO-SUZ12 \
--regionsLabel "non-Menin non-bivalent" "non-Menin bivalent" "Menin non-bivalent" "Menin bivalent" \
-o ../../plots/Profile_Heatmap_CSCR01_SUZ12_RPGCnorm_4cat_allGenes.pdf --plotTitle "Cut&Run CSCR01 SUZ12 All genes by category"