#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=1-0:00:00
#SBATCH --output=../../logs/DTMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix scale-regions -S \
MHC-I-CSCR03-K562-Cas9-H3K27me3_S59.bw MHC-I-CSCR03-K562-EEDko-H3K27me3_S60.bw \
MHC-I-CSCR03-K562-Cas9-SUZ12_S57.bw MHC-I-CSCR03-K562-EEDko-SUZ12_S58.bw \
-R /data/reference/dawson_labs/bed_files/Hg19/Hg19EnsGene1kbProm.bed -a 3000 -b 3000 -m 5000 -o CSCR03_Cov_matrix_RPCGNorm_all_Genes.gz

plotProfile -m CSCR03_Cov_matrix_RPCGNorm_all_Genes.gz --perGroup --samplesLabel \
K562-Cas9-H3K27me3 K562-EEDko-H3K27me3 K562-Cas9-SUZ12 K562-EEDko-SUZ12 \
-o ../../plots/Profile_CSCR03_RPGCnorm_AllGenes.pdf --plotTitle "Cut&Run All genes"

plotHeatmap -m CSCR03_Cov_matrix_RPCGNorm_all_Genes.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
K562-Cas9-H3K27me3 K562-EEDko-H3K27me3 K562-Cas9-SUZ12 K562-EEDko-SUZ12 \
--colorMap Reds Reds Purples Purples -o ../../plots/Heatmap_CSCR03_CnR_RPGCnorm_AllGenes.pdf --plotTitle "Cut&Run All genes"
