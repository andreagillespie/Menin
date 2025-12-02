#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=prod_med
#SBATCH --mem-per-cpu=12G
#SBATCH --time=0-12:00:00
#SBATCH --output=../../logs/CnRt_post%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="cnrt_post"

module load samtools/1.8
module load igvtools/2.3.95

bname=`basename $1 _aligned_reads.bam`

samtools view -b -L /data/reference/dawson_labs/whitelists/Hg19Whitelist.bed -q 10 -o ${bname}.Hs.bam ${bname}_aligned_reads.bam

samtools view -b -L /data/reference/dawson_labs/whitelists/Dm6Whitelist.bed -q 10 -o ${bname}.Dm.bam ${bname}_aligned_reads.bam

samtools sort -o ${bname}.sort.Hs.bam ${bname}.Hs.bam

samtools index ${bname}.sort.Hs.bam

igvtools count ${bname}.sort.Hs.bam ${bname}.Hs.tdf hg19

samtools sort -o ${bname}.sort.Dm.bam ${bname}.Dm.bam

samtools index ${bname}.sort.Dm.bam

igvtools count ${bname}.sort.Dm.bam ${bname}.Dm.tdf dm6
