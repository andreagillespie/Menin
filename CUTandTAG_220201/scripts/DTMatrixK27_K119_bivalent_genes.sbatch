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
#MHC-CSCT03-K562-CAS-H3K27me3_S6.spikein.bw MHC-CSCT03-K562-PCGF1ko-H3K27me3_S9.spikein.bw MHC-CSCT03-K562-MEN1ko-H3K27me3_S7.spikein.bw \
#MHC-CSCT03-K562-CAS-H2AK119_S10.spikein.bw MHC-CSCT03-K562-EEDko-H2AK119_S12.spikein.bw MHC-CSCT03-K562-PCGF1ko-H2AK119_S13.spikein.bw \
#-R ../../../CUTandTAG_220328_NB501056_0777_AHNGTWBGXL/reference_files/CSCT03_CAS_bivalent_genes_2kTSS.bed -a 3000 -b 3000 -m 5000 \
#-o CnTmatrix_K27_K119_spikeinnorm_bivalentGenes.gz

#plotProfile -m CnTmatrix_K27_RPGCnorm_bivalentGenes.gz --perGroup --samplesLabel \
#CAS-H3K27me3 PCGF1ko-H3K27me3 \
#--colors "#75217f" "#00a78d" --regionsLabel "bivalent genes" \
#-o ../../plots/Profile_K27_RPGCnorm_bivalentGenes.pdf --plotTitle "Cut&Tag H3K27me3 bivalent genes"

plotHeatmap -m CnTmatrix_K27_K119_spikeinnorm_bivalentGenes.gz --sortUsingSamples 1 --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CAS-H3K27me3 PCGF1ko-H3K27me3 EEDko-H3K27me3 CAS-H2AK119 EEDko-H2AK119 PCGF1ko-H2AK119 \
--colorMap Greens Greens Greens Purples Purples Purples --regionsLabel "bivalent genes" --legendLocation none \
--zMin 0 0 0 0 0 0 \
--zMax 700 700 700 500 500 500 \
--yMin 0 0 0 0 0 0 \
--yMax 200 200 200 175 175 175 \
-o ../../plots/Heatmap_K27_K119_spikeinnorm_bivalentGenes.pdf --plotTitle "Cut&Tag H3K27me3 & H2AK119 bivalent genes"

