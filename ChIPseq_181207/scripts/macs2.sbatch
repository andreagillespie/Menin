#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=0-2:00:00
#SBATCH --output=logs/MACS%j.stdout
#SBATCH --mail-type=END
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --job-name="ChIP_MACS"
#SBATCH --partition=prod_short

module load macs/2.1.1

bname=`basename $1 .HgBLMTfil.sort.rmdup.bam`

srun -n 1 macs2 callpeak -t $1 -c $2 --broad -g hs -n ${bname} -p 0.05 --outdir broadpeaks -B



