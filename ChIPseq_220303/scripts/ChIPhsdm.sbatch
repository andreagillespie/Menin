#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --mem-per-cpu=16G
#SBATCH --time=0-12:00:00
#SBATCH --output=../logs/ChIP%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END
#SBATCH --job-name="ChIPpipe"
#SBATCH --partition=prod_med

module load bpipe/0.9.9.4
module load cutadapt/1.14
module load bwa/0.7.13
module load samtools/1.4.1
module load igvtools/2.3.95

srun -n 1 bpipe run ../scripts/ChIPbpipeHsDm.txt $1
