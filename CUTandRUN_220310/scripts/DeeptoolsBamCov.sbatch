#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=2G
#SBATCH --time=0-2:00:00
#SBATCH --output=../logs/DTBamCov%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END
#SBATCH --job-name="DTBamCov"
#SBATCH --partition=prod_short

module load deeptools/3.0.0

bname=`basename $1 _aligned_reads.bam`

# use RPCG norm
bamCoverage --bam $1 -o .big/${bname}.bw --binSize 20 --normalizeUsing RPGC --effectiveGenomeSize 2736124973

# to run for Dm library size normalisation
bamCoverage --bam $1 -o LibraryNormBW/${bname}.bw --binSize 20 --scaleFactor $2
