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
MHC-CS22-K562-DMSO-MLL1_S1.RPGC.bw MHC-CS22-K562-VTP-MLL1_S2.RPGC.bw MHC-CS22-K562-EPZ-MLL1_S3.RPGC.bw MHC-CS22-K562-COMBO-MLL1_S4.RPGC.bw \
MHC-CS22-K562-CAS-MLL1_S5.RPGC.bw MHC-CS22-K562-MEN1-KO-MLL1_S6.RPGC.bw MHC-CS22-K562-EED-KO-MLL1_S7.RPGC.bw MHC-CS22-K562-EED-POS-MEN1ko-MLL1_S8.RPGC.bw \
-R /dawson_genomics/Projects/Menin/CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/sample_info/nonmenin_nonbivalent_DT.bed /dawson_genomics/Projects/Menin/CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/sample_info/nonmenin_bivalent_DT.bed \
/dawson_genomics/Projects/Menin/CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/sample_info/menin_nonbivalent_DT.bed /dawson_genomics/Projects/Menin/CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/sample_info/menin_bivalent_DT.bed \
-a 3000 -b 3000 -m 5000 -o ChIPmatrix_K562_MLL1_RPGCnorm_4cat_allGenes.gz

plotHeatmap -m ChIPmatrix_K562_MLL1_RPGCnorm_4cat_allGenes.gz --sortUsingSamples 1 --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
DMSO-MLL1 VTP-MLL1 EPZ-MLL1 COMBO-MLL1 CAS-MLL1 MEN1-KO-MLL1 EED-KO-MLL1 EED-POS-MEN1ko-MLL1 \
--regionsLabel "non-Menin non-bivalent" "non-Menin bivalent" "Menin non-bivalent" "Menin bivalent" \
-o ../../plots/Heatmap_K562_MLL1_RPGCnorm_4cat_allGenes.pdf --plotTitle "ChIP MLL1 All genes by category"

plotProfile -m ChIPmatrix_K562_MLL1_RPGCnorm_4cat_allGenes.gz --perGroup --samplesLabel \
DMSO-MLL1 VTP-MLL1 EPZ-MLL1 COMBO-MLL1 CAS-MLL1 MEN1-KO-MLL1 EED-KO-MLL1 EED-POS-MEN1ko-MLL1 \
--regionsLabel "non-Menin non-bivalent" "non-Menin bivalent" "Menin non-bivalent" "Menin bivalent" \
-o ../../plots/Profile_K562_MLL1_RPGCnorm_4cat_allGenes.pdf --plotTitle "ChIP MLL1 All genes by category"

plotProfile -m ChIPmatrix_K562_MLL1_RPGCnorm_4cat_allGenes.gz --perGroup --plotType heatmap --samplesLabel \
DMSO-MLL1 VTP-MLL1 EPZ-MLL1 COMBO-MLL1 CAS-MLL1 MEN1-KO-MLL1 EED-KO-MLL1 EED-POS-MEN1ko-MLL1 \
--regionsLabel "non-Menin non-bivalent" "non-Menin bivalent" "Menin non-bivalent" "Menin bivalent" \
-o ../../plots/Profile_Heatmap_K562_MLL1_RPGCnorm_4cat_allGenes.pdf --plotTitle "ChIP MLL1 All genes by category"


