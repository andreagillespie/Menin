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
MHC-I-CSCR03-K562-Cas9-SUZ12_S57.bw MHC-I-CSCR03-K562-EEDko-SUZ12_S58.bw \
-R /data/reference/dawson_labs/bed_files/Hg19/Hg19EnsGeneDT.bed -a 3000 -b 3000 -m 5000 -o CSCR03_SUZ12_Cov_matrix_RPCGNorm_Hg19EnsGenes.gz

plotProfile -m CSCR03_SUZ12_Cov_matrix_RPCGNorm_Hg19EnsGenes.gz --perGroup --samplesLabel \
K562-Cas9-SUZ12 K562-EEDko-SUZ12 \
-o ../../plots/Profile_CSCR03_SUZ12_RPGCnorm_Hg19EnsGenes.pdf --plotTitle "Cut&Run CSCR03 SUZ12 All genes"

plotHeatmap -m CSCR03_SUZ12_Cov_matrix_RPCGNorm_Hg19EnsGenes.gz --sortUsingSamples 1 --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
K562-Cas9-SUZ12 K562-EEDko-SUZ12 \
-o ../../plots/Heatmap_CSCR03_SUZ12_RPGCnorm_Hg19EnsGenes.pdf --plotTitle "Cut&Run CSCR03 SUZ12 All genes"
