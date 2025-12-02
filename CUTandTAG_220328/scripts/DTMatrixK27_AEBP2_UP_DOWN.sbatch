#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=1-0:00:00
#SBATCH --output=../../logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix reference-point -S \
MHC-CSCT05-K562-NT2-H3K27me3_S5.RPGC.bw MHC-CSCT05-K562-AEBP2sgRNA-H3K27me3_S6.RPGC.bw MHC-CSCT05-K562-MTF2sgRNA-H3K27me3_S7.RPGC.bw \
../../../CUTandRUN_220310_NB501056_0771_AHMVHHBGXL/alignment/RPGCNormBW/MHC-CSCR05-K562-NT2-EZH2_S27.bw \
../../../CUTandRUN_220310_NB501056_0771_AHMVHHBGXL/alignment/RPGCNormBW/MHC-CSCR05-K562-AEBP2sgRNA-EZH2_S28.bw \
../../../CUTandRUN_220310_NB501056_0771_AHMVHHBGXL/alignment/RPGCNormBW/MHC-CSCR05-K562-MTF2sgRNA-EZH2_S29.bw \
../../../CUTandRUN_220310_NB501056_0771_AHMVHHBGXL/alignment/RPGCNormBW/MHC-CSCR05-K562-NT2-SUZ12_S24.bw \
../../../CUTandRUN_220310_NB501056_0771_AHMVHHBGXL/alignment/RPGCNormBW/MHC-CSCR05-K562-AEBP2sgRNA-SUZ12_S25.bw \
../../../CUTandRUN_220310_NB501056_0771_AHMVHHBGXL/alignment/RPGCNormBW/MHC-CSCR05-K562-MTF2sgRNA-SUZ12_S26.bw \
-R ../../bed_files/1RPMdiff_AEBP2_K27_DOWN.bed ../../bed_files/1RPMdiff_AEBP2_K27_UP.bed \
--referencePoint center -a 3000 -b 3000 -o CnTmatrix_AEBP2_RPGCnorm_UP_DOWN_K27.gz

plotHeatmap -m CnTmatrix_AEBP2_RPGCnorm_UP_DOWN_K27.gz --sortUsingSamples 1 --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
NT2-H3K27me3 AEBP2sgRNA-H3K27me3 MTF2sgRNA-H3K27me3 NT2-EZH2 AEBP2sgRNA-EZH2 MTF2sgRNA-EZH2 NT2-SUZ12 AEBP2sgRNA-SUZ12 MTF2sgRNA-SUZ12 \
--colorMap Greens Greens Greens RdPu RdPu RdPu Blues Blues Blues --refPointLabel peak.center --regionsLabel "DOWN" "UP" \
--zMin 0 0 0 0 0 0 0 \
--zMax 75 75 75 50 50 40 40 \
--yMin 0 0 0 0 0 0 0 \
--yMax 35 35 35 15 15 8 8 \
-o ../../plots/Heatmap_AEBP2_RPGCnorm_UP_DOWN_K27.pdf --plotTitle "Cut&Tag H3K27me3 binding, diff >1RPM"



