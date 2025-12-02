#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=1-0:00:00
#SBATCH --output=../../logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTmatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix scale-regions -S \
MHC-CSCT03-K562-CAS-H2AK119_S10.RPGC.bw MHC-CSCT03-K562-EEDko-H2AK119_S12.RPGC.bw \
MHC-CSCT03-K562-MEN1ko-H2AK119_S11.RPGC.bw MHC-CSCT03-K562-PCGF1ko-H2AK119_S13.RPGC.bw \
-R ../../sample_info/nonmenin_nonbivalent_DT.bed ../../sample_info/nonmenin_bivalent_DT.bed \
../../sample_info/menin_nonbivalent_DT.bed ../../sample_info/menin_bivalent_DT.bed \
-a 3000 -b 3000 -m 5000 -o CnTmatrix_K119_RPGCnorm_4cat_allGenes.gz

plotHeatmap -m CnTmatrix_K119_RPGCnorm_4cat_allGenes.gz --sortUsingSamples 1 --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CAS-H2AK119 EEDko-H2AK119 MEN1ko-H2AK119 PCGF1ko-H2AK119 \
--regionsLabel "non-Menin non-bivalent" "non-Menin bivalent" "Menin non-bivalent" "Menin bivalent" \
-o ../../plots/Heatmap_K119_RPGCnorm_4cat_allGenes.pdf --plotTitle "Cut&Tag H2AK119 All genes by category"

plotProfile -m CnTmatrix_K119_RPGCnorm_4cat_allGenes.gz --perGroup --samplesLabel \
CAS-H2AK119 EEDko-H2AK119 MEN1ko-H2AK119 PCGF1ko-H2AK119 \
--regionsLabel "non-Menin non-bivalent" "non-Menin bivalent" "Menin non-bivalent" "Menin bivalent" \
-o ../../plots/Profile_K119_RPGCnorm_4cat_allGenes.pdf --plotTitle "Cut&Tag H2AK119 All genes by category"

plotProfile -m CnTmatrix_K119_RPGCnorm_4cat_allGenes.gz --perGroup --plotType heatmap --samplesLabel \
CAS-H2AK119 EEDko-H2AK119 MEN1ko-H2AK119 PCGF1ko-H2AK119 \
--regionsLabel "non-Menin non-bivalent" "non-Menin bivalent" "Menin non-bivalent" "Menin bivalent" \
-o ../../plots/Profile_Heatmap_K119_RPGCnorm_4cat_allGenes.pdf --plotTitle "Cut&Tag H2AK119 All genes by category"


