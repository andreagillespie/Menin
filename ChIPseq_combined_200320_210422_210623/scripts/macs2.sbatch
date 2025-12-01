#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=0-2:00:00
#SBATCH --output=../logs/MACS%j.stdout
#SBATCH --error=../logs/MACS%j.err
#SBATCH --mail-type=END
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --job-name="MACS"
#SBATCH --partition=prod_short

module load macs

bname=`basename $1 .bam`
srun -n 1 macs2 callpeak -t $1 -c $2 -g hs -n ${bname} --outdir narrowpeaks -B

srun -n 1 macs2 callpeak -t $1 -c $2 --broad -g hs -n ${bname} --outdir broadpeaks -B
