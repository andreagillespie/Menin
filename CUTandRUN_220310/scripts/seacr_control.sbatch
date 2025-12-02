#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=prod_short
#SBATCH --mem-per-cpu=8G
#SBATCH --time=0-02:0000
#SBATCH --output=../logs/SEACR%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="SEACR"

module load bedtools/2.26
module load R/4.0.2

seacr="/dawson_genomics/Projects/Menin/CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/scripts/SEACR_1.3.sh"

bname=`basename $1 _bowtie2.fragments.normalised.bedgraph`

bash $seacr bedgraph/${bname}_bowtie2.fragments.normalised.bedgraph $2 norm relaxed peakCalling/SEACR/${bname}_seacr_normalised_control.peaks


