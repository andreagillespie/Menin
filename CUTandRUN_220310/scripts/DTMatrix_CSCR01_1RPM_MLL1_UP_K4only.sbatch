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

#computeMatrix reference-point -S \
#alignment/RPGCNormBW/MHC-CSCR01-K562-CAS-MLL1_S2.bw alignment/RPGCNormBW/MHC-CSCR01-K562-MEN1c4-KO-MLL1_S7.bw \
#../CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/alignment/BW_RPGC_norm/MHC-CSCT03-K562-CAS-H3K4me3_S2.RPGC.bw ../CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/alignment/BW_RPGC_norm/MHC-CSCT03-K562-MEN1ko-H3K4me3_S3.RPGC.bw \
#../CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/alignment/BW_RPGC_norm/MHC-CSCT03-K562-CAS-H3K27me3_S6.RPGC.bw ../CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/alignment/BW_RPGC_norm/MHC-CSCT03-K562-MEN1ko-H3K27me3_S7.RPGC.bw \
#../ChIPseq_210422_NB501056_0625_AHGNFTBGXJ/RPGCNormBW/MHC-CS04-K562-3B-DUAL-SUZ12_S7.bw ../ChIPseq_210422_NB501056_0625_AHGNFTBGXJ/RPGCNormBW/MHC-CS04-K562-4B-DUAL-SUZ12_S8.bw \
#-R reference_files/CSCR01_1RPM_MLL_UP_K4only.bed --referencePoint center -a 3000 -b 3000 -o All_Exp_DT_matrices/All_Exp_Cov_matrix_RPCGNorm_CSCR01_1RPM_MLL1_UP_K4only.gz


plotHeatmap -m All_Exp_DT_matrices/All_Exp_Cov_matrix_RPCGNorm_CSCR01_1RPM_MLL1_UP_K4only.gz --sortUsing sum --sortUsingSamples 4 --boxAroundHeatmaps no --samplesLabel \
CAS-MLL1 KO-MLL1 \
CAS-H3K4me3 KO-H3K4me3 \
CAS-H3K27me3 KO-H3K27me3 \
CAS-SUZ12 KO-SUZ12 \
--refPointLabel peak.center --regionsLabel "GAIN" \
--zMin 0 0 0 0 0 0 0 0 \
--zMax 23 23 130 130 3.8 3.8 15 15 \
--yMin 0 0 0 0 0 0 0 0 \
--yMax 17 17 60 60 20 20 10 10 \
--colorMap Reds Reds Blues Blues Oranges Oranges Greens Greens \
--heatmapHeight 8 --heatmapWidth 5 \
-o plots/Heatmap_All_Exp_RPGCnorm_CSCR01_1RPM_MLL1_UP_K4only.pdf --plotTitle "Cut&Run CSCR01 MLL1 >1RPM (either), difference >1RPM"
