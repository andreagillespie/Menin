#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=40G
#SBATCH --time=3-0:00:00
#SBATCH --output=logs/DTMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod

module load deeptools/3.5.0

computeMatrix reference-point -S \
../CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/alignment/BW_RPGC_norm/MHC-CSCT03-K562-CAS-H3K4me3_S2.RPGC.bw ../CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/alignment/BW_RPGC_norm/MHC-CSCT03-K562-MEN1ko-H3K4me3_S3.RPGC.bw \
../ChIPseq_210623_NB501056_0652_AHTHVNBGXJ/RPGCNormBW/CS05-CAS-H3K4me3_S2.bw ../ChIPseq_210623_NB501056_0652_AHTHVNBGXJ/RPGCNormBW/CS05-MEN1c4-H3K4me3_S3.bw \
-R reference_files/merged_1RPM_MLL_DOWN.bed reference_files/merged_1RPM_MLL_UP.bed --referencePoint center -a 3000 -b 3000 -o All_Exp_DT_matrices/K4_Exp_Cov_matrix_RPCGNorm_merged_1RPM_MLL1.gz


plotHeatmap -m All_Exp_DT_matrices/K4_Exp_Cov_matrix_RPCGNorm_merged_1RPM_MLL1.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CSCT03-CAS-H3K4me3 CSCT03-MEN1ko-H3K4me3 \
CS05-CAS-H3K4me3 CS05-MEN1c4-H3K4me3 \
--colorMap Blues --refPointLabel peak.center --regionsLabel "DOWN" "UP" \
-o plots/Heatmap_K4_Exp_RPGCnorm_merged_1RPM_MLL1_FC.pdf --plotTitle "Cut&Run CSCR01+CSCR04 MLL1 >1RPM, difference >1RPM"
