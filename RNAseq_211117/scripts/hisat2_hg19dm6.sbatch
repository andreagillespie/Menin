#!/bin/bash 
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --mem-per-cpu=10G
#SBATCH --time=0-24:00:00
#SBATCH --output=../logs/hisat2%j.stdout
#SBATCH --error=../logs/hisat2%j.err
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END
#SBATCH --job-name=“hisat2”
#SBATCH --partition=prod_med

module load trimgalore
module load sratoolkit
module load hisat2
module load bowtie2
module load samtools
module load igvtools
module load htseq

bname=`basename $1 _R1_001.fastq.gz`

mkdir count
mkdir tdf
mkdir fastqc

srun -n 1 trim_galore $1
srun -n 1 hisat2 -q -x ../reference/Hg19Dm6.dna.toplevel -U ${bname}_R1_001_trimmed.fq.gz -S ${bname}.sam -p 8 --qc-filter --rna-strandness F
srun -n 1 samtools view -bS ${bname}.sam > ${bname}.bam
srun -n 1 samtools sort ${bname}.bam -o ${bname}.sort.bam
srun -n 1 samtools index ${bname}.sort.bam
srun -n 1 htseq-count -f bam -s no -a 10 ${bname}.sort.bam /data/reference/dawson_labs/joint_genomes/Hg19Dm6/Hg19Dm6known.gff > count/${bname}.count
srun -n 1 igvtools count ${bname}.sort.bam tdf/${bname}.tdf hg19
srun -n 1 fastqc -o fastqc $1
srun -n 1 fastqc -o fastqc ${bname}_R1_001_trimmed.fq.gz
