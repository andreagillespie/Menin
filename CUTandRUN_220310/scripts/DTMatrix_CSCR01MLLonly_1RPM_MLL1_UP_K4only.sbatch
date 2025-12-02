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
alignment/RPGCNormBW/MHC-CSCR01-K562-CAS-MLL1_S2.bw alignment/RPGCNormBW/MHC-CSCR01-K562-MEN1c4-KO-MLL1_S7.bw \
-R reference_files/CSCR01_1RPM_MLL_UP_K4only.bed --referencePoint center -a 3000 -b 3000 -o All_Exp_DT_matrices/MLL_Exp_Cov_matrix_RPCGNorm_CSCR01_1RPM_MLL1_UP_K4only.gz


plotHeatmap -m All_Exp_DT_matrices/MLL_Exp_Cov_matrix_RPCGNorm_CSCR01_1RPM_MLL1_UP_K4only.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CSCR01-CAS-MLL1 CSCR01-KO-MLL1 \
--refPointLabel peak.center --regionsLabel "GAIN" \
--colorMap Reds Reds \
-o plots/Heatmap_MLL_Exp_RPGCnorm_CSCR01_1RPM_MLL1_UP_K4only.pdf --plotTitle "Cut&Run CSCR01 MLL1 >1RPM (either), difference >1RPM"
