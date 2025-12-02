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

#computeMatrix scale-regions -S \
#MHC-CSCT05-K562-NT2-H3K27me3_S5.RPGC.bw MHC-CSCT05-K562-AEBP2sgRNA-H3K27me3_S6.RPGC.bw MHC-CSCT05-K562-MTF2sgRNA-H3K27me3_S7.RPGC.bw \
#-R ../../reference_files/CSCT03_CAS_bivalent_genes_2kTSS.bed -a 3000 -b 3000 -m 5000 -o CnTmatrix_K27_RPGCnorm_bivalentGenes.gz

#plotProfile -m CnTmatrix_K27_RPGCnorm_bivalentGenes.gz --perGroup --samplesLabel \
#NT2-H3K27me3 AEBP2sgRNA-H3K27me3 MTF2sgRNA-H3K27me3 \
#--colors "#75217f" "#5f8707" "#f0e060" --regionsLabel "bivalent genes" \
#-o ../../plots/Profile_K27_RPGCnorm_bivalentGenes.pdf --plotTitle "Cut&Tag H3K27me3 bivalent genes"

plotHeatmap -m CnTmatrix_K27_RPGCnorm_bivalentGenes.gz --sortUsingSamples 1 --sortUsing sum --samplesLabel \
NT2-H3K27me3 AEBP2sgRNA-H3K27me3 MTF2sgRNA-H3K27me3 \
--colorMap Greens --regionsLabel "bivalent genes" \
--heatmapHeight 11 --heatmapWidth 4 \
-o ../../plots/Heatmap_K27_RPGCnorm_bivalentGenes.pdf --plotTitle "Cut&Tag H3K27me3 bivalent genes"

#plotProfile -m CnTmatrix_K27_RPGCnorm_bivalentGenes.gz --perGroup --plotType heatmap --samplesLabel \
#NT2-H3K27me3 AEBP2sgRNA-H3K27me3 MTF2sgRNA-H3K27me3 \
#--regionsLabel "bivalent genes" \
#-o ../../plots/Profile_Heatmap_K27_RPGCnorm_bivalentGenes.pdf --plotTitle "Cut&Tag H3K27me3 bivalent genes"

