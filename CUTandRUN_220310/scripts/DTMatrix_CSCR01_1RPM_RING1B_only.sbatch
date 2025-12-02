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
alignment/RPGCNormBW/MHC-CSCR04-K562-CAS-RING1B_S16.bw alignment/RPGCNormBW/MHC-CSCR04-K562-MEN1c4-RING1B_S17.bw \
-R reference_files/CSCR01_1RPM_MLL_DOWN.bed reference_files/CSCR01_1RPM_MLL_UP.bed --referencePoint center -a 3000 -b 3000 -o All_Exp_DT_matrices/RING1B_Exp_Cov_matrix_RPCGNorm_CSCR01_1RPM_MLL1.gz


plotHeatmap -m All_Exp_DT_matrices/RING1B_Exp_Cov_matrix_RPCGNorm_CSCR01_1RPM_MLL1.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CSCR04-CAS-RING1B CSCR04-MEN1c4-RING1B \
--colorMap Greys --refPointLabel peak.center --regionsLabel "DOWN" "UP" \
-o plots/Heatmap_RING1B_Exp_RPGCnorm_CSCR01_1RPM_MLL1.pdf --plotTitle "Cut&Run CSCR01+CSCR04 MLL1 >1RPM (either), difference >1RPM"
