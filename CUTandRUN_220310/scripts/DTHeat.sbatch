#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=0-2:00:00
#SBATCH --output=../../logs/DTMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMHeat"
#SBATCH --partition=prod_short

module load deeptools/3.5.0

plotHeatmap -m CSCR01_K27_Cov_matrix_RPCGNorm_all_Genes.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CAS-H3K27me3 MEN1c4-KO-H3K27me3 \
-o ../../plots/Heatmap_CSCR01_K27_RPGCnorm_AllGenes.pdf --plotTitle "Cut&Run CSCR01 H3K27me3 All genes"

plotHeatmap -m CSCR01_SUZ12_Cov_matrix_RPCGNorm_all_Genes.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CAS-SUZ12 MEN1c4-KO-SUZ12 \
-o ../../plots/Heatmap_CSCR01_SUZ12_RPGCnorm_AllGenes.pdf --plotTitle "Cut&Run CSCR01 SUZ12 All genes"

plotHeatmap -m CSCR01_MLL1_Cov_matrix_RPCGNorm_all_Genes.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CAS-MLL1 MEN1c4-KO-MLL1 \
-o ../../plots/Heatmap_CSCR01_MLL1_RPGCnorm_AllGenes.pdf --plotTitle "Cut&Run CSCR01 MLL1 All genes"

plotHeatmap -m CSCR03_K27_Cov_matrix_RPCGNorm_all_Genes.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
K562-Cas9-H3K27me3 K562-EEDko-H3K27me3 \
-o ../../plots/Heatmap_CSCR03_K27_RPGCnorm_AllGenes.pdf --plotTitle "Cut&Run CSCR03 H3K27me3 All genes"

plotHeatmap -m CSCR03_SUZ12_Cov_matrix_RPCGNorm_all_Genes.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
K562-Cas9-SUZ12 K562-EEDko-SUZ12 \
-o ../../plots/Heatmap_CSCR03_SUZ12_RPGCnorm_AllGenes.pdf --plotTitle "Cut&Run CSCR03 SUZ12 All genes"

plotHeatmap -m CSCR04_MLL1_Cov_matrix_RPCGNorm_all_Genes.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CAS-MLL1 MEN1c4-MLL1 EEDko-MLL1 EEDkoANDMEN1ko-MLL1 \
-o ../../plots/Heatmap_CSCR04_MLL1_RPGCnorm_AllGenes.pdf --plotTitle "Cut&Run CSCR04 MLL1 All genes"

plotHeatmap -m CSCR04_RING1B_Cov_matrix_RPCGNorm_all_Genes.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CAS-RING1B MEN1c4-RING1B EEDko-RING1B EEDkoANDMEN1ko-RING1B \
-o ../../plots/Heatmap_CSCR04_RING1B_RPGCnorm_AllGenes.pdf --plotTitle "Cut&Run CSCR04 RING1B All genes"


