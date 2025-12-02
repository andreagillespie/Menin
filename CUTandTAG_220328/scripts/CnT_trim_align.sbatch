#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --partition=prod_med
#SBATCH --mem-per-cpu=2G
#SBATCH --time=1-0:00:00
#SBATCH --output=../logs/CutTag%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="CutTag"

module load fastqc/0.11.6
module load bowtie2/2.3.4.1
module load trimmomatic/0.39
module load picard/2.6.0
module load samtools/1.8
module load igvtools/2.3.95


bname=`basename $1 _R1_001.fastq.gz`

Reference=/data/reference/dawson_labs/joint_genomes/Hg19Dm6/Hg19Dm6.dna.toplevel

mkdir fastqc
fastqc -o fastqc/ -f fastq $1 $2

java -jar /config/binaries/trimmomatic/0.39/trimmomatic-0.39.jar PE -threads 1 -phred33 $1 $2 -baseout ${bname}_trim.fq.gz ILLUMINACLIP:/data/reference/dawson_labs/trimmomatic/TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

bowtie2 --end-to-end --very-sensitive --no-unal --no-mixed --no-discordant --phred33 -I 10 -X 700 -p 8 -t -x $Reference -1 ${bname}_trim_1P.fq.gz -2 ${bname}_trim_2P.fq.gz -S ${bname}.sam

samtools view -b -L /data/reference/dawson_labs/whitelists/Hg19Whitelist.bed -q 10 -o ${bname}.bam ${bname}.sam

samtools view -b -L /data/reference/dawson_labs/whitelists/Dm6Whitelist.bed -q 10 -o ${bname}.Dm.bam ${bname}.sam

samtools sort -o ${bname}.sort.bam ${bname}.bam

samtools index ${bname}.sort.bam

igvtools count ${bname}.sort.bam ${bname}.tdf hg19

samtools sort -o ${bname}.sort.Dm.bam ${bname}.Dm.bam

samtools index ${bname}.sort.Dm.bam

igvtools count ${bname}.sort.Dm.bam ${bname}.Dm.tdf dm6
