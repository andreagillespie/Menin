#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=16G
#SBATCH --time=0-04:00:00
#SBATCH --output=../logs/ChIPbpipe%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END
#SBATCH --job-name="ChIP_align"
#SBATCH --partition=prod_med

module load bpipe
module load cutadapt
module load bwa
module load samtools
module load igvtools
module load picard

srun -n 1 bpipe run ../scripts/ChIPbpipeHsDmSE.txt $1
