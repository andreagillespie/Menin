#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=40G
#SBATCH --time=0-0:10:00
#SBATCH --output=logs/DTMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_short

module load deeptools/3.5.0

computeMatrix reference-point -S \
../CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/alignment/BW_RPGC_norm/MHC-CSCT03-K562-CAS-H3K4me3_S2.RPGC.bw ../CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/alignment/BW_RPGC_norm/MHC-CSCT03-K562-MEN1ko-H3K4me3_S3.RPGC.bw \
-R reference_files/CSCR01_1RPM_MLL_UP_K4only.bed --referencePoint center -a 3000 -b 3000 -o All_Exp_DT_matrices/K4_Exp_Cov_matrix_RPCGNorm_CSCR01_1RPM_MLL1_UP_K4only.gz


plotHeatmap -m All_Exp_DT_matrices/K4_Exp_Cov_matrix_RPCGNorm_CSCR01_1RPM_MLL1_UP_K4only.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CSCT03-CAS-H3K4me3 CSCT03-KO-H3K4me3 \
--refPointLabel peak.center --regionsLabel "GAIN" \
--colorMap Blues Blues \
-o plots/Heatmap_K4_Exp_RPGCnorm_CSCR01_1RPM_MLL1_UP_K4only.pdf --plotTitle "Cut&Run CSCR01 MLL1 >1RPM (either), difference >1RPM"
