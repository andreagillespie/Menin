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
alignment/RPGCNormBW/MHC-CSCR04-K562-CAS-MLL1_S12.bw alignment/RPGCNormBW/MHC-CSCR04-K562-MEN1c4-MLL1_S13.bw \
alignment/RPGCNormBW/MHC-CSCR01-K562-CAS-MLL1_S2.bw alignment/RPGCNormBW/MHC-CSCR01-K562-MEN1c4-KO-MLL1_S7.bw \
../ChIPseq_220303_NB501056_0768_AHMTHWBGXL/alignment/BW_RPGC_norm/MHC-CS22-K562-DMSO-MLL1_S1.RPGC.bw ../ChIPseq_220303_NB501056_0768_AHMTHWBGXL/alignment/BW_RPGC_norm/MHC-CS22-K562-VTP-MLL1_S2.RPGC.bw \
../ChIPseq_220303_NB501056_0768_AHMTHWBGXL/alignment/BW_RPGC_norm/MHC-CS22-K562-CAS-MLL1_S5.RPGC.bw ../ChIPseq_220303_NB501056_0768_AHMTHWBGXL/alignment/BW_RPGC_norm/MHC-CS22-K562-MEN1-KO-MLL1_S6.RPGC.bw \
../ChIPseq_200320_NB501056_0470_AH5NJJBGXF/RPGCNormBW/Cas_S2.bw ../ChIPseq_200320_NB501056_0470_AH5NJJBGXF/RPGCNormBW/MENKO_S4.bw ../ChIPseq_200320_NB501056_0470_AH5NJJBGXF/RPGCNormBW/MENi_S3.bw \
-R reference_files/1RPM_MLL_DOWN.bed reference_files/1RPM_MLL_UP.bed --referencePoint center -a 3000 -b 3000 -o All_Exp_DT_matrices/MLL_Exp_Cov_matrix_RPCGNorm_1RPM_MLL1.gz


plotHeatmap -m All_Exp_DT_matrices/MLL_Exp_Cov_matrix_RPCGNorm_1RPM_MLL1.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CSCR04-CAS-MLL1 CSCR04-MEN1c4-MLL1 \
CSCR01-CAS-MLL1 CSCR01-MEN1c4-KO-MLL1 \
CS22-DMSO-MLL1 CS22-VTP-MLL1 \
CS22-CAS-MLL1 CS22-MEN1-KO-MLL1 \
200320-CAS 200320-MENKO 200320-MENi \
--colorMap Reds --refPointLabel peak.center --regionsLabel "DOWN" "UP" \
-o plots/Heatmap_MLL_Exp_RPGCnorm_1RPM_MLL1_FC.pdf --plotTitle "Cut&Run CSCR04 MLL1 >1RPM"
