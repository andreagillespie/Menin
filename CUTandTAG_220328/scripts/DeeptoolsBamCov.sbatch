#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=24G
#SBATCH --time=0-02:00:00
#SBATCH --output=../logs/bdgNorm%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=end
#SBATCH --job-name="bdgNorm"
#SBATCH --partition=prod_short

module load deeptools/3.0.0
module load bedtools/2.26
module load R/4.0.2
module load samtools/1.8

seacr="/dawson_genomics/Projects/Menin/CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/scripts/SEACR_1.3.sh"
gsize=/data/reference/dawson_labs/genome_size/Hg19_chrom.size


bname=`basename $1 .sort.bam`

#bamCoverage --bam $1 -o BW/${bname}.bw --binSize 20

#bamCoverage --bam $1 -o BW_spikein_norm/${bname}.spikein.bw --binSize 20 --scaleFactor $2

#bamCoverage --bam $1 -o BW_RPGC_norm/${bname}.RPGC.bw --binSize 20 --normalizeUsing RPGC --effectiveGenomeSize 2736124973


samtools sort -n -o ../alignment/${bname}.namesort.bam $1

bedtools bamtobed -bedpe -i ../alignment/${bname}.namesort.bam > bed/${bname}_bowtie2.bed

# keep read pairs on same chr and <1000 bp
awk '$1==$4 && $6-$2 < 1000 {print $0}' bed/${bname}_bowtie2.bed > bed/${bname}_bowtie2.clean.bed

# only extract the fragment related columns
cut -f 1,2,6 bed/${bname}_bowtie2.clean.bed | sort -k1,1 -k2,2n -k3,3n > bed/${bname}_bowtie2.fragments.bed

bedtools genomecov -bg -i bed/${bname}_bowtie2.fragments.bed -g $gsize > bedgraph/${bname}_bowtie2.fragments.bedgraph

bedtools genomecov -bg -scale $2 -i bed/${bname}_bowtie2.fragments.bed -g $gsize > bedgraph/${bname}_bowtie2.fragments.normalised.bedgraph
