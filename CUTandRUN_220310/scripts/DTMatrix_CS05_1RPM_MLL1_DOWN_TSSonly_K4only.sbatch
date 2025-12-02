#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4G
#SBATCH --time=0-08:0:00
#SBATCH --output=logs/DTMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix reference-point -S \
alignment/RPGCNormBW/MHC-CSCR01-K562-CAS-MLL1_S2.bw alignment/RPGCNormBW/MHC-CSCR01-K562-MEN1c4-KO-MLL1_S7.bw \
../ChIPseq_200320_NB501056_0470_AH5NJJBGXF/RPGCNormBW/Cas_S2.bw ../ChIPseq_200320_NB501056_0470_AH5NJJBGXF/RPGCNormBW/MENKO_S4.bw \
../ChIPseq_210623_NB501056_0652_AHTHVNBGXJ/RPGCNormBW/CS05-CAS-H3K4me3_S2.bw ../ChIPseq_210623_NB501056_0652_AHTHVNBGXJ/RPGCNormBW/CS05-MEN1c4-H3K4me3_S3.bw \
../CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/alignment/BW_RPGC_norm/MHC-CSCT03-K562-CAS-H3K27me3_S6.RPGC.bw ../CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/alignment/BW_RPGC_norm/MHC-CSCT03-K562-MEN1ko-H3K27me3_S7.RPGC.bw \
../ChIPseq_210422_NB501056_0625_AHGNFTBGXJ/RPGCNormBW/MHC-CS04-K562-3B-DUAL-SUZ12_S7.bw ../ChIPseq_210422_NB501056_0625_AHGNFTBGXJ/RPGCNormBW/MHC-CS04-K562-4B-DUAL-SUZ12_S8.bw \
-R reference_files/CSCR01_1RPM_MLL_DOWN_K4only_TSS2k_K4_counts.bed --referencePoint center -a 3000 -b 3000 -o All_Exp_DT_matrices/All_Exp_CS05_Cov_matrix_RPCGNorm_1RPM_MLL1_DOWN_TSSonly_K4only.gz


plotHeatmap -m All_Exp_DT_matrices/All_Exp_CS05_Cov_matrix_RPCGNorm_1RPM_MLL1_DOWN_TSSonly_K4only.gz --sortUsing sum --sortUsingSamples 6 --boxAroundHeatmaps no --samplesLabel \
CAS-MLL KO-MLL1 CAS-Menin KO-Menin CAS-H3K4me3 KO-H3K4me3 CAS-H3K27me3 KO-H3K27me3 CAS-SUZ12 KO-SUZ12 \
--refPointLabel peak.center --regionsLabel "LOSS" \
--colorMap Reds Reds RdPu RdPu Oranges Oranges Greens Greens Blues Blues \
--zMin 0 0 0 0 0 0 0 0 0 0 \
--zMax 60 60 30 30 75 75 5 5 10 10 \
--yMin 0 0 0 0 0 0 0 0 0 0 \
--yMax 50 50 25 25 75 75 2 2 5 5 \
-o plots/Heatmap_All_Exp_CS05_RPGCnorm_1RPM_MLL1_DOWN_TSSonly_K4only.pdf --plotTitle "Cut&Run MLL1 >1RPM (either), difference >1RPM"
