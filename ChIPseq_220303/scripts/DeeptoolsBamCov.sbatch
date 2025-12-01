#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=24G
#SBATCH --time=0-02:00:00
#SBATCH --output=../logs/deeptools%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=end
#SBATCH --job-name="deeptools"
#SBATCH --partition=prod_short

module load deeptools/3.5.0


bname=`basename $1 .HgBLMTfil.sort.rmdup.bam`

#bamCoverage --bam $1 -o BW/${bname}.bw --binSize 20

#bamCoverage --bam $1 -o BW_spikein_norm/${bname}.spikein.bw --binSize 20 --scaleFactor $2

bamCoverage --bam $1 -o BW_RPGC_norm/${bname}.RPGC.bw --binSize 20 --normalizeUsing RPGC --effectiveGenomeSize 2736124973

