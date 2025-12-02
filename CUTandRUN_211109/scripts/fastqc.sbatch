#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --mem-per-cpu=4G
#SBATCH --time=0-1:00:00
#SBATCH --output=logs/fastqc%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END
#SBATCH --job-name="fastqc"
#SBATCH --partition=rhel_short

module load fastqc/0.12.1-gcc-13.2.0

# add trimmed for second run of fastqc
fastqc -o fastqc/trimmed -f fastq $1
