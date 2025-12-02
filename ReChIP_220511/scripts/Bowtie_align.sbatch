#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --partition=prod_med
#SBATCH --mem-per-cpu=2G
#SBATCH --time=1-0:00:00
#SBATCH --output=../logs/ReChIP%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="ReChIP"

module load fastqc/0.11.6
module load bowtie2/2.3.4.1
module load cutadapt/1.14
module load picard/2.6.0
module load samtools/1.8
module load igvtools/2.3.95


bname=`basename $1 _R1_001.fastq.gz`

Reference=/data/reference/dawson_labs/joint_genomes/Hg19Dm6/Hg19Dm6.dna.toplevel

#mkdir fastqc
#fastqc -o fastqc/ -f fastq $1

#cutadapt -a AGATCGGAAGAGC -o ${bname}_trim.gz $1

#bowtie2 --end-to-end --very-sensitive --no-unal --no-mixed --no-discordant --phred33 -I 10 -X 700 -p 8 -t -x $Reference -U ${bname}_trim.gz -S ${bname}.sam

samtools view -b -L /data/reference/dawson_labs/whitelists/Hg19Whitelist.bed -q 10 -o ${bname}.bam ${bname}.sam

samtools sort -o ${bname}.sort.bam ${bname}.bam

MarkDuplicates.sh I=${bname}.sort.bam O=${bname}.sort.rmdup.bam M=${bname}.txt REMOVE_DUPLICATES=true VALIDATION_STRINGENCY=SILENT

samtools index ${bname}.sort.rmdup.bam

igvtools count ${bname}.sort.rmdup.bam ${bname}.tdf hg19
