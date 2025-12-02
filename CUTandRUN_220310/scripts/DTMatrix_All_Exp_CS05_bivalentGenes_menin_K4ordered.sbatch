#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4G
#SBATCH --time=0-01:00:00
#SBATCH --output=logs/DTMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_short

module load deeptools/3.5.0

computeMatrix scale-regions -S \
alignment/RPGCNormBW/MHC-CSCR01-K562-CAS-MLL1_S2.bw alignment/RPGCNormBW/MHC-CSCR01-K562-MEN1c4-KO-MLL1_S7.bw \
../ChIPseq_210623_NB501056_0652_AHTHVNBGXJ/RPGCNormBW/CS05-CAS-H3K4me3_S2.bw ../ChIPseq_210623_NB501056_0652_AHTHVNBGXJ/RPGCNormBW/CS05-MEN1c4-H3K4me3_S3.bw \
../CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/alignment/BW_RPGC_norm/MHC-CSCT03-K562-CAS-H3K27me3_S6.RPGC.bw ../CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/alignment/BW_RPGC_norm/MHC-CSCT03-K562-MEN1ko-H3K27me3_S7.RPGC.bw \
../ChIPseq_210422_NB501056_0625_AHGNFTBGXJ/RPGCNormBW/MHC-CS04-K562-3B-DUAL-SUZ12_S7.bw ../ChIPseq_210422_NB501056_0625_AHGNFTBGXJ/RPGCNormBW/MHC-CS04-K562-4B-DUAL-SUZ12_S8.bw \
-R reference_files/bivalent_menin.bed reference_files/bivalent_nonmenin.bed -a 3000 -b 3000 -m 5000 -o All_Exp_DT_matrices/All_Exp_CS05_Cov_matrix_RPCGNorm_bivalentGenes_menin_K4ordered.gz


plotHeatmap -m All_Exp_DT_matrices/All_Exp_CS05_Cov_matrix_RPCGNorm_bivalentGenes_menin_K4ordered.gz --sortUsing sum --sortUsingSamples 3 --boxAroundHeatmaps no --samplesLabel \
CAS-MLL1 KO-MLL1 CAS-H3K4me3 KO-H3K4me3 CAS-H3K27me3 KO-H3K27me3 CAS-SUZ12 KO-SUZ12 \
--regionsLabel "Menin genes" "non-Menin genes" --colorMap Reds Reds Oranges Oranges Greens Greens Blues Blues \
-o plots/Heatmap_All_CS05_Exp_RPGCnorm_bivalentGenes_menin_K4ordered.pdf --plotTitle "Bivalent genes, separated by menin binding, (CS05) K4 ordered"

#plotProfile -m All_Exp_DT_matrices/All_Exp_Cov_matrix_RPCGNorm_bivalentGenes_menin_K4ordered.gz --perGroup --samplesLabel \
#CAS-MLL1 KO-MLL1 CAS-H3K4me3 KO-H3K4me3 CAS-H3K27me3 KO-H3K27me3 CAS-SUZ12 KO-SUZ12 \
#--regionsLabel "Menin genes" "non-Menin genes"  \
#-o plots/Profile_All_Exp_RPGCnorm_CSCR01_bivalentGenes_menin_K4ordered.pdf --plotTitle "Bivalent genes, separated by menin binding, K4 ordered"
