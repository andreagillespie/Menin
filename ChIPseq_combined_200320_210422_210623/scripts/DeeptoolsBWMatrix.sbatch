#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=40G
#SBATCH --time=1-0:00:00
#SBATCH --output=ChIPseq_combined_200320_210422_210623/logs/deeptoolsMatrix%j.stdout
#SBATCH --error=ChIPseq_combined_200320_210422_210623/logs/deeptoolsMatrix%j.err
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=end
#SBATCH --job-name="deeptools"
#SBATCH --partition=prod_med

module load deeptools/3.0.0

# run from Menin dir
computeMatrix scale-regions -S ChIPseq_200320_NB501056_0470_AH5NJJBGXF/BW/Cas_S2.bw \
ChIPseq_200320_NB501056_0470_AH5NJJBGXF/BW/MENi_S3.bw \
ChIPseq_200320_NB501056_0470_AH5NJJBGXF/BW/MENKO_S4.bw \
ChIPseq_200320_NB501056_0470_AH5NJJBGXF/BW/LEDGFKO_S5.bw \
ChIPseq_210422_NB501056_0625_AHGNFTBGXJ/BW/MHC-CS04-K562-3A-DUAL-MLL1_S3.bw \
ChIPseq_210422_NB501056_0625_AHGNFTBGXJ/BW/MHC-CS04-K562-4A-DUAL-MLL1_S4.bw \
ChIPseq_210623_NB501056_0652_AHTHVNBGXJ/BW/CS06-CAS-DMSO-MLL1_S7.bw \
ChIPseq_210623_NB501056_0652_AHTHVNBGXJ/BW/CS06-CAS-VTP-1uM-MLL1_S8.bw \
ChIPseq_210623_NB501056_0652_AHTHVNBGXJ/BW/CS06-KMT2Bc8-DMSO-MLL1_S9.bw \
ChIPseq_210623_NB501056_0652_AHTHVNBGXJ/BW/CS06-KMT2Bc8-VTP-1uM-MLL1_S10.bw \
-R ChIPseq_200320_NB501056_0470_AH5NJJBGXF/scripts/MeninGenesDT.bed -a 3000 -b 3000 -m 5000 \
-o ChIPseq_combined_200320_210422_210623/deeptools/ChIPmatrix_ChIPcomb_Menin_Genes.gz

plotHeatmap -m ChIPseq_combined_200320_210422_210623/deeptools/ChIPmatrix_ChIPcomb_Menin_Genes.gz --sortUsing sum --boxAroundHeatmaps no \
--samplesLabel Cas MENi MENKO LEDGFKO 3A-DUAL-MLL1 4A-DUAL-MLL1 CAS-DMSO-MLL1 CAS-VTP-1uM-MLL1 KMT2Bc8-DMSO-MLL1 KMT2Bc8-VTP-1uM-MLL1 \
--colorMap Reds Reds Reds Reds Blues Blues Greens Greens Greens Greens \
-o ChIPseq_combined_200320_210422_210623/plots/Heatmap_ChIPcomb_Menin_Genes.pdf --plotTitle "ChIPseq Menin genes"
