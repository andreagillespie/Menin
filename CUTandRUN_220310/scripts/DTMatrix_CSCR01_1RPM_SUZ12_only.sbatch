#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=40G
#SBATCH --time=0-4:00:00
#SBATCH --output=logs/DTMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix reference-point -S \
alignment/RPGCNormBW/MHC-CSCR01-K562-CAS-SUZ12_S3.bw alignment/RPGCNormBW/MHC-CSCR01-K562-MEN1c4-KO-SUZ12_S8.bw \
../ChIPseq_210422_NB501056_0625_AHGNFTBGXJ/RPGCNormBW/MHC-CS04-K562-3B-DUAL-SUZ12_S7.bw ../ChIPseq_210422_NB501056_0625_AHGNFTBGXJ/RPGCNormBW/MHC-CS04-K562-4B-DUAL-SUZ12_S8.bw \
-R reference_files/CSCR01_1RPM_MLL_DOWN.bed reference_files/CSCR01_1RPM_MLL_UP.bed --referencePoint center -a 3000 -b 3000 -o All_Exp_DT_matrices/SUZ12_Exp_Cov_matrix_RPCGNorm_CSCR01_1RPM_MLL1.gz

# reran w/typo in file name
plotHeatmap -m All_Exp_DT_matrices/SUZ12_Exp_Cov_matrix_RPCGNorm_CSCR01_1RPM_MLL1.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CSCR01-CAS-SUZ12 CSCR01-MEN1c4-KO-SUZ12 \
CS04-CAS-SUZ12 CS04-KO-SUZ12 \
--colorMap Greens --refPointLabel peak.center --regionsLabel "DOWN" "UP" \
-o plots/Heatmap_SUZ12_Exp_RPGCnorm_CSCR01_1RPM_MLL1.pdf --plotTitle "Cut&Run CSCR01 MLL1 >1RPM (either), difference >1RPM"
