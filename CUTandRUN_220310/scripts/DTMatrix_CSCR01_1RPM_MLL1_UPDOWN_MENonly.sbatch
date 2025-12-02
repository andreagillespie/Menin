#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=40G
#SBATCH --time=0-04:00:00
#SBATCH --output=logs/DTMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix reference-point -S \
../ChIPseq_200320_NB501056_0470_AH5NJJBGXF/RPGCNormBW/Cas_S2.bw \
-R reference_files/CSCR01_1RPM_MLL_UP_K4only_TSS2k_K4_counts.bed reference_files/CSCR01_1RPM_MLL_DOWN_K4only_TSS2k_K4_counts.bed \
--referencePoint center -a 3000 -b 3000 -o All_Exp_DT_matrices/Menin_ChIP_CASonly_Cov_matrix_RPCGNorm_CSCR01_1RPM_MLL1_UPDOWN.gz

plotProfile -m All_Exp_DT_matrices/Menin_ChIP_CASonly_Cov_matrix_RPCGNorm_CSCR01_1RPM_MLL1_UPDOWN.gz \
--samplesLabel CAS-Menin --regionsLabel "MLL gain" "MLL loss" --plotHeight 8 --plotWidth 8 \
-o plots/Profile_Menin_ChIP_CASonly_RPGCnorm_CSCR01_1RPM_MLL1_UPDOWN.pdf --plotTitle "MLL1 peaks difference >1RPM"
