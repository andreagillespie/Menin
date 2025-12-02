#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=2G
#SBATCH --time=0-2:00:00
#SBATCH --output=../logs/rawbamcov%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END
#SBATCH --job-name="RawBamCov"
#SBATCH --partition=prod_short

module load deeptools/3.0.0

bname=`basename $1 .sort.bam`

# to run for unnormalised deduplicated
bamCoverage -b $1 -o RawBW/${bname}.bw 
