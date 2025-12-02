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
../ChIPseq_200320_NB501056_0470_AH5NJJBGXF/RPGCNormBW/Cas_S2.bw ../ChIPseq_200320_NB501056_0470_AH5NJJBGXF/RPGCNormBW/MENKO_S4.bw ../ChIPseq_200320_NB501056_0470_AH5NJJBGXF/RPGCNormBW/MENi_S3.bw \
-R reference_files/CSCR01_1RPM_MLL_UP_K4only_TSS2k_K4_counts.bed reference_files/CSCR01_1RPM_MLL_DOWN_K4only_TSS2k_K4_counts.bed \
--referencePoint center -a 3000 -b 3000 -o All_Exp_DT_matrices/Menin_ChIP_Cov_matrix_RPCGNorm_CSCR01_1RPM_MLL1_UPDOWNonly.gz


plotHeatmap -m All_Exp_DT_matrices/Menin_ChIP_Cov_matrix_RPCGNorm_CSCR01_1RPM_MLL1_UPDOWNonly.gz --sortUsing sum --sortUsingSamples 1 --boxAroundHeatmaps no --samplesLabel \
CAS-Menin KO-Menin MENi-Menin \
--colorMap RdPu \
--refPointLabel peak.center --regionsLabel "MLL gain" "MLL loss" \
-o plots/Heatmap_Menin_ChIP_RPGCnorm_CSCR01_1RPM_MLL1_UPDOWNonly.pdf --plotTitle "Cut&Run CSCR01 MLL1 >1RPM (either), difference >1RPM"

plotProfile -m All_Exp_DT_matrices/Menin_ChIP_Cov_matrix_RPCGNorm_CSCR01_1RPM_MLL1_UPDOWNonly.gz --perGroup --samplesLabel \
Control-Menin MEN1KO-Menin MENi-Menin \
--regionsLabel "MLL gain" "MLL loss" --plotHeight 8 --plotWidth 8 \
-o plots/Profile_Menin_ChIP_RPGCnorm_CSCR01_1RPM_MLL1_UPDOWNonly.pdf --plotTitle "Cut&Run CSCR01 MLL1 >1RPM (either), difference >1RPM"

#plotProfile -m All_Exp_DT_matrices/Menin_ChIP_Cov_matrix_RPCGNorm_CSCR01_1RPM_MLL1_updown_K4only.gz --perGroup --plotType heatmap --samplesLabel \
#CAS-Menin KO-Menin MENi-Menin \
#--regionsLabel "MLL gain" "MLL loss" \
#-o plots/Profile_Heatmap_CSCR04_MLL1_RPGCnorm_CSCR01_1RPM_MLL1_UPDOWN_K4only.pdf --plotTitle "Cut&Run CSCR01 MLL1 >1RPM (either), difference >1RPM"
