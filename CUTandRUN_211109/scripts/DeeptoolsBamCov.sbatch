#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=0-2:00:00
#SBATCH --output=../logs/deeptools%j.stdout
#SBATCH --error=../logs/deeptools%j.err
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=end
#SBATCH --job-name="deeptools"
#SBATCH --partition=prod_short

module load deeptools/3.0.0


bname=`basename $1 .HgBLMTfil.sort.rmdup.bam`

# to run for normalisation
bamCoverage --bam $1 -o NormBW/${bname}.bw --binSize 20 --scaleFactor $2

# to run for unnormalised
bamCoverage --bam $1 -o BW/${bname}.bw --binSize 20
