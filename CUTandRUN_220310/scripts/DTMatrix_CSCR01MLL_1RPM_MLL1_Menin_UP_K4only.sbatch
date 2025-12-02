#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=40G
#SBATCH --time=0-08:00:00
#SBATCH --output=logs/DTMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix reference-point -S \
../ChIPseq_220303_NB501056_0768_AHMTHWBGXL/alignment/BW_RPGC_norm/MHC-CS22-K562-DMSO-MLL1_S1.RPGC.bw ../ChIPseq_220303_NB501056_0768_AHMTHWBGXL/alignment/BW_RPGC_norm/MHC-CS22-K562-VTP-MLL1_S2.RPGC.bw \
../ChIPseq_200320_NB501056_0470_AH5NJJBGXF/RPGCNormBW/Cas_S2.bw ../ChIPseq_200320_NB501056_0470_AH5NJJBGXF/RPGCNormBW/MENKO_S4.bw ../ChIPseq_200320_NB501056_0470_AH5NJJBGXF/RPGCNormBW/MENi_S3.bw \
-R reference_files/CSCR01_1RPM_MLL_UP_K4only.bed --referencePoint center -a 3000 -b 3000 -o All_Exp_DT_matrices/MENi_MLL_Exp_Cov_matrix_RPCGNorm_CSCR01_1RPM_MLL1_UP_K4only.gz


plotHeatmap -m All_Exp_DT_matrices/MENi_MLL_Exp_Cov_matrix_RPCGNorm_CSCR01_1RPM_MLL1_UP_K4only.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CS22-DMSO-MLL1 CS22-VTP-MLL1 \
200320-CAS-Menin 200320-KO-Menin 200320-MENi-Menin \
--colorMap Reds Reds Reds Reds Reds \
--refPointLabel peak.center --regionsLabel "GAIN" \
-o plots/Heatmap_MENi_MLL_Exp_RPGCnorm_CSCR01_1RPM_MLL1_UP_K4only.pdf --plotTitle "Cut&Run CSCR01 MLL1 >1RPM (either), difference >1RPM"
