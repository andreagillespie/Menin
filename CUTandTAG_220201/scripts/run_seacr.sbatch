#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=prod_med
#SBATCH --mem-per-cpu=8G
#SBATCH --time=1-00:0000
#SBATCH --output=../logs/SEACR%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="SEACR"

module load bedtools/2.26
module load R/4.0.2

seacr="/dawson_genomics/Projects/Menin/CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/scripts/SEACR_1.3.sh"

bname=`basename $1 .sort.bam`

#bedtools bamtobed -bedpe -i $1 > bed/${bname}_bowtie2.bed

#awk '$1==$4 && $6-$2 < 1000 {print $0}' bed/${bname}_bowtie2.bed > bed/${bname}_bowtie2.clean.bed

#cut -f 1,2,6 bed/${bname}_bowtie2.clean.bed | sort -k1,1 -k2,2n -k3,3n > bed/${bname}_bowtie2.fragments.bed

#bedtools genomecov -bg -i bed/${bname}_bowtie2.fragments.bed -g /data/reference/dawson_labs/genome_size/Hg19_chrom.size > bedgraph/${bname}_bowtie2.fragments.bedgraph

bash $seacr bedgraph/${bname}_bowtie2.fragments.normalised.bedgraph bedgraph/MHC-CSCT03-K562-CAS-IgG_S1_bowtie2.fragments.bedgraph non stringent peakCalling/SEACR/${bname}_seacr_normalised_control.peaks

bash $seacr bedgraph/${bname}_bowtie2.fragments.normalised.bedgraph 0.01 non stringent peakCalling/SEACR/${bname}_seacr_normalised_top0.01.peaks

