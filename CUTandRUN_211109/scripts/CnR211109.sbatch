#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=16G
#SBATCH --time=0-12:00:00
#SBATCH --output=../logs/ChIPbpipe%j.stdout
#SBATCH --error=../logs/ChIPbpipe%j.err
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END
#SBATCH --job-name="CUTandRUN"
#SBATCH --partition=prod_med

module load bpipe
module load cutadapt
module load bwa
module load samtools
module load igvtools
module load picard

srun -n 1 bpipe run ../scripts/ChIPbpipeHsDmSE.txt $1
