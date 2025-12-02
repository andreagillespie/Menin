#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem-per-cpu=4G
#SBATCH --time=1-0:00:00
#SBATCH --output=../../logs/RawBWMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="rawBWmatrix"
#SBATCH --partition=prod_med

module load deeptools/3.0.0

computeMatrix scale-regions -S \
MHC-CSCT03-K562-CAS-H2AK119_S10.bw MHC-CSCT03-K562-EEDko-H2AK119_S12.bw MHC-CSCT03-K562-MEN1ko-H2AK119_S11.bw MHC-CSCT03-K562-PCGF1ko-H2AK119_S13.bw \
MHC-CSCT03-K562-CAS-H3K27me3_S6.bw MHC-CSCT03-K562-EEDko-H3K27me3_S8.bw MHC-CSCT03-K562-MEN1ko-H3K27me3_S7.bw MHC-CSCT03-K562-PCGF1ko-H3K27me3_S9.bw \
MHC-CSCT03-K562-CAS-H3K4me3_S2.bw MHC-CSCT03-K562-EEDko-H3K4me3_S4.bw MHC-CSCT03-K562-MEN1ko-H3K4me3_S3.bw MHC-CSCT03-K562-PCGF1ko-H3K4me3_S5.bw \
-R /data/reference/dawson_labs/bed_files/Hg19/Hg19EnsGeneDT.bed -a 3000 -b 3000 -m 5000 --skipZeros -o CnTmatrix_CUTandTAG_Raw_All_Genes.gz -p 8

computeMatrix scale-regions -S \
MHC-CSCT03-K562-CAS-H2AK119_S10.bw MHC-CSCT03-K562-EEDko-H2AK119_S12.bw MHC-CSCT03-K562-MEN1ko-H2AK119_S11.bw MHC-CSCT03-K562-PCGF1ko-H2AK119_S13.bw \
MHC-CSCT03-K562-CAS-H3K27me3_S6.bw MHC-CSCT03-K562-EEDko-H3K27me3_S8.bw MHC-CSCT03-K562-MEN1ko-H3K27me3_S7.bw MHC-CSCT03-K562-PCGF1ko-H3K27me3_S9.bw \
MHC-CSCT03-K562-CAS-H3K4me3_S2.bw MHC-CSCT03-K562-EEDko-H3K4me3_S4.bw MHC-CSCT03-K562-MEN1ko-H3K4me3_S3.bw MHC-CSCT03-K562-PCGF1ko-H3K4me3_S5.bw \
-R /dawson_genomics/Projects/Menin/ChIPseq_200320_NB501056_0470_AH5NJJBGXF/scripts/MeninGenes.bed -a 3000 -b 3000 -m 5000 --skipZeros \
-o CnTmatrix_CUTandTAG_Raw_Menin_Genes.gz -p 8

plotHeatmap -m CnTmatrix_CUTandTAG_Raw_All_Genes.gz --sortUsing sum --samplesLabel \
CAS-H2AK119 EEDko-H2AK119 MEN1ko-H2AK119 PCGF1ko-H2AK119 \
CAS-H3K27me3 EEDko-H3K27me3 MEN1ko-H3K27me3 PCGF1ko-H3K27me3 \
CAS-H3K4me3 EEDko-H3K4me3 MEN1ko-H3K4me3 PCGF1ko-H3K4me3 -o ../../plots/Heatmap_CnT_Raw_All_Genes.pdf --plotTitle "Cut&Tag Raw All genes"

plotHeatmap -m CnTmatrix_CUTandTAG_Raw_Menin_Genes.gz --sortUsing sum --samplesLabel \
CAS-H2AK119 EEDko-H2AK119 MEN1ko-H2AK119 PCGF1ko-H2AK119 \
CAS-H3K27me3 EEDko-H3K27me3 MEN1ko-H3K27me3 PCGF1ko-H3K27me3 \
CAS-H3K4me3 EEDko-H3K4me3 MEN1ko-H3K4me3 PCGF1ko-H3K4me3 -o ../../plots/Heatmap_CnT_Raw_Menin_Genes.pdf --plotTitle "Cut&Tag Raw Menin genes"