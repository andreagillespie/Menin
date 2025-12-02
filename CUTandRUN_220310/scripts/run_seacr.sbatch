#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=prod_short
#SBATCH --mem-per-cpu=8G
#SBATCH --time=0-02:0000
#SBATCH --output=../logs/SEACR%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="SEACR"

module load bedtools/2.26
module load R/4.0.2
module load samtools/1.8

seacr="/dawson_genomics/Projects/Menin/CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/scripts/SEACR_1.3.sh"
gsize=/data/reference/dawson_labs/genome_size/Hg19_chrom.size

bname=`basename $1 .sort.bam`

samtools sort -n -o ../alignment/${bname}.namesort.bam $1

bedtools bamtobed -bedpe -i ../alignment/${bname}.namesort.bam > bed/${bname}_bowtie2.bed

# keep read pairs on same chr and <1000 bp
awk '$1==$4 && $6-$2 < 1000 {print $0}' bed/${bname}_bowtie2.bed > bed/${bname}_bowtie2.clean.bed

# only extract the fragment related columns
cut -f 1,2,6 bed/${bname}_bowtie2.clean.bed | sort -k1,1 -k2,2n -k3,3n > bed/${bname}_bowtie2.fragments.bed

bedtools genomecov -bg -i bed/${bname}_bowtie2.fragments.bed -g $gsize > bedgraph/${bname}_bowtie2.fragments.bedgraph

bedtools genomecov -bg -scale $2 -i bed/${bname}_bowtie2.fragments.bed -g $gsize > bedgraph/${bname}_bowtie2.fragments.normalised.bedgraph

#bash $seacr bedgraph/${bname}_bowtie2.fragments.normalised.bedgraph 0.01 non stringent peakCalling/SEACR/${bname}_seacr_normalised_top0.01.peaks

