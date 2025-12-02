#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=40G
#SBATCH --time=1-0:00:00
#SBATCH --output=logs/DTMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix reference-point -S \
../CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/alignment/BW_RPGC_norm/MHC-CSCT03-K562-CAS-H2AK119_S10.RPGC.bw ../CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/alignment/BW_RPGC_norm/MHC-CSCT03-K562-MEN1ko-H2AK119_S11.RPGC.bw \
-R reference_files/CSCR01_1RPM_MLL_DOWN.bed reference_files/CSCR01_1RPM_MLL_UP.bed --referencePoint center -a 3000 -b 3000 -o All_Exp_DT_matrices/K119_Exp_Cov_matrix_RPCGNorm_CSCR01_1RPM_MLL1.gz


plotHeatmap -m All_Exp_DT_matrices/K119_Exp_Cov_matrix_RPCGNorm_CSCR01_1RPM_MLL1.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CSCT03-CAS-H2AK119 CSCT03-MEN1ko-H2AK119 \
--colorMap Purples --refPointLabel peak.center --regionsLabel "DOWN" "UP" \
-o plots/Heatmap_K119_Exp_RPGCnorm_CSCR01_1RPM_MLL1.pdf --plotTitle "Cut&Run CSCR01 MLL1 >1RPM (either), difference >1RPM"
