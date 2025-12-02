---
title: "CUTandTAG_220328"
output: html_document
---

Project directory:
/dawson_genomics/Projects/Menin/CUTandTAG_220328_NB501056_0777_AHNGTWBGXL

FASTQ location:
/pipeline/Runs/NextSeq/220328_NB501056_0777_AHNGTWBGXL/ProjectFolders/Project_Christina-Sparbier


# process amd align fastqs; authors suggest not removing dups as fragments with same coords are expected due to protocol, so dups not removed
# run from alignment dir
```{bash}
cd /dawson_genomics/Projects/Menin/CUTandRUN_220310_NB501056_0771_AHMVHHBGXL/alignment
for fq in /pipeline/Runs/NextSeq/220328_NB501056_0777_AHNGTWBGXL/ProjectFolders/Project_Christina-Sparbier/*/*_R1_001.fastq.gz
do
bname=`basename $fq _R1_001.fastq.gz`
sbatch ../scripts/CnR_trim_align.sbatch $fq /pipeline/Runs/NextSeq/220328_NB501056_0777_AHNGTWBGXL/ProjectFolders/Project_Christina-Sparbier/*/${bname}_R2_001.fastq.gz
done
```

# run multiqc
```{bash}
cd fastqc
module load multiqc/1.8
multiqc .

# also qc trimmed reads, from alignment dir
cd ..
module load fastqc/0.11.6
fastqc ./*trim_*P.fq.gz

# run multiqc on trimmed paired reads
multiqc . --ignore "*_001_*"
```

# get flagstats for spike-in to normalise
```{bash}
module load samtools/1.8

samtools flagstat MHC-CSCT05-K562-AEBP2sgRNA-H2AK119_S9.sort.Dm.bam
136272 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT05-K562-AEBP2sgRNA-H3K27me3_S6.sort.Dm.bam
207826 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT05-K562-AEBP2sgRNA-H3K4me3_S3.sort.Dm.bam
2968212 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT05-K562-MTF2sgRNA-H2AK119_S10.sort.Dm.bam
172617 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT05-K562-MTF2sgRNA-H3K27me3_S7.sort.Dm.bam
334742 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT05-K562-MTF2sgRNA-H3K4me3_S4.sort.Dm.bam
2932795 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT05-K562-NT2-H2AK119_S8.sort.Dm.bam
181116 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT05-K562-NT2-H3K27me3_S5.sort.Dm.bam
222424 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT05-K562-NT2-H3K4me3_S2.sort.Dm.bam
2916563 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT05-K562-NT2-IgG_S1.sort.Dm.bam
2 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT06-K562-CAS-EZH2i-H3K4me3_S12.sort.Dm.bam
1769261 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT06-K562-CAS-EZH2i-IFN-H3K4me3_S13.sort.Dm.bam
1605433 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT06-K562-CAS-EZH2i-IgG_S11.sort.Dm.bam
324 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT06-K562-MLL1-2ko-EZH2i-H3K4me3_S14.sort.Dm.bam
4097732 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT06-K562-MLL1-2ko-EZH2i-IFN-H3K4me3_S15.sort.Dm.bam
4062415 + 0 in total (QC-passed reads + QC-failed reads)
```

# Normalise to Dm reads by flagstat comparison and RPGC
```{bash}
# run from align dir
# mkdirs for analysis
mkdir ../cnt_analysis
mkdir ../cnt_analysis/bed
mkdir ../cnt_analysis/bedgraph
mkdir BW_spikein_norm
mkdir BW_RPGC_norm
mkdir BW

# scale factor for each is 1000000/Dm reads from flagstats file
sbatch ../scripts/norm_bdg_bw.sbatch MHC-CSCT05-K562-AEBP2sgRNA-H2AK119_S9.sort.bam 7.338265
sbatch ../scripts/norm_bdg_bw.sbatch MHC-CSCT05-K562-AEBP2sgRNA-H3K27me3_S6.sort.bam 4.811717
sbatch ../scripts/norm_bdg_bw.sbatch MHC-CSCT05-K562-AEBP2sgRNA-H3K4me3_S3.sort.bam 0.3369032
sbatch ../scripts/norm_bdg_bw.sbatch MHC-CSCT05-K562-MTF2sgRNA-H2AK119_S10.sort.bam 5.793172
sbatch ../scripts/norm_bdg_bw.sbatch MHC-CSCT05-K562-MTF2sgRNA-H3K27me3_S7.sort.bam 2.987375
sbatch ../scripts/norm_bdg_bw.sbatch MHC-CSCT05-K562-MTF2sgRNA-H3K4me3_S4.sort.bam 0.3409717
sbatch ../scripts/norm_bdg_bw.sbatch MHC-CSCT05-K562-NT2-H2AK119_S8.sort.bam 5.521323
sbatch ../scripts/norm_bdg_bw.sbatch MHC-CSCT05-K562-NT2-H3K27me3_S5.sort.bam 4.495918
sbatch ../scripts/norm_bdg_bw.sbatch MHC-CSCT05-K562-NT2-H3K4me3_S2.sort.bam 0.3428693
# still running IgG to get BWs and RPGC norm and for consistency, but spike-in norm too large and not usable
sbatch ../scripts/norm_bdg_bw.sbatch MHC-CSCT05-K562-NT2-IgG_S1.sort.bam 5e+05

sbatch ../scripts/norm_bdg_bw.sbatch MHC-CSCT06-K562-CAS-EZH2i-H3K4me3_S12.sort.bam 0.5652077
sbatch ../scripts/norm_bdg_bw.sbatch MHC-CSCT06-K562-CAS-EZH2i-IFN-H3K4me3_S13.sort.bam 0.6228849
# still running IgG to get BWs and RPGC norm and for consistency, but spike-in norm too large and not usable
sbatch ../scripts/norm_bdg_bw.sbatch MHC-CSCT06-K562-CAS-EZH2i-IgG_S11.sort.bam 3086.42
sbatch ../scripts/norm_bdg_bw.sbatch MHC-CSCT06-K562-MLL1-2ko-EZH2i-H3K4me3_S14.sort.bam 0.2440374
sbatch ../scripts/norm_bdg_bw.sbatch MHC-CSCT06-K562-MLL1-2ko-EZH2i-IFN-H3K4me3_S15.sort.bam 0.246159
```


# run macs for broadpeaks with various p thresholds with bdg output to try to get good peaks for use with diffpeaks
```{bash}
# run from macs dir
cd ..
mkdir macs
cd macs
mkdir broadpeaks_p0_05
mkdir broadpeaks_p0_1
mkdir broadpeaks_p0_2

sbatch ../scripts/macs2.sbatch ../alignment/MHC-CSCT05-K562-NT2-H3K4me3_S2.sort.bam ../alignment/MHC-CSCT05-K562-NT2-IgG_S1.sort.bam
sbatch ../scripts/macs2.sbatch ../alignment/MHC-CSCT05-K562-AEBP2sgRNA-H3K4me3_S3.sort.bam ../alignment/MHC-CSCT05-K562-NT2-IgG_S1.sort.bam
sbatch ../scripts/macs2.sbatch ../alignment/MHC-CSCT05-K562-MTF2sgRNA-H3K4me3_S4.sort.bam ../alignment/MHC-CSCT05-K562-NT2-IgG_S1.sort.bam 
sbatch ../scripts/macs2.sbatch ../alignment/MHC-CSCT05-K562-NT2-H3K27me3_S5.sort.bam ../alignment/MHC-CSCT05-K562-NT2-IgG_S1.sort.bam
sbatch ../scripts/macs2.sbatch ../alignment/MHC-CSCT05-K562-AEBP2sgRNA-H3K27me3_S6.sort.bam ../alignment/MHC-CSCT05-K562-NT2-IgG_S1.sort.bam
sbatch ../scripts/macs2.sbatch ../alignment/MHC-CSCT05-K562-MTF2sgRNA-H3K27me3_S7.sort.bam ../alignment/MHC-CSCT05-K562-NT2-IgG_S1.sort.bam
sbatch ../scripts/macs2.sbatch ../alignment/MHC-CSCT05-K562-NT2-H2AK119_S8.sort.bam ../alignment/MHC-CSCT05-K562-NT2-IgG_S1.sort.bam
sbatch ../scripts/macs2.sbatch ../alignment/MHC-CSCT05-K562-AEBP2sgRNA-H2AK119_S9.sort.bam ../alignment/MHC-CSCT05-K562-NT2-IgG_S1.sort.bam
sbatch ../scripts/macs2.sbatch ../alignment/MHC-CSCT05-K562-MTF2sgRNA-H2AK119_S10.sort.bam ../alignment/MHC-CSCT05-K562-NT2-IgG_S1.sort.bam

sbatch ../scripts/macs2.sbatch ../alignment/MHC-CSCT06-K562-CAS-EZH2i-H3K4me3_S12.sort.bam ../alignment/MHC-CSCT06-K562-CAS-EZH2i-IgG_S11.sort.bam
sbatch ../scripts/macs2.sbatch ../alignment/MHC-CSCT06-K562-CAS-EZH2i-IFN-H3K4me3_S13.sort.bam ../alignment/MHC-CSCT06-K562-CAS-EZH2i-IgG_S11.sort.bam
sbatch ../scripts/macs2.sbatch ../alignment/MHC-CSCT06-K562-MLL1-2ko-EZH2i-H3K4me3_S14.sort.bam ../alignment/MHC-CSCT06-K562-CAS-EZH2i-IgG_S11.sort.bam
sbatch ../scripts/macs2.sbatch ../alignment/MHC-CSCT06-K562-MLL1-2ko-EZH2i-IFN-H3K4me3_S15.sort.bam ../alignment/MHC-CSCT06-K562-CAS-EZH2i-IgG_S11.sort.bam 
```

# use cut&run tools as in prev analysis, run step-wise only alignment & peak calling to get macs peaks
```{bash}
# make a working dir for cnrtools and run from there (set to work dir in config)
mkdir cnr_tools_wd

# run step-wise for more control, needs to be run from tools wd & use sym links in wd for fastqs
cd cnr_tools_wd
for fq in /pipeline/Runs/NextSeq/220328_NB501056_0777_AHNGTWBGXL/ProjectFolders/Project_Christina-Sparbier/*/*.fastq.gz
do
bname=`basename $fq`
ln -s $fq ./$bname
done

# run validation and create scripts first, use software installed in prev project dir
/dawson_genomics/Projects/JQ1VHL/CutandRun_211014_NB501056_0704_AHNYJVBGXK/cutandruntools/validate.py ../scripts/config.json
/dawson_genomics/Projects/JQ1VHL/CutandRun_211014_NB501056_0704_AHNYJVBGXK/cutandruntools/create_scripts.py ../scripts/config.json

for fq in ./*_R1_001.fastq.gz
do
sbatch integrated.sh $fq
done

for bam in aligned.aug10/*aligned_reads.bam
do
sbatch aligned.aug10/integrated.step2.sh $bam
done
```

# post-process CnR tools output so it will work properly with diffpeaks (separate organisms and sort)
```{bash}
# run from cnrt output alignment dir
cd aligned.aug10
for bam in *aligned_reads.bam
do
sbatch ../../scripts/cnrt_postprocess_bams.sbatch $bam
done
```

# make matrix of control peaks calls from cnr tools with macs
### had issue with this in default R/4.0.2 so had to switch to 4.1.0 for this one
```{r}
library(GenomicRanges)
library(Rsubread)
library(dplyr)
library(stringr)
library(chromVAR)

project.dir <- "/dawson_genomics/Projects/Menin/CUTandTAG_220328_NB501056_0777_AHNGTWBGXL"
align.dir <- file.path(project.dir, "alignment")
cnrt.dir <- file.path(project.dir, "cnr_tools_wd")
macs.dir <- file.path(cnrt.dir, "macs2.broad.all.frag.aug18")
fip.dir <- file.path(project.dir, "frag_in_peak")
dir.create(fip.dir)

# make master peak list
bams <- list.files(align.dir, pattern = "\\.sort.bam$", full.names = TRUE)
# remove IgG samples
bams <- bams[-c(10, 13)]

mPeak <- GRanges()
for(bam in bams){
  bname <- gsub(".sort.bam", "", basename(bam))
  peakRes = read.table(
    file.path(macs.dir, paste0(bname, "_aligned_reads_peaks.broadPeak")),
    header = FALSE, 
    fill = TRUE
    )
  mPeak = GRanges(seqnames = peakRes$V1, IRanges(start = peakRes$V2, end = peakRes$V3), strand = "*") %>% append(mPeak, .)
}
masterPeak = reduce(mPeak)

# get fragment counts for each peak in the master peaks list
countsMat <- matrix(NA, length(masterPeak), length(bams))
i <- 1
for(bam in bams){
  fragment_counts <- chromVAR::getCounts(bam, masterPeak, paired = TRUE, by_rg = FALSE, format = "bam")
  countsMat[, i] = counts(fragment_counts)[, 1]
  i = i+1
}

# add col and row names
colnames(countsMat) <- gsub("-", "_", gsub("MHC-CSCT0[5-6]-K562-", "", gsub(".sort.bam", "", basename(bams))))
rownames(countsMat) <- paste0(seqnames(masterPeak), ":", start(masterPeak), "-", end(masterPeak))

# remove zero counts
keep <- which(rowSums(countsMat > 0) >= 1)
countsMat <- countsMat[keep, ]

# write out counts matrix
write.table(
  countsMat,
  file.path(fip.dir, "cnrt_macs_peaks_counts_matrix.txt"),
  sep = "\t",
  row.names = TRUE,
  col.names = NA
  )
```

# get Hg Bam flagstats for normalisation as we think this may be a better way to normalise for these
```{bash}
module load samtools/1.8

samtools flagstat MHC-CSCT05-K562-AEBP2sgRNA-H2AK119_S9.sort.bam
11385638 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT05-K562-AEBP2sgRNA-H3K27me3_S6.sort.bam
12719262 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT05-K562-AEBP2sgRNA-H3K4me3_S3.sort.bam
9454525 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT05-K562-MTF2sgRNA-H2AK119_S10.sort.bam
10137523 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT05-K562-MTF2sgRNA-H3K27me3_S7.sort.bam
12110650 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT05-K562-MTF2sgRNA-H3K4me3_S4.sort.bam
9054148 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT05-K562-NT2-H2AK119_S8.sort.bam
13849742 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT05-K562-NT2-H3K27me3_S5.sort.bam
13785597 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT05-K562-NT2-H3K4me3_S2.sort.bam
8595359 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT05-K562-NT2-IgG_S1.sort.bam
316 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT06-K562-CAS-EZH2i-H3K4me3_S12.sort.bam
9881906 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT06-K562-CAS-EZH2i-IFN-H3K4me3_S13.sort.bam
9930347 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT06-K562-CAS-EZH2i-IgG_S11.sort.bam
1748 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT06-K562-MLL1-2ko-EZH2i-H3K4me3_S14.sort.bam
9914617 + 0 in total (QC-passed reads + QC-failed reads)

samtools flagstat MHC-CSCT06-K562-MLL1-2ko-EZH2i-IFN-H3K4me3_S15.sort.bam
8676606 + 0 in total (QC-passed reads + QC-failed reads)
```

# re-do normalisation and pseudocounting based on Hg reads
```{r}
countsDF <- as.data.frame(countsMat)
# normalise pseudocounts as in prev analysis by Dm reads, then write out
countsDF$AEBP2sgRNA_H2AK119_S9 <- (countsDF$AEBP2sgRNA_H2AK119_S9 + 0.5) * 0.08782995
countsDF$AEBP2sgRNA_H3K27me3_S6 <- (countsDF$AEBP2sgRNA_H3K27me3_S6 + 0.5) * 0.07862091
countsDF$AEBP2sgRNA_H3K4me3_S3 <- (countsDF$AEBP2sgRNA_H3K4me3_S3 + 0.5) * 0.1057695
countsDF$MTF2sgRNA_H2AK119_S10 <- (countsDF$MTF2sgRNA_H2AK119_S10 + 0.5) * 0.09864343
countsDF$MTF2sgRNA_H3K27me3_S7 <- (countsDF$MTF2sgRNA_H3K27me3_S7 + 0.5) * 0.08257195
countsDF$MTF2sgRNA_H3K4me3_S4 <-(countsDF$MTF2sgRNA_H3K4me3_S4 + 0.5) * 0.1104466
countsDF$NT2_H2AK119_S8 <- (countsDF$NT2_H2AK119_S8 + 0.5) * 0.07220351
countsDF$NT2_H3K27me3_S5 <- (countsDF$NT2_H3K27me3_S5 + 0.5) * 0.07253948
countsDF$NT2_H3K4me3_S2 <- (countsDF$NT2_H3K4me3_S2 + 0.5) * 0.1163419
countsDF$CAS_EZH2i_H3K4me3_S12 <- (countsDF$CAS_EZH2i_H3K4me3_S12 + 0.5) * 0.1011951
countsDF$CAS_EZH2i_IFN_H3K4me3_S13 <- (countsDF$CAS_EZH2i_IFN_H3K4me3_S13 + 0.5) * 0.1007014
countsDF$MLL1_2ko_EZH2i_H3K4me3_S14 <- (countsDF$MLL1_2ko_EZH2i_H3K4me3_S14 + 0.5) * 0.1008612
countsDF$MLL1_2ko_EZH2i_IFN_H3K4me3_S15 <- (countsDF$MLL1_2ko_EZH2i_IFN_H3K4me3_S15 + 0.5) * 0.1152524

write.table(
  countsDF,
  file.path(fip.dir, "Norm_psuedocount_cnrt_macs_peaks_counts_matrix.txt"),
  sep = "\t",
  row.names = TRUE,
  col.names = NA
  )

countsNorm <- as.data.frame(countsMat)
# also normalise non-pseudocounts by Dm reads, then write out
countsNorm$AEBP2sgRNA_H2AK119_S9 <- (countsNorm$AEBP2sgRNA_H2AK119_S9) * 0.08782995
countsNorm$AEBP2sgRNA_H3K27me3_S6 <- (countsNorm$AEBP2sgRNA_H3K27me3_S6) * 0.07862091
countsNorm$AEBP2sgRNA_H3K4me3_S3 <- (countsNorm$AEBP2sgRNA_H3K4me3_S3) * 0.1057695
countsNorm$MTF2sgRNA_H2AK119_S10 <- (countsNorm$MTF2sgRNA_H2AK119_S10) * 0.09864343
countsNorm$MTF2sgRNA_H3K27me3_S7 <- (countsNorm$MTF2sgRNA_H3K27me3_S7) * 0.08257195
countsNorm$MTF2sgRNA_H3K4me3_S4 <-(countsNorm$MTF2sgRNA_H3K4me3_S4) * 0.1104466
countsNorm$NT2_H2AK119_S8 <- (countsNorm$NT2_H2AK119_S8) * 0.07220351
countsNorm$NT2_H3K27me3_S5 <- (countsNorm$NT2_H3K27me3_S5) * 0.07253948
countsNorm$NT2_H3K4me3_S2 <- (countsNorm$NT2_H3K4me3_S2) * 0.1163419
countsNorm$CAS_EZH2i_H3K4me3_S12 <- (countsNorm$CAS_EZH2i_H3K4me3_S12) * 0.1011951
countsNorm$CAS_EZH2i_IFN_H3K4me3_S13 <- (countsNorm$CAS_EZH2i_IFN_H3K4me3_S13) * 0.1007014
countsNorm$MLL1_2ko_EZH2i_H3K4me3_S14 <- (countsNorm$MLL1_2ko_EZH2i_H3K4me3_S14) * 0.1008612
countsNorm$MLL1_2ko_EZH2i_IFN_H3K4me3_S15 <- (countsNorm$MLL1_2ko_EZH2i_IFN_H3K4me3_S15) * 0.1152524

write.table(
  countsNorm,
  file.path(fip.dir, "Norm_cnrt_macs_peaks_counts_matrix.txt"),
  sep = "\t",
  row.names = TRUE,
  col.names = NA
  )
```


# use cnrt macs peaks to get LFC of frags in peaks
```{r}
library(ChIPseeker)
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
library(limma)

# get annotation object
txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene

# set desired comparisons
comps <- list(
	"AEBP2sgRNAvNT2_H2AK119" = c("AEBP2sgRNA_H2AK119_S9", "NT2_H2AK119_S8"),
	"MTF2sgRNAvNT2_H2AK119" = c("MTF2sgRNA_H2AK119_S10", "NT2_H2AK119_S8"),
	"AEBP2sgRNAvNT2_H3K27me3" = c("AEBP2sgRNA_H3K27me3_S6", "NT2_H3K27me3_S5"),
	"MTF2sgRNAvNT2_H3K27me3" = c("MTF2sgRNA_H3K27me3_S7", "NT2_H3K27me3_S5"),
	"AEBP2sgRNAvNT2_H3K4me3" = c("AEBP2sgRNA_H3K4me3_S3", "NT2_H3K4me3_S2"),
	"MTF2sgRNAvNT2_H3K4me3" = c("MTF2sgRNA_H3K4me3_S4", "NT2_H3K4me3_S2"),
	"MLL1_2KOvCAS_EZH2i_H3K4me3" = c("MLL1_2ko_EZH2i_H3K4me3_S14", "CAS_EZH2i_H3K4me3_S12"),
	"MLL1_2KOvCAS_EZH2i_IFN_H3K4me3" = c("MLL1_2ko_EZH2i_IFN_H3K4me3_S15", "CAS_EZH2i_IFN_H3K4me3_S13")
)

# get lfc of reads in peaks in norm pseudocounts table for each comparison
for(comp.i in 1:length(comps)){

	# get each comparison to specify peaks matrix
	comp.x <- comps[[comp.i]][1]
	comp.y <- comps[[comp.i]][2]

	comp.table <- cbind(countsDF[ , comp.x], countsDF[ , comp.y])
	colnames(comp.table) <- c(comp.x, comp.y)
	rownames(comp.table) <- rownames(countsDF)
	# remove those with zeros in both
	keep <- which(rowSums(countsMat[,c(comp.x, comp.y)] >= 5) == 2)
	comp.table <- comp.table[keep, ]
	comp.table <- as.data.frame(comp.table)
	# add lfc
	comp.table$LFC <- log2(comp.table[, comp.x]/comp.table[, comp.y])
	# add coordinates to table
	chr.pos <- strsplit2(rownames(comp.table), ":")
	comp.table$Chr <- chr.pos[,1]
	start.end <- strsplit2(chr.pos[,2], "-")
	comp.table$Start <- as.numeric(start.end[,1])
	comp.table$End <- as.numeric(start.end[,2])

	# make genomic ranges object for annotation
	gr.fc.table <- with(comp.table, GRanges(Chr, IRanges(start=Start, end=End)))
	gr.fc.table$LFC <- comp.table$LFC
	seqlevelsStyle(gr.fc.table) <- "UCSC"
	lfc.ann <- annotatePeak(gr.fc.table, TxDb = txdb, annoDb = "org.Hs.eg.db")
	lfc.ann.table <- as.data.frame(lfc.ann)
	lfc.counts.table <- cbind(comp.table[1:2], lfc.ann.table)
	intron <- which(substr(lfc.counts.table$annotation, 1, 6) == "Intron")
	lfc.counts.table$annotation[intron] <- "Intron"
	exon <- which(substr(lfc.counts.table$annotation, 1, 4) == "Exon")
	lfc.counts.table$annotation[exon] <- "Exon"
	
	write.table(
		lfc.counts.table,
		file.path(fip.dir, paste0(names(comps[comp.i]), '_cnrt_macs_peaks_fip_lfc_pseudocount.txt')),
		sep = '\t',
		col.names = TRUE,
		row.names = FALSE,
		quote = FALSE
		)
}

# now for non-pseudocounts with log2(1+...)
for(comp.i in 1:length(comps)){

	# get each comparison to specify peaks matrix
	comp.x <- comps[[comp.i]][1]
	comp.y <- comps[[comp.i]][2]

	comp.table <- cbind(countsNorm[ , comp.x], countsNorm[ , comp.y])
	colnames(comp.table) <- c(comp.x, comp.y)
	rownames(comp.table) <- rownames(countsNorm)
	# remove those with zeros in both
	keep <- which(rowSums(countsMat[,c(comp.x, comp.y)] >= 5) == 2)
	comp.table <- comp.table[keep, ]
	comp.table <- as.data.frame(comp.table)
	# add lfc
	comp.table$LFC <- log2((1+comp.table[, comp.x])/(1+comp.table[, comp.y]))
	# add coordinates to table
	chr.pos <- strsplit2(rownames(comp.table), ":")
	comp.table$Chr <- chr.pos[,1]
	start.end <- strsplit2(chr.pos[,2], "-")
	comp.table$Start <- as.numeric(start.end[,1])
	comp.table$End <- as.numeric(start.end[,2])

	# make genomic ranges object for annotation
	gr.fc.table <- with(comp.table, GRanges(Chr, IRanges(start=Start, end=End)))
	gr.fc.table$LFC <- comp.table$LFC
	seqlevelsStyle(gr.fc.table) <- "UCSC"
	lfc.ann <- annotatePeak(gr.fc.table, TxDb = txdb, annoDb = "org.Hs.eg.db")
	lfc.ann.table <- as.data.frame(lfc.ann)
	lfc.counts.table <- cbind(comp.table[1:2], lfc.ann.table)
	intron <- which(substr(lfc.counts.table$annotation, 1, 6) == "Intron")
	lfc.counts.table$annotation[intron] <- "Intron"
	exon <- which(substr(lfc.counts.table$annotation, 1, 4) == "Exon")
	lfc.counts.table$annotation[exon] <- "Exon"
	
	write.table(
		lfc.counts.table,
		file.path(fip.dir, paste0(names(comps[comp.i]), '_cnrt_macs_peaks_fip_lfc_1plusnorm.txt')),
		sep = '\t',
		col.names = TRUE,
		row.names = FALSE,
		quote = FALSE
		)
}
```

# make new bivalent genes list from CUT&TAG experiments
```{r}
bi.dir <- file.path(project.dir, "bivalent_genes")
dir.create(bi.dir)

# get k4 and k27 CAS and NT peaks from 2 experiments and annotate
bi.peaks <- c(
  file.path(macs.dir, "MHC-CSCT05-K562-NT2-H3K4me3_S2_aligned_reads_peaks.broadPeak"),
  file.path(macs.dir, "MHC-CSCT05-K562-NT2-H3K27me3_S5_aligned_reads_peaks.broadPeak"),
  "/dawson_genomics/Projects/Menin/CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/cnr_tools_wd/macs2.broad.all.frag.aug18/MHC-CSCT03-K562-CAS-H3K4me3_S2_aligned_reads_peaks.broadPeak",
  "/dawson_genomics/Projects/Menin/CUTandTAG_220201_NB501056_0753_AHLHYCBGXL/cnr_tools_wd/macs2.broad.all.frag.aug18/MHC-CSCT03-K562-CAS-H3K27me3_S6_aligned_reads_peaks.broadPeak"
)

bi.ann.list <- list()

for(peak in bi.peaks){
  bi.peak <- fread(peak)
  # make genomic ranges object for annotation
	bi.gr <- with(bi.peak, GRanges(V1, IRanges(start=V2, end=V3)))
	seqlevelsStyle(bi.gr) <- "UCSC"
	bi.ann <- annotatePeak(bi.gr, TxDb = txdb, annoDb = "org.Hs.eg.db")
	bi.ann.table <- as.data.frame(bi.ann)
	intron <- which(substr(bi.ann.table$annotation, 1, 6) == "Intron")
	bi.ann.table$annotation[intron] <- "Intron"
	exon <- which(substr(bi.ann.table$annotation, 1, 4) == "Exon")
	bi.ann.table$annotation[exon] <- "Exon"
	
	bi.ann.list[[gsub("MHC-CSCT0[3-5]-K562-", "", gsub("_aligned_reads_peaks.broadPeak", "", basename(peak)))]] <- bi.ann.table

	write.table(
		bi.ann.table,
		file.path(bi.dir, paste0(gsub("_aligned_reads_peaks.broadPeak", "", basename(peak)), '_cnrt_macs_peaks_ann_table.txt')),
		sep = '\t',
		col.names = TRUE,
		row.names = FALSE,
		quote = FALSE
		)
}

# limit to regions of interest
keep <- c("Promoter (<=1kb)", "3' UTR", "Intron", "Exon", "5' UTR")
# get genes in both of the k4 samples and both of the k27 samples then intersect
k4.genes <- unique(intersect(
  bi.ann.list$`NT2-H3K4me3_S2`[bi.ann.list$`NT2-H3K4me3_S2`$annotation %in% keep, c("ENSEMBL", "SYMBOL")], 
  bi.ann.list$`CAS-H3K4me3_S2`[bi.ann.list$`CAS-H3K4me3_S2`$annotation %in% keep, c("ENSEMBL", "SYMBOL")]
  ))
k27.genes <- unique(intersect(
  bi.ann.list$`NT2-H3K27me3_S5`[bi.ann.list$`NT2-H3K27me3_S5`$annotation %in% keep, c("ENSEMBL", "SYMBOL")], 
  bi.ann.list$`CAS-H3K27me3_S6`[bi.ann.list$`CAS-H3K27me3_S6`$annotation %in% keep, c("ENSEMBL", "SYMBOL")]
  ))
bi.genes <- intersect(k4.genes, k27.genes)
# remove na for ENSG and symbol
bi.genes <- bi.genes[-1,]

# write out list
write.table(
	bi.genes,
	file.path(bi.dir, "CnT_K562_bivalent_genes.txt"),
	sep = '\t',
	col.names = TRUE,
	row.names = FALSE,
	quote = FALSE
	)

# make list of genes from each sample for christina
k4k27.peaks <- rbind(
  c("NT2-H3K4me3_S2", "peaks"),
  unique(bi.ann.list$`NT2-H3K4me3_S2`[bi.ann.list$`NT2-H3K4me3_S2`$annotation %in% keep, c("ENSEMBL", "SYMBOL")]),
  c("NT2-H3K27me3_S5", "peaks"),
  unique(bi.ann.list$`NT2-H3K27me3_S5`[bi.ann.list$`NT2-H3K27me3_S5`$annotation %in% keep, c("ENSEMBL", "SYMBOL")]),
  c("CAS-H3K4me3_S2", "peaks"),
  unique(bi.ann.list$`CAS-H3K4me3_S2`[bi.ann.list$`CAS-H3K4me3_S2`$annotation %in% keep, c("ENSEMBL", "SYMBOL")]),
  c("CAS-H3K27me3_S6", "peaks"),
  unique(bi.ann.list$`CAS-H3K27me3_S6`[bi.ann.list$`CAS-H3K27me3_S6`$annotation %in% keep, c("ENSEMBL", "SYMBOL")])
)

# remove NA for ENSEMBL as these will not be identified
k4k27.peaks <- k4k27.peaks[-which(is.na(k4k27.peaks$ENSEMBL)),]
# write out to project
write.table(
  k4k27.peaks,
  file.path(bi.dir, "K4_K27_WT_all_peaks.txt"),
  sep = "\t",
  quote = FALSE,
  col.names = FALSE,
  row.names = FALSE
)
```



# make separate matrix for each mark
```{r}
# loop through marks and make a separate list for each
marks <- c("H2AK119", "H3K27me3", "H3K4me3")

# make a list of matrices for all marks
marksMat <- list()

for(mark in marks){
  # make master peak list
  bams <- list.files(align.dir, pattern = paste0(mark, "_S[0-9]{1,2}.sort.bam$"), full.names = TRUE)
  # include only bams for CSCT05 (first 3)
  bams <- bams[1:3]
  
  mPeak <- GRanges()
  for(bam in bams){
    bname <- gsub(".sort.bam", "", basename(bam))
    peakRes = read.table(
      file.path(macs.dir, paste0(bname, "_aligned_reads_peaks.broadPeak")),
      header = FALSE, 
      fill = TRUE
      )
    mPeak = GRanges(seqnames = peakRes$V1, IRanges(start = peakRes$V2, end = peakRes$V3), strand = "*") %>% append(mPeak, .)
  }
  masterPeak = reduce(mPeak)
  
  # get fragment counts for each peak in the master peaks list
  marksMat[[mark]] <- matrix(NA, length(masterPeak), length(bams))
  i <- 1
  for(bam in bams){
    fragment_counts <- chromVAR::getCounts(bam, masterPeak, paired = TRUE, by_rg = FALSE, format = "bam")
    marksMat[[mark]][, i] = counts(fragment_counts)[, 1]
    i = i+1
  }
  
  # add col and row names
  colnames(marksMat[[mark]]) <- gsub("-", "_", gsub("MHC-CSCT0[5-6]-K562-", "", gsub(".sort.bam", "", basename(bams))))
  rownames(marksMat[[mark]]) <- paste0(seqnames(masterPeak), ":", start(masterPeak), "-", end(masterPeak))
  
  # remove zero counts
  keep <- which(rowSums(marksMat[[mark]] > 0) >= 1)
  marksMat[[mark]] <- marksMat[[mark]][keep, ]
  
  # write out counts matrix
  write.table(
    marksMat[[mark]],
    file.path(fip.dir, paste0(mark, "_cnrt_macs_peaks_counts_matrix.txt")),
    sep = "\t",
    row.names = TRUE,
    col.names = NA
    )
}
```


# normalise new matrices as above based on Hg reads
```{r}
marksNorm <- list()
marksNorm$H2AK119 <- as.data.frame(marksMat$H2AK119)
marksNorm$H3K27me3 <- as.data.frame(marksMat$H3K27me3)
marksNorm$H3K4me3 <- as.data.frame(marksMat$H3K4me3)
# also normalise non-pseudocounts by Dm reads, then write out
marksNorm$H2AK119$AEBP2sgRNA_H2AK119_S9 <- (marksNorm$H2AK119$AEBP2sgRNA_H2AK119_S9) * 0.08782995
marksNorm$H3K27me3$AEBP2sgRNA_H3K27me3_S6 <- (marksNorm$H3K27me3$AEBP2sgRNA_H3K27me3_S6) * 0.07862091
marksNorm$H3K4me3$AEBP2sgRNA_H3K4me3_S3 <- (marksNorm$H3K4me3$AEBP2sgRNA_H3K4me3_S3) * 0.1057695
marksNorm$H2AK119$MTF2sgRNA_H2AK119_S10 <- (marksNorm$H2AK119$MTF2sgRNA_H2AK119_S10) * 0.09864343
marksNorm$H3K27me3$MTF2sgRNA_H3K27me3_S7 <- (marksNorm$H3K27me3$MTF2sgRNA_H3K27me3_S7) * 0.08257195
marksNorm$H3K4me3$MTF2sgRNA_H3K4me3_S4 <-(marksNorm$H3K4me3$MTF2sgRNA_H3K4me3_S4) * 0.1104466
marksNorm$H2AK119$NT2_H2AK119_S8 <- (marksNorm$H2AK119$NT2_H2AK119_S8) * 0.07220351
marksNorm$H3K27me3$NT2_H3K27me3_S5 <- (marksNorm$H3K27me3$NT2_H3K27me3_S5) * 0.07253948
marksNorm$H3K4me3$NT2_H3K4me3_S2 <- (marksNorm$H3K4me3$NT2_H3K4me3_S2) * 0.1163419

for(mark in marks){
  write.table(
    marksNorm[[mark]],
    file.path(fip.dir, paste0(mark, "_Norm_cnrt_macs_peaks_counts_matrix.txt")),
    sep = "\t",
    row.names = TRUE,
    col.names = NA
    )
}
```


# get LFC and annotate new frags in peaks
```{r}
# make list of mark comps
mark.comps <- list()
mark.comps[["H2AK119"]] <- list(comps[[1]], comps[[2]])
names(mark.comps[["H2AK119"]]) <- names(comps)[1:2]
mark.comps[["H3K27me3"]] <- list(comps[[3]], comps[[4]])
names(mark.comps[["H3K27me3"]]) <- names(comps)[3:4]
mark.comps[["H3K4me3"]] <- list(comps[[5]], comps[[6]])
names(mark.comps[["H3K4me3"]]) <- names(comps)[5:6]

# only need to do for CSCT05
for(mark in marks){
  
  for(comp.i in 1:2){
  
  	# get each comparison to specify peaks matrix
  	comp.x <- mark.comps[[mark]][[comp.i]][1]
  	comp.y <- mark.comps[[mark]][[comp.i]][2]
  
  	comp.table <- cbind(marksNorm[[mark]][, comp.x], marksNorm[[mark]][, comp.y])
  	colnames(comp.table) <- c(comp.x, comp.y)
  	rownames(comp.table) <- rownames(marksNorm[[mark]])
  	# remove those with zeros in both
  	keep <- which(rowSums(marksMat[[mark]][, c(comp.x, comp.y)] >= 5) == 2)
  	comp.table <- comp.table[keep, ]
  	comp.table <- as.data.frame(comp.table)
  	# add lfc
  	comp.table$LFC <- log2(comp.table[, comp.x]/comp.table[, comp.y])
  	# add coordinates to table
  	chr.pos <- strsplit2(rownames(comp.table), ":")
  	comp.table$Chr <- chr.pos[,1]
  	start.end <- strsplit2(chr.pos[,2], "-")
  	comp.table$Start <- as.numeric(start.end[,1])
  	comp.table$End <- as.numeric(start.end[,2])
  
  	# make genomic ranges object for annotation
  	gr.fc.table <- with(comp.table, GRanges(Chr, IRanges(start=Start, end=End)))
  	gr.fc.table$LFC <- comp.table$LFC
  	seqlevelsStyle(gr.fc.table) <- "UCSC"
  	lfc.ann <- annotatePeak(gr.fc.table, TxDb = txdb, annoDb = "org.Hs.eg.db")
  	lfc.ann.table <- as.data.frame(lfc.ann)
  	lfc.counts.table <- cbind(comp.table[1:2], lfc.ann.table)
  	intron <- which(substr(lfc.counts.table$annotation, 1, 6) == "Intron")
  	lfc.counts.table$annotation[intron] <- "Intron"
  	exon <- which(substr(lfc.counts.table$annotation, 1, 4) == "Exon")
  	lfc.counts.table$annotation[exon] <- "Exon"
  	
  	write.table(
  		lfc.counts.table,
  		file.path(fip.dir, paste0(names(mark.comps[[mark]])[comp.i], '_cnrt_macs_Norm_Mark_Peaks_fip_lfc.txt')),
  		sep = '\t',
  		col.names = TRUE,
  		row.names = FALSE,
  		quote = FALSE
  		)
  }
}
```


# boxplot of menin vs not and bivalent vs not for each comparison, using lfc of fip from cnrt macs output
```{r}
library(data.table)

plots.dir <- file.path(project.dir, "plots")
dir.create(plots.dir)

# read in K562 bivalent gene
#bivalent <- scan("/dawson_genomics/Projects/Menin/ChIPseq_combined_200320_210422_210623/sample_info/K562_bivalent_genes.txt", what = "character")
# remake plots with new bivalent list
bivalent <- fread(file.path(bi.dir, "CnT_K562_bivalent_genes.txt"))
menin <- fread("/dawson_genomics/Projects/Menin/ChIPseq_200320_NB501056_0470_AH5NJJBGXF/scripts/MeninGenes.bed")

# put lfc table data into list for further plots
lfc.table.list <- list()
for(comp.i in 1:length(comps)){
  lfc.table <- fread(file.path(fip.dir, paste0(names(comps)[comp.i], '_cnrt_macs_peaks_fip_lfc_1plusnorm.txt')))
  lfc.table.list[[names(comps)[comp.i]]] <- lfc.table
}

# make comps list for each mark as plots will be different
k4.comps <- c("AEBP2sgRNAvNT2_H3K4me3", "MTF2sgRNAvNT2_H3K4me3", "MLL1_2KOvCAS_EZH2i_H3K4me3", "MLL1_2KOvCAS_EZH2i_IFN_H3K4me3")
k27.comps <- c("AEBP2sgRNAvNT2_H3K27me3", "MTF2sgRNAvNT2_H3K27me3")

for(comp in k4.comps[1:2]){
  fip.table <- fread(file.path(fip.dir, paste0(comp, '_cnrt_macs_Norm_Mark_Peaks_fip_lfc.txt')))
  ### DEPRECATED minds changed re TSS
  # limit to TSS +/- 500bp
  #lfc.table <- subset(lfc.table, distanceToTSS >= -500 & distanceToTSS <= 500)
  # instead limit to regions of interest
  keep <- c("Promoter (<=1kb)", "3' UTR", "Intron", "Exon", "5' UTR")
  # keep only reads and ensg 
  lfc.table <- fip.table[fip.table$annotation %in% keep, c(1, 2, 18)]
  # make table of data for figure by summing reads in peaks for each gene and getting LFC for total
  lfc.table <- lfc.table %>% group_by(ENSEMBL) %>% summarize_all(sum)
  lfc.table <- as.data.frame(lfc.table[-which(is.na(lfc.table$ENSEMBL)), ])
  # filter for at least 1 read per million in both
  keep <- which(lfc.table[,2] >= 1 & lfc.table[,3] >= 1)
  lfc.table <- lfc.table[keep,]
  # get new LFC cols 1:2 move to 2:3 in above manipulation
  lfc.table$LFC <- log2((lfc.table[,2])/(lfc.table[,3]))
  men.data <- lfc.table[lfc.table$ENSEMBL %in% menin$V4,]
  not.men.data <- lfc.table[!(lfc.table$ENSEMBL %in% menin$V4),]
  men.bi.data <- men.data[men.data$ENSEMBL %in% bivalent$ENSEMBL,]
  men.not.bi.data <- men.data[!(men.data$ENSEMBL %in% bivalent$ENSEMBL),]
  not.men.bi.data <- not.men.data[not.men.data$ENSEMBL %in% bivalent$ENSEMBL,]
  not.men.not.bi.data <- not.men.data[!(not.men.data$ENSEMBL %in% bivalent$ENSEMBL),]
  pdf(file.path(plots.dir, paste0("Boxplot_normnopsuedo_", comp, "_MarkPeaks.pdf")))
  boxplot(
    not.men.not.bi.data$LFC, not.men.bi.data$LFC, men.not.bi.data$LFC, men.bi.data$LFC,
    names = c("non-Menin\n not bivalent", "non-Menin\n bivalent", "Menin\n not bivalent", "Menin\n bivalent"),
    main = paste0(comp, " binding"),
    ylab = expression(bold(paste("log"[2], " FC"))),
    col = c("gray30", "deeppink3", "gray90", "deepskyblue2"),
    at = c(1, 2, 4, 5),
    boxwex = 0.5,
    outline = FALSE,
    #ylim = c(-2.5, 2.5),
    #notch = TRUE,
    whisklty = 1
  )
  dev.off()
  
  
  # now make waterfall plot
  bar.not.men.not.bi <- not.men.not.bi.data[, "LFC"]
  bar.not.men.bi <- not.men.bi.data[, "LFC"]
  bar.men.not.bi <- men.not.bi.data[, "LFC"]
  bar.men.bi <- men.bi.data[, "LFC"]
  pdf(file.path(plots.dir, paste0("Waterfall_", comp, "_1RPMfilt_MarkPeaks.pdf")))
  #par(mfrow=c(4,1))
  barplot(
    bar.not.men.not.bi[order(bar.not.men.not.bi, decreasing = TRUE)], 
    col = "gray30", 
    border = "gray30", 
    #space=0.5, 
    #ylim=c(-100,100),
    main = paste0(comp, " non-Menin, non-bivalent genes"), 
    ylab = expression(bold(paste("log"[2], " FC"))),
    cex.axis = 1.2, 
    cex.lab = 1.4
    )
  barplot(
    bar.not.men.bi[order(bar.not.men.bi, decreasing = TRUE)], 
    col = "deeppink3", 
    border = "deeppink3", 
    #space=0.5, 
    #ylim=c(-100,100),
    main = paste0(comp, " non-Menin, bivalent genes"), 
    ylab = expression(bold(paste("log"[2], " FC"))),
    cex.axis = 1.2, 
    cex.lab = 1.4
    )
  barplot(
    bar.men.not.bi[order(bar.men.not.bi, decreasing = TRUE)], 
    col = "gray90", 
    border = "gray90", 
    #space=0.5, 
    #ylim=c(-100,100),
    main = paste0(comp, " Menin, non-bivalent genes"), 
    ylab = expression(bold(paste("log"[2], " FC"))),
    cex.axis = 1.2, 
    cex.lab = 1.4
    )
  barplot(
    bar.men.bi[order(bar.men.bi, decreasing = TRUE)], 
    col = "deepskyblue2", 
    border = "deepskyblue2", 
    #space=0.5, 
    #ylim=c(-100,100),
    main = paste0(comp, " Menin, bivalent genes"), 
    ylab = expression(bold(paste("log"[2], " FC"))),
    cex.axis = 1.2, 
    cex.lab = 1.4
    )
  dev.off()
  
  # make overlapping barplots of reads in WT and KO
  read.bar.not.men.not.bi <- t(not.men.not.bi.data[order(not.men.not.bi.data[,2], decreasing = TRUE), 2:3])
  read.bar.not.men.bi <- t(not.men.bi.data[order(not.men.bi.data[,2], decreasing = TRUE), 2:3])
  read.bar.men.not.bi <- t(men.not.bi.data[order(men.not.bi.data[,2], decreasing = TRUE), 2:3])
  read.bar.men.bi <- t(men.bi.data[order(men.bi.data[,2], decreasing = TRUE), 2:3])
  pdf(file.path(plots.dir, paste0("Reads_bar_KOord_", comp, "_1RPMfilt_MarkPeaks.pdf")), width = 36, height = 8)
  #par(mar = c(4, 4, 2, 2), xpd = TRUE)
  barplot(
    read.bar.not.men.not.bi, 
    col = c("gray30", "wheat3"), 
    border = c("gray30", "wheat3"), 
    xlab = "Genes", 
    ylab = "Reads in Peaks",
    main = paste0(comp, " non-Menin, non-bivalent genes"),
    beside = TRUE,
    axisnames = FALSE,
    bty = "L"
    )
  legend("topright", legend = c("KO", "WT"), fill = c("gray30", "wheat3"))
  barplot(
    read.bar.not.men.bi, 
    col = c("deeppink3", "wheat3"), 
    border = c("deeppink3", "wheat3"), 
    xlab = "Genes", 
    ylab = "Reads in Peaks",
    main = paste0(comp, " non-Menin, bivalent genes"),
    beside = TRUE,
    axisnames = FALSE,
    bty = "L"
    )
  legend("topright", legend = c("KO", "WT"), fill = c("deeppink3", "wheat3"))
  barplot(
    read.bar.men.not.bi, 
    col = c("gray90", "wheat3"), 
    border = c("gray90", "wheat3"), 
    xlab = "Genes", 
    ylab = "Reads in Peaks",
    main = paste0(comp, " Menin, non-bivalent genes"),
    beside = TRUE,
    axisnames = FALSE,
    bty = "L"
    )
  legend("topright", legend = c("KO", "WT"), fill = c("gray90", "wheat3"))
  barplot(
    read.bar.men.bi, 
    col = c("deepskyblue2", "wheat3"), 
    border = c("deepskyblue2", "wheat3"), 
    xlab = "Genes", 
    ylab = "Reads in Peaks",
    main = paste0(comp, " Menin, bivalent genes"),
    beside = TRUE,
    axisnames = FALSE,
    bty = "L"
    )
  legend("topright", legend = c("KO", "WT"), fill = c("deepskyblue2", "wheat3"))
  dev.off()
  
  # make scatterplot of |LFC| vs reads to show correlation
  lfc.table$totalReads <- rowSums(lfc.table[, 2:3])
  pdf(file.path(plots.dir, paste0("Scatter_", comp, "_1RPMfilt_MarkPeaks.pdf")))
  plot(
    lfc.table$totalReads,
    abs(lfc.table$LFC), 
    main = paste0(comp, " reads v |LFC| correlation"), 
    col = rgb(0, 100, 0, 50, maxColorValue = 255),
    xlab = "Total reads (KO + WT)", 
    ylab = expression(bold(paste("Absolute value of log"[2], " FC"))),
    pch = 16
    )
  #abline(lm(abs(lfc.table$LFC) ~ lfc.table$totalReads), col = "red", lwd = 3)
  #text(paste("Correlation:", round(cor(lfc.table$totalReads, abs(lfc.table$LFC)), 2)), x = 25, y = 95)
  dev.off()
}

for(comp in k27.comps){
  fip.table <- fread(file.path(fip.dir, paste0(comp, '_cnrt_macs_Norm_Mark_Peaks_fip_lfc.txt')))
  # limit to regions of interest
  keep <- c("Promoter (<=1kb)", "3' UTR", "Intron", "Exon", "5' UTR")
  # keep only reads and ensg 
  lfc.table <- fip.table[fip.table$annotation %in% keep, c(1, 2, 18)]
  # make table of data for figure by summing reads in peaks for each gene and getting LFC for total
  lfc.table <- lfc.table %>% group_by(ENSEMBL) %>% summarize_all(sum)
  lfc.table <- as.data.frame(lfc.table[-is.na(lfc.table$ENSEMBL), ])
  # filter for at least 1 read per million in both
  keep <- which(lfc.table[,2] >= 1 & lfc.table[,3] >= 1)
  lfc.table <- lfc.table[keep,]
  # get new LFC cols 1:2 move to 2:3 in above manipulation
  lfc.table$LFC <- log2(lfc.table[,2]/lfc.table[,3])
  men.data <- lfc.table[lfc.table$ENSEMBL %in% menin$V4,]
  not.men.data <- lfc.table[!(lfc.table$ENSEMBL %in% menin$V4),]
  men.bi.data <- men.data[men.data$ENSEMBL %in% bivalent$ENSEMBL,]
  men.not.bi.data <- men.data[!(men.data$ENSEMBL %in% bivalent$ENSEMBL),]
  not.men.bi.data <- not.men.data[not.men.data$ENSEMBL %in% bivalent$ENSEMBL,]
  not.men.not.bi.data <- not.men.data[!(not.men.data$ENSEMBL %in% bivalent$ENSEMBL),]
  pdf(file.path(plots.dir, paste0("Boxplot_normnopseudo_", comp, "_MarkPeaks.pdf")))
  boxplot(
    not.men.not.bi.data$LFC, not.men.bi.data$LFC, men.not.bi.data$LFC, men.bi.data$LFC,
    names = c("non-Menin\n not bivalent", "non-Menin\n bivalent", "Menin\n not bivalent", "Menin\n bivalent"),
    main = paste0(comp, " binding"),
    ylab = expression(bold(paste("log"[2], " FC"))),
    col = c("gray30", "deeppink3", "gray90", "deepskyblue2"),
    at = c(1, 2, 4, 5),
    boxwex = 0.5,
    outline = FALSE,
    #ylim = c(-2.5, 2.5),
    #notch = TRUE,
    whisklty = 1
  )
  dev.off()
  
  
  # now make waterfall plot
  bar.not.men.not.bi <- not.men.not.bi.data[, "LFC"]
  bar.not.men.bi <- not.men.bi.data[, "LFC"]
  bar.men.not.bi <- men.not.bi.data[, "LFC"]
  bar.men.bi <- men.bi.data[, "LFC"]
  pdf(file.path(plots.dir, paste0("Waterfall_", comp, "_1RPMfilt_MarkPeaks.pdf")))
  #par(mfrow=c(4,1))
  barplot(
    bar.not.men.not.bi[order(bar.not.men.not.bi, decreasing = TRUE)], 
    col = "gray30", 
    border = "gray30", 
    #space=0.5, 
    #ylim=c(-100,100),
    main = paste0(comp, " non-Menin, non-bivalent genes"), 
    ylab = expression(bold(paste("log"[2], " FC"))),
    cex.axis = 1.2, 
    cex.lab = 1.4
    )
  barplot(
    bar.not.men.bi[order(bar.not.men.bi, decreasing = TRUE)], 
    col = "deeppink3", 
    border = "deeppink3", 
    #space=0.5, 
    #ylim=c(-100,100),
    main = paste0(comp, " non-Menin, bivalent genes"), 
    ylab = expression(bold(paste("log"[2], " FC"))),
    cex.axis = 1.2, 
    cex.lab = 1.4
    )
  barplot(
    bar.men.not.bi[order(bar.men.not.bi, decreasing = TRUE)], 
    col = "gray90", 
    border = "gray90", 
    #space=0.5, 
    #ylim=c(-100,100),
    main = paste0(comp, " Menin, non-bivalent genes"), 
    ylab = expression(bold(paste("log"[2], " FC"))),
    cex.axis = 1.2, 
    cex.lab = 1.4
    )
  barplot(
    bar.men.bi[order(bar.men.bi, decreasing = TRUE)], 
    col = "deepskyblue2", 
    border = "deepskyblue2", 
    #space=0.5, 
    #ylim=c(-100,100),
    main = paste0(comp, " Menin, bivalent genes"), 
    ylab = expression(bold(paste("log"[2], " FC"))),
    cex.axis = 1.2, 
    cex.lab = 1.4
    )
  dev.off()
  
  # make overlapping barplots of reads in WT and KO
  read.bar.not.men.not.bi <- t(not.men.not.bi.data[order(not.men.not.bi.data[,2], decreasing = TRUE), 2:3])
  read.bar.not.men.bi <- t(not.men.bi.data[order(not.men.bi.data[,2], decreasing = TRUE), 2:3])
  read.bar.men.not.bi <- t(men.not.bi.data[order(men.not.bi.data[,2], decreasing = TRUE), 2:3])
  read.bar.men.bi <- t(men.bi.data[order(men.bi.data[,2], decreasing = TRUE), 2:3])
  pdf(file.path(plots.dir, paste0("Reads_bar_KOord_", comp, "_1RPMfilt_MarkPeaks.pdf")), width = 36, height = 8)
  #par(mar = c(4, 4, 2, 2), xpd = TRUE)
  barplot(
    read.bar.not.men.not.bi, 
    col = c("gray30", "wheat3"), 
    border = c("gray30", "wheat3"), 
    xlab = "Genes", 
    ylab = "Reads in Peaks",
    main = paste0(comp, " non-Menin, non-bivalent genes"),
    beside = TRUE,
    axisnames = FALSE,
    bty = "L"
    )
  legend("topright", legend = c("KO", "WT"), fill = c("gray30", "wheat3"))
  barplot(
    read.bar.not.men.bi, 
    col = c("deeppink3", "wheat3"), 
    border = c("deeppink3", "wheat3"), 
    xlab = "Genes", 
    ylab = "Reads in Peaks",
    main = paste0(comp, " non-Menin, bivalent genes"),
    beside = TRUE,
    axisnames = FALSE,
    bty = "L"
    )
  legend("topright", legend = c("KO", "WT"), fill = c("deeppink3", "wheat3"))
  barplot(
    read.bar.men.not.bi, 
    col = c("gray90", "wheat3"), 
    border = c("gray90", "wheat3"), 
    xlab = "Genes", 
    ylab = "Reads in Peaks",
    main = paste0(comp, " Menin, non-bivalent genes"),
    beside = TRUE,
    axisnames = FALSE,
    bty = "L"
    )
  legend("topright", legend = c("KO", "WT"), fill = c("gray90", "wheat3"))
  barplot(
    read.bar.men.bi, 
    col = c("deepskyblue2", "wheat3"), 
    border = c("deepskyblue2", "wheat3"), 
    xlab = "Genes", 
    ylab = "Reads in Peaks",
    main = paste0(comp, " Menin, bivalent genes"),
    beside = TRUE,
    axisnames = FALSE,
    bty = "L"
    )
  legend("topright", legend = c("KO", "WT"), fill = c("deepskyblue2", "wheat3"))
  dev.off()
  
  # make scatterplot of |LFC| vs reads to show correlation
  lfc.table$totalReads <- rowSums(lfc.table[, 2:3])
  pdf(file.path(plots.dir, paste0("Scatter_", comp, "_1RPMfilt_MarkPeaks.pdf")))
  plot(
    lfc.table$totalReads,
    abs(lfc.table$LFC), 
    main = paste0(comp, " reads v |LFC| correlation"), 
    col = rgb(0, 100, 0, 50, maxColorValue = 255),
    xlab = "Total reads (KO + WT)", 
    ylab = expression(bold(paste("Absolute value of log"[2], " FC"))),
    pch = 16
    )
  #abline(lm(abs(lfc.table$LFC) ~ lfc.table$totalReads), col = "red", lwd = 3)
  #text(paste("Correlation:", round(cor(lfc.table$totalReads, abs(lfc.table$LFC)), 2)), x = 25, y = 95)
  dev.off()
}

# now do same for lfc(1+...) data
for(comp in k4.comps){
  fip.table <- fread(file.path(fip.dir, paste0(comp, '_cnrt_macs_peaks_fip_lfc_1plusnorm.txt')))
  ### DEPRECATED minds changed re TSS
  # limit to TSS +/- 500bp
  #lfc.table <- subset(lfc.table, distanceToTSS >= -500 & distanceToTSS <= 500)
  # instead limit to regions of interest
  keep <- c("Promoter (<=1kb)", "3' UTR", "Intron", "Exon", "5' UTR")
  # keep only reads and ensg 
  lfc.table <- fip.table[fip.table$annotation %in% keep, c(1, 2, 18)]
  # make table of data for figure by summing reads in peaks for each gene and getting LFC for total
  lfc.table <- lfc.table %>% group_by(ENSEMBL) %>% summarize_all(sum)
  lfc.table <- as.data.frame(lfc.table[-which(is.na(lfc.table$ENSEMBL)), ])
  # get new LFC cols 1:2 move to 2:3 in above manipulation
  lfc.table$LFC <- log2((1+lfc.table[,2])/(1+lfc.table[,3]))
  men.data <- lfc.table[lfc.table$ENSEMBL %in% menin$V4,]
  not.men.data <- lfc.table[!(lfc.table$ENSEMBL %in% menin$V4),]
  men.bi.data <- men.data[men.data$ENSEMBL %in% bivalent$ENSEMBL,]
  men.not.bi.data <- men.data[!(men.data$ENSEMBL %in% bivalent$ENSEMBL),]
  not.men.bi.data <- not.men.data[not.men.data$ENSEMBL %in% bivalent$ENSEMBL,]
  not.men.not.bi.data <- not.men.data[!(not.men.data$ENSEMBL %in% bivalent$ENSEMBL),]
  pdf(file.path(plots.dir, paste0("Boxplot_1plusnorm_", comp, "_cnrt_macs_peaks.pdf")))
  boxplot(
    not.men.not.bi.data$LFC, not.men.bi.data$LFC, men.not.bi.data$LFC, men.bi.data$LFC,
    names = c("non-Menin\n not bivalent", "non-Menin\n bivalent", "Menin\n not bivalent", "Menin\n bivalent"),
    main = paste0(comp, " binding"),
    ylab = expression(bold(paste("log"[2], " FC"))),
    col = c("gray30", "deeppink3", "gray90", "deepskyblue2"),
    at = c(1, 2, 4, 5),
    boxwex = 0.5,
    outline = FALSE,
    #ylim = c(-2.5, 2.5),
    #notch = TRUE,
    whisklty = 1
  )
  dev.off()
}

for(comp in k27.comps){
  fip.table <- fread(file.path(fip.dir, paste0(comp, '_cnrt_macs_peaks_fip_lfc_1plusnorm.txt')))
  # limit to regions of interest
  keep <- c("Promoter (<=1kb)", "3' UTR", "Intron", "Exon", "5' UTR")
  # keep only reads and ensg 
  lfc.table <- fip.table[fip.table$annotation %in% keep, c(1, 2, 18)]
  # make table of data for figure by summing reads in peaks for each gene and getting LFC for total
  lfc.table <- lfc.table %>% group_by(ENSEMBL) %>% summarize_all(sum)
  lfc.table <- as.data.frame(lfc.table[-which(is.na(lfc.table$ENSEMBL)), ])
  # get new LFC cols 1:2 move to 2:3 in above manipulation
  lfc.table$LFC <- log2((1+lfc.table[,2])/(1+lfc.table[,3]))
  men.data <- lfc.table[lfc.table$ENSEMBL %in% menin$V4,]
  not.men.data <- lfc.table[!(lfc.table$ENSEMBL %in% menin$V4),]
  men.bi.data <- men.data[men.data$ENSEMBL %in% bivalent$ENSEMBL,]
  men.not.bi.data <- men.data[!(men.data$ENSEMBL %in% bivalent$ENSEMBL),]
  not.men.bi.data <- not.men.data[not.men.data$ENSEMBL %in% bivalent$ENSEMBL,]
  not.men.not.bi.data <- not.men.data[!(not.men.data$ENSEMBL %in% bivalent$ENSEMBL),]
  pdf(file.path(plots.dir, paste0("Boxplot_1plusnorm_", comp, "_cnrt_macs_peaks.pdf")))
  boxplot(
    not.men.not.bi.data$LFC, not.men.bi.data$LFC, men.not.bi.data$LFC, men.bi.data$LFC,
    names = c("non-Menin\n not bivalent", "non-Menin\n bivalent", "Menin\n not bivalent", "Menin\n bivalent"),
    main = paste0(comp, " binding"),
    ylab = expression(bold(paste("log"[2], " FC"))),
    col = c("gray30", "deeppink3", "gray90", "deepskyblue2"),
    at = c(1, 2, 4, 5),
    boxwex = 0.5,
    outline = FALSE,
    #ylim = c(-2.5, 2.5),
    #notch = TRUE,
    whisklty = 1
  )
  dev.off()
}
```


# use bdgdiff to compare peaks, using output from cnrtools macs broadpeaks
```{bash}
# run for cnrtools dir
cd cnr_tools_wd
mkdir bdgdiff_macs2_broad

# no d1/d2 needed for samples run with cnrtools
sbatch ../scripts/bdgdiff.sbatch macs2.broad.all.frag.aug18/MHC-CSCT05-K562-AEBP2sgRNA-H3K4me3_S3_aligned_reads_treat_pileup.bdg macs2.broad.all.frag.aug18/MHC-CSCT05-K562-AEBP2sgRNA-H3K4me3_S3_aligned_reads_control_lambda.bdg macs2.broad.all.frag.aug18/MHC-CSCT05-K562-NT2-H3K4me3_S2_aligned_reads_treat_pileup.bdg macs2.broad.all.frag.aug18/MHC-CSCT05-K562-NT2-H3K4me3_S2_aligned_reads_control_lambda.bdg diff_AEBP2sgRNAvNT2_H3K4me3 bdgdiff_macs2_broad

sbatch ../scripts/bdgdiff.sbatch macs2.broad.all.frag.aug18/MHC-CSCT05-K562-MTF2sgRNA-H3K4me3_S4_aligned_reads_treat_pileup.bdg macs2.broad.all.frag.aug18/MHC-CSCT05-K562-MTF2sgRNA-H3K4me3_S4_aligned_reads_control_lambda.bdg macs2.broad.all.frag.aug18/MHC-CSCT05-K562-NT2-H3K4me3_S2_aligned_reads_treat_pileup.bdg macs2.broad.all.frag.aug18/MHC-CSCT05-K562-NT2-H3K4me3_S2_aligned_reads_control_lambda.bdg diff_MTF2sgRNAvNT2_H3K4me3 bdgdiff_macs2_broad

sbatch ../scripts/bdgdiff.sbatch macs2.broad.all.frag.aug18/MHC-CSCT05-K562-AEBP2sgRNA-H3K27me3_S6_aligned_reads_treat_pileup.bdg macs2.broad.all.frag.aug18/MHC-CSCT05-K562-AEBP2sgRNA-H3K27me3_S6_aligned_reads_control_lambda.bdg macs2.broad.all.frag.aug18/MHC-CSCT05-K562-NT2-H3K27me3_S5_aligned_reads_treat_pileup.bdg macs2.broad.all.frag.aug18/MHC-CSCT05-K562-NT2-H3K27me3_S5_aligned_reads_control_lambda.bdg diff_AEBP2sgRNAvNT2_H3K27me3 bdgdiff_macs2_broad

sbatch ../scripts/bdgdiff.sbatch macs2.broad.all.frag.aug18/MHC-CSCT05-K562-MTF2sgRNA-H3K27me3_S7_aligned_reads_treat_pileup.bdg macs2.broad.all.frag.aug18/MHC-CSCT05-K562-MTF2sgRNA-H3K27me3_S7_aligned_reads_control_lambda.bdg macs2.broad.all.frag.aug18/MHC-CSCT05-K562-NT2-H3K27me3_S5_aligned_reads_treat_pileup.bdg macs2.broad.all.frag.aug18/MHC-CSCT05-K562-NT2-H3K27me3_S5_aligned_reads_control_lambda.bdg diff_MTF2sgRNAvNT2_H3K27me3 bdgdiff_macs2_broad

sbatch ../scripts/bdgdiff.sbatch macs2.broad.all.frag.aug18/MHC-CSCT05-K562-AEBP2sgRNA-H2AK119_S9_aligned_reads_treat_pileup.bdg macs2.broad.all.frag.aug18/MHC-CSCT05-K562-AEBP2sgRNA-H2AK119_S9_aligned_reads_control_lambda.bdg macs2.broad.all.frag.aug18/MHC-CSCT05-K562-NT2-H2AK119_S8_aligned_reads_treat_pileup.bdg macs2.broad.all.frag.aug18/MHC-CSCT05-K562-NT2-H2AK119_S8_aligned_reads_control_lambda.bdg diff_AEBP2sgRNAvNT2_H2AK119 bdgdiff_macs2_broad

sbatch ../scripts/bdgdiff.sbatch macs2.broad.all.frag.aug18/MHC-CSCT05-K562-MTF2sgRNA-H2AK119_S10_aligned_reads_treat_pileup.bdg macs2.broad.all.frag.aug18/MHC-CSCT05-K562-MTF2sgRNA-H2AK119_S10_aligned_reads_control_lambda.bdg macs2.broad.all.frag.aug18/MHC-CSCT05-K562-NT2-H2AK119_S8_aligned_reads_treat_pileup.bdg macs2.broad.all.frag.aug18/MHC-CSCT05-K562-NT2-H2AK119_S8_aligned_reads_control_lambda.bdg diff_MTF2sgRNAvNT2_H2AK119 bdgdiff_macs2_broad


sbatch ../scripts/bdgdiff.sbatch macs2.broad.all.frag.aug18/MHC-CSCT06-K562-MLL1-2ko-EZH2i-H3K4me3_S14_aligned_reads_treat_pileup.bdg macs2.broad.all.frag.aug18/MHC-CSCT06-K562-MLL1-2ko-EZH2i-H3K4me3_S14_aligned_reads_control_lambda.bdg macs2.broad.all.frag.aug18/MHC-CSCT06-K562-CAS-EZH2i-H3K4me3_S12_aligned_reads_treat_pileup.bdg macs2.broad.all.frag.aug18/MHC-CSCT06-K562-CAS-EZH2i-H3K4me3_S12_aligned_reads_control_lambda.bdg diff_MLL1_2kovCAS_EZH2i_H3K4me3 bdgdiff_macs2_broad

sbatch ../scripts/bdgdiff.sbatch macs2.broad.all.frag.aug18/MHC-CSCT06-K562-MLL1-2ko-EZH2i-IFN-H3K4me3_S15_aligned_reads_treat_pileup.bdg macs2.broad.all.frag.aug18/MHC-CSCT06-K562-MLL1-2ko-EZH2i-IFN-H3K4me3_S15_aligned_reads_control_lambda.bdg macs2.broad.all.frag.aug18/MHC-CSCT06-K562-CAS-EZH2i-IFN-H3K4me3_S13_aligned_reads_treat_pileup.bdg macs2.broad.all.frag.aug18/MHC-CSCT06-K562-CAS-EZH2i-IFN-H3K4me3_S13_aligned_reads_control_lambda.bdg diff_MLL1_2kovCAS_EZH2i_IFN_H3K4me3 bdgdiff_macs2_broad
```

# annotate diff peaks files
```{r}
cnr.diff.dir <- file.path(cnrt.dir, "bdgdiff_macs2_broad")

# set comparisons and conditions for file names
conds <- c("common", "cond1", "cond2")

for(comp.i in 1:length(comps)){
  for(cond.j in 1:3){
    # read in each file to annotate, rewrite, subset and write
    diff.table <- fread(file.path(cnr.diff.dir, paste0("diff_", names(comps)[comp.i], "_c3.0_", conds[cond.j], ".bed")), skip = 1)
  	# make genomic ranges object for annotation
  	gr.diff <- with(diff.table, GRanges(V1, IRanges(start = V2, end = V3)))
  	gr.diff$logLikelihood <- diff.table$V5
  	seqlevelsStyle(gr.diff) <- "UCSC"
  	diff.ann <- annotatePeak(gr.diff, TxDb = txdb, annoDb = "org.Hs.eg.db")
  	diff.ann.table <- as.data.frame(diff.ann)
  	
  	# rename exons and introns for ease of selection
  	intron <- which(substr(diff.ann.table$annotation, 1, 6) == "Intron")
  	diff.ann.table$annotation[intron] <- "Intron"
  	exon <- which(substr(diff.ann.table$annotation, 1, 4) == "Exon")
  	diff.ann.table$annotation[exon] <- "Exon"
  
  	write.table(
  		diff.ann.table,
  		file.path(cnr.diff.dir, paste0("diff_", names(comps)[comp.i], "_c3.0_", conds[cond.j], ".bed")),
  		sep = '\t',
  		col.names = TRUE,
  		row.names = FALSE,
  		quote = FALSE
  		)
  }
}
```

# make plots with CnRtools output bdgdiff data
```{r}
for(comp.i in 1:length(k4.comps)){
  bar.data <- data.table(matrix(nrow = 2, ncol = 4))
  colnames(bar.data) <- c("nmnb", "nmb", "mnb", "mb")
  up.peaks <- fread(file.path(cnr.diff.dir, paste0("diff_", k4.comps[comp.i], "_c3.0_cond1.bed")))
  down.peaks <- fread(file.path(cnr.diff.dir, paste0("diff_", k4.comps[comp.i], "_c3.0_cond2.bed")))
  # limit to TSS +/- 500bp
  up.peaks <- subset(up.peaks, distanceToTSS >= -500 & distanceToTSS <= 500)
  down.peaks <- subset(down.peaks, distanceToTSS >= -500 & distanceToTSS <= 500)
  men.up <- up.peaks[up.peaks$ENSEMBL %in% menin$V4,]
  not.men.up <- up.peaks[!(up.peaks$ENSEMBL %in% menin$V4),]
  men.down <- down.peaks[down.peaks$ENSEMBL %in% menin$V4,]
  not.men.down <- down.peaks[!(down.peaks$ENSEMBL %in% menin$V4),]
  men.bi.up <- men.up[men.up$ENSEMBL %in% bivalent$ENSEMBL,]
  men.not.bi.up <- men.up[!(men.up$ENSEMBL %in% bivalent$ENSEMBL),]
  not.men.bi.up <- not.men.up[not.men.up$ENSEMBL %in% bivalent$ENSEMBL,]
  not.men.not.bi.up <- not.men.up[!(not.men.up$ENSEMBL %in% bivalent$ENSEMBL),]
  men.bi.down <- men.down[men.down$ENSEMBL %in% bivalent$ENSEMBL,]
  men.not.bi.down <- men.down[!(men.down$ENSEMBL %in% bivalent$ENSEMBL),]
  not.men.bi.down <- not.men.down[not.men.down$ENSEMBL %in% bivalent$ENSEMBL,]
  not.men.not.bi.down <- not.men.down[!(not.men.down$ENSEMBL %in% bivalent$ENSEMBL),]
  # use proportions for barplot
  bar.data$nmnb <- rbind(nrow(not.men.not.bi.up)/sum(nrow(not.men.not.bi.up), nrow(not.men.not.bi.down)), nrow(not.men.not.bi.down)/sum(nrow(not.men.not.bi.up), nrow(not.men.not.bi.down)))
  bar.data$nmb <- rbind(nrow(not.men.bi.up)/sum(nrow(not.men.bi.up), nrow(not.men.bi.down)), nrow(not.men.bi.down)/sum(nrow(not.men.bi.up), nrow(not.men.bi.down)))
  bar.data$mnb <- rbind(nrow(men.not.bi.up)/sum(nrow(men.not.bi.up), nrow(men.not.bi.down)), nrow(men.not.bi.down)/sum(nrow(men.not.bi.up), nrow(men.not.bi.down)))
  bar.data$mb <- rbind(nrow(men.bi.up)/sum(nrow(men.bi.up), nrow(men.bi.down)), nrow(men.bi.down)/sum(nrow(men.bi.up), nrow(men.bi.down)))
  bar.matrix <- as.matrix(bar.data)
  rownames(bar.matrix) <- c("up", "down")
  colnames(bar.matrix) <- c("non-Menin\n not bivalent", "non-Menin\n bivalent", "Menin\n not bivalent", "Menin\n bivalent")
  pdf(file.path(plots.dir, paste0("prop_bar_", k4.comps[comp.i], ".pdf")))
  par(mar = c(5, 4, 2, 6), xpd = TRUE)
  bp <- barplot(
    bar.matrix, 
    col = c("indianred1", "dodgerblue"), 
    border = "white", 
    xlab = k4.comps[comp.i], 
    ylab = "Proportion",
    bty = "L"
    )
  # text on top (down peaks)
  text(bp, 1, c(nrow(not.men.not.bi.down), nrow(not.men.bi.down), nrow(men.not.bi.down), nrow(men.bi.down)), cex = 1.2, pos = 1)
  # text on bottom (up peaks)
  text(bp, 0, c(nrow(not.men.not.bi.up), nrow(not.men.bi.up), nrow(men.not.bi.up), nrow(men.bi.up)), cex = 1.2, pos = 3)
  legend("topright", legend = c("Up", "Down"), fill = c("indianred1", "dodgerblue"), inset = c(-0.2, 0))
  dev.off()
}

for(comp.i in 1:length(k27.comps)){
  bar.data <- data.table(matrix(nrow = 2, ncol = 4))
  colnames(bar.data) <- c("nmnb", "nmb", "mnb", "mb")
  up.peaks <- fread(file.path(cnr.diff.dir, paste0("diff_", k27.comps[comp.i], "_c3.0_cond1.bed")))
  down.peaks <- fread(file.path(cnr.diff.dir, paste0("diff_", k27.comps[comp.i], "_c3.0_cond2.bed")))
  # tried w/o limiting to TSS and actually looks better at TSS so left same as k4
  # limit to TSS +/- 500bp
  up.peaks <- subset(up.peaks, distanceToTSS >= -500 & distanceToTSS <= 500)
  down.peaks <- subset(down.peaks, distanceToTSS >= -500 & distanceToTSS <= 500)
  men.up <- up.peaks[up.peaks$ENSEMBL %in% menin$V4,]
  not.men.up <- up.peaks[!(up.peaks$ENSEMBL %in% menin$V4),]
  men.down <- down.peaks[down.peaks$ENSEMBL %in% menin$V4,]
  not.men.down <- down.peaks[!(down.peaks$ENSEMBL %in% menin$V4),]
  men.bi.up <- men.up[men.up$ENSEMBL %in% bivalent$ENSEMBL,]
  men.not.bi.up <- men.up[!(men.up$ENSEMBL %in% bivalent$ENSEMBL),]
  not.men.bi.up <- not.men.up[not.men.up$ENSEMBL %in% bivalent$ENSEMBL,]
  not.men.not.bi.up <- not.men.up[!(not.men.up$ENSEMBL %in% bivalent$ENSEMBL),]
  men.bi.down <- men.down[men.down$ENSEMBL %in% bivalent$ENSEMBL,]
  men.not.bi.down <- men.down[!(men.down$ENSEMBL %in% bivalent$ENSEMBL),]
  not.men.bi.down <- not.men.down[not.men.down$ENSEMBL %in% bivalent$ENSEMBL,]
  not.men.not.bi.down <- not.men.down[!(not.men.down$ENSEMBL %in% bivalent$ENSEMBL),]
  # use proportions for barplot
  bar.data$nmnb <- rbind(nrow(not.men.not.bi.up)/sum(nrow(not.men.not.bi.up), nrow(not.men.not.bi.down)), nrow(not.men.not.bi.down)/sum(nrow(not.men.not.bi.up), nrow(not.men.not.bi.down)))
  bar.data$nmb <- rbind(nrow(not.men.bi.up)/sum(nrow(not.men.bi.up), nrow(not.men.bi.down)), nrow(not.men.bi.down)/sum(nrow(not.men.bi.up), nrow(not.men.bi.down)))
  bar.data$mnb <- rbind(nrow(men.not.bi.up)/sum(nrow(men.not.bi.up), nrow(men.not.bi.down)), nrow(men.not.bi.down)/sum(nrow(men.not.bi.up), nrow(men.not.bi.down)))
  bar.data$mb <- rbind(nrow(men.bi.up)/sum(nrow(men.bi.up), nrow(men.bi.down)), nrow(men.bi.down)/sum(nrow(men.bi.up), nrow(men.bi.down)))
  bar.matrix <- as.matrix(bar.data)
  rownames(bar.matrix) <- c("up", "down")
  colnames(bar.matrix) <- c("non-Menin\n not bivalent", "non-Menin\n bivalent", "Menin\n not bivalent", "Menin\n bivalent")
  pdf(file.path(plots.dir, paste0("prop_bar_", k27.comps[comp.i], ".pdf")))
  par(mar = c(5, 4, 2, 6), xpd = TRUE)
  bp <- barplot(
    bar.matrix, 
    col = c("indianred1", "dodgerblue"), 
    border = "white", 
    xlab = k4.comps[comp.i], 
    ylab = "Proportion",
    bty = "L"
    )
  # text on top (down peaks)
  text(bp, 1, c(nrow(not.men.not.bi.down), nrow(not.men.bi.down), nrow(men.not.bi.down), nrow(men.bi.down)), cex = 1.2, pos = 1)
  # text on bottom (up peaks)
  text(bp, 0, c(nrow(not.men.not.bi.up), nrow(not.men.bi.up), nrow(men.not.bi.up), nrow(men.bi.up)), cex = 1.2, pos = 3)
  legend("topright", legend = c("Up", "Down"), fill = c("indianred1", "dodgerblue"), inset = c(-0.2, 0))
  dev.off()
}

# make barplots of proportion up/downregulated for each KO for K119
AEBP2sg_K119_UP <- fread(file.path(cnr.diff.dir, paste0("diff_AEBP2sgRNAvNT2_H2AK119_c3.0_cond1.bed")))
PROP_AEBP2sg_K119_UP <- sum(AEBP2sg_K119_UP$SYMBOL %in% bivalent$SYMBOL)/nrow(AEBP2sg_K119_UP)
AEBP2sg_K119_DOWN <- fread(file.path(cnr.diff.dir, paste0("diff_AEBP2sgRNAvNT2_H2AK119_c3.0_cond2.bed")))
PROP_AEBP2sg_K119_DOWN <- sum(AEBP2sg_K119_DOWN$SYMBOL %in% bivalent$SYMBOL)/nrow(AEBP2sg_K119_DOWN)
MTF2sg_K119_UP <- fread(file.path(cnr.diff.dir, paste0("diff_MTF2sgRNAvNT2_H2AK119_c3.0_cond1.bed")))
PROP_MTF2sg_K119_UP <- sum(MTF2sg_K119_UP$SYMBOL %in% bivalent$SYMBOL)/nrow(MTF2sg_K119_UP)
MTF2sg_K119_DOWN <- fread(file.path(cnr.diff.dir, paste0("diff_MTF2sgRNAvNT2_H2AK119_c3.0_cond2.bed")))
PROP_MTF2sg_K119_DOWN<- sum(MTF2sg_K119_DOWN$SYMBOL %in% bivalent$SYMBOL)/nrow(MTF2sg_K119_DOWN)

pdf(file = file.path(plots.dir, "Barplot_bivalent_proportion_H2AK119_bdgdiff.pdf"), width = 6, height = 6)
par(mar = c(4, 8, 2, 4))
barplot(
  c(PROP_MTF2sg_K119_DOWN, PROP_MTF2sg_K119_UP, PROP_AEBP2sg_K119_DOWN, PROP_AEBP2sg_K119_UP), 
  las = 2, 
  main = "Bivalent proportion of up/down genes", 
  names.arg = c("MTF2sg_K119_DOWN", "MTF2sg_K119_UP", "AEBP2sg_K119_DOWN", "AEBP2sg_K119_UP"),
  col = c("firebrick1", "dodgerblue"),
  horiz = TRUE
  )
dev.off()
```

# barplots with common genes as well, using number of peaks
```{r}
for(comp.i in 1:length(k4.comps)){
  bar.data <- data.table(matrix(nrow = 3, ncol = 4))
  colnames(bar.data) <- c("nmnb", "nmb", "mnb", "mb")
  up.peaks <- fread(file.path(cnr.diff.dir, paste0("diff_", k4.comps[comp.i], "_c3.0_cond1.bed")))
  down.peaks <- fread(file.path(cnr.diff.dir, paste0("diff_", k4.comps[comp.i], "_c3.0_cond2.bed")))
  common <- fread(file.path(cnr.diff.dir, paste0("diff_", k4.comps[comp.i], "_c3.0_common.bed")))
  # limit to TSS +/- 500bp
  up.peaks <- subset(up.peaks, distanceToTSS >= -500 & distanceToTSS <= 500)
  down.peaks <- subset(down.peaks, distanceToTSS >= -500 & distanceToTSS <= 500)
  common <- subset(common, distanceToTSS >= -500 & distanceToTSS <= 500)
  men.up <- up.peaks[up.peaks$ENSEMBL %in% menin$V4,]
  not.men.up <- up.peaks[!(up.peaks$ENSEMBL %in% menin$V4),]
  men.down <- down.peaks[down.peaks$ENSEMBL %in% menin$V4,]
  not.men.down <- down.peaks[!(down.peaks$ENSEMBL %in% menin$V4),]
  men.common <- common[common$ENSEMBL %in% menin$V4,]
  not.men.common <- common[!(common$ENSEMBL %in% menin$V4),]
  men.bi.up <- men.up[men.up$ENSEMBL %in% bivalent$ENSEMBL,]
  men.not.bi.up <- men.up[!(men.up$ENSEMBL %in% bivalent$ENSEMBL),]
  not.men.bi.up <- not.men.up[not.men.up$ENSEMBL %in% bivalent$ENSEMBL,]
  not.men.not.bi.up <- not.men.up[!(not.men.up$ENSEMBL %in% bivalent$ENSEMBL),]
  men.bi.down <- men.down[men.down$ENSEMBL %in% bivalent$ENSEMBL,]
  men.not.bi.down <- men.down[!(men.down$ENSEMBL %in% bivalent$ENSEMBL),]
  not.men.bi.down <- not.men.down[not.men.down$ENSEMBL %in% bivalent$ENSEMBL,]
  not.men.not.bi.down <- not.men.down[!(not.men.down$ENSEMBL %in% bivalent$ENSEMBL),]
  men.bi.common <- men.common[men.common$ENSEMBL %in% bivalent$ENSEMBL,]
  men.not.bi.common <- men.common[!(men.common$ENSEMBL %in% bivalent$ENSEMBL),]
  not.men.bi.common <- not.men.common[not.men.common$ENSEMBL %in% bivalent$ENSEMBL,]
  not.men.not.bi.common <- not.men.common[!(not.men.common$ENSEMBL %in% bivalent$ENSEMBL),]
  # use proportions for barplot
  bar.data$nmnb <- rbind(
    nrow(not.men.not.bi.up),
    nrow(not.men.not.bi.common),
    nrow(not.men.not.bi.down)
    )
  bar.data$nmb <- rbind(
    nrow(not.men.bi.up),
    nrow(not.men.bi.common),
    nrow(not.men.bi.down)
    )
  bar.data$mnb <- rbind(
    nrow(men.not.bi.up),
    nrow(men.not.bi.common), 
    nrow(men.not.bi.down)
    )
  bar.data$mb <- rbind(
    nrow(men.bi.up),
    nrow(men.bi.common),
    nrow(men.bi.down)
    )
  bar.matrix <- as.matrix(bar.data)
  rownames(bar.matrix) <- c("up", "common", "down")
  colnames(bar.matrix) <- c("non-Menin\n not bivalent", "non-Menin\n bivalent", "Menin\n not bivalent", "Menin\n bivalent")
  pdf(file.path(plots.dir, paste0("bar_", k4.comps[comp.i], ".pdf")))
  par(mar = c(7, 4, 1, 6), xpd = TRUE)
  bp <- barplot(
    bar.matrix, 
    col = c("indianred1", "grey", "dodgerblue"), 
    border = "white", 
    xlab = k4.comps[comp.i], 
#    ylab = "Proportion",
    beside = TRUE,
    bty = "L"
    )
  text(bp, 0, bar.matrix, cex = 0.7, pos = 3)
  legend("topright", legend = c("KO", "Common", "Control"), fill = c("indianred1", "grey", "dodgerblue"), inset = c(-0.2, 0))
  dev.off()
}

for(comp.i in 1:length(k27.comps)){
  bar.data <- data.table(matrix(nrow = 3, ncol = 4))
  colnames(bar.data) <- c("nmnb", "nmb", "mnb", "mb")
  up.peaks <- fread(file.path(cnr.diff.dir, paste0("diff_", k27.comps[comp.i], "_c3.0_cond1.bed")))
  down.peaks <- fread(file.path(cnr.diff.dir, paste0("diff_", k27.comps[comp.i], "_c3.0_cond2.bed")))
  common <- fread(file.path(cnr.diff.dir, paste0("diff_", k27.comps[comp.i], "_c3.0_common.bed")))
  # limit to TSS +/- 500bp
  #up.peaks <- subset(up.peaks, distanceToTSS >= -500 & distanceToTSS <= 500)
  #down.peaks <- subset(down.peaks, distanceToTSS >= -500 & distanceToTSS <= 500)
  #common <- subset(common, distanceToTSS >= -500 & distanceToTSS <= 500)
  men.up <- up.peaks[up.peaks$ENSEMBL %in% menin$V4,]
  not.men.up <- up.peaks[!(up.peaks$ENSEMBL %in% menin$V4),]
  men.down <- down.peaks[down.peaks$ENSEMBL %in% menin$V4,]
  not.men.down <- down.peaks[!(down.peaks$ENSEMBL %in% menin$V4),]
  men.common <- common[common$ENSEMBL %in% menin$V4,]
  not.men.common <- common[!(common$ENSEMBL %in% menin$V4),]
  men.bi.up <- men.up[men.up$ENSEMBL %in% bivalent$ENSEMBL,]
  men.not.bi.up <- men.up[!(men.up$ENSEMBL %in% bivalent$ENSEMBL),]
  not.men.bi.up <- not.men.up[not.men.up$ENSEMBL %in% bivalent$ENSEMBL,]
  not.men.not.bi.up <- not.men.up[!(not.men.up$ENSEMBL %in% bivalent$ENSEMBL),]
  men.bi.down <- men.down[men.down$ENSEMBL %in% bivalent$ENSEMBL,]
  men.not.bi.down <- men.down[!(men.down$ENSEMBL %in% bivalent$ENSEMBL),]
  not.men.bi.down <- not.men.down[not.men.down$ENSEMBL %in% bivalent$ENSEMBL,]
  not.men.not.bi.down <- not.men.down[!(not.men.down$ENSEMBL %in% bivalent$ENSEMBL),]
  men.bi.common <- men.common[men.common$ENSEMBL %in% bivalent$ENSEMBL,]
  men.not.bi.common <- men.common[!(men.common$ENSEMBL %in% bivalent$ENSEMBL),]
  not.men.bi.common <- not.men.common[not.men.common$ENSEMBL %in% bivalent$ENSEMBL,]
  not.men.not.bi.common <- not.men.common[!(not.men.common$ENSEMBL %in% bivalent$ENSEMBL),]
  # use proportions for barplot
  bar.data$nmnb <- rbind(
    nrow(not.men.not.bi.up),
    nrow(not.men.not.bi.common),
    nrow(not.men.not.bi.down)
    )
  bar.data$nmb <- rbind(
    nrow(not.men.bi.up),
    nrow(not.men.bi.common),
    nrow(not.men.bi.down)
    )
  bar.data$mnb <- rbind(
    nrow(men.not.bi.up),
    nrow(men.not.bi.common), 
    nrow(men.not.bi.down)
    )
  bar.data$mb <- rbind(
    nrow(men.bi.up),
    nrow(men.bi.common),
    nrow(men.bi.down)
    )
  bar.matrix <- as.matrix(bar.data)
  rownames(bar.matrix) <- c("up", "common", "down")
  colnames(bar.matrix) <- c("non-Menin\n not bivalent", "non-Menin\n bivalent", "Menin\n not bivalent", "Menin\n bivalent")
  pdf(file.path(plots.dir, paste0("bar_", k27.comps[comp.i], ".pdf")))
  par(mar = c(7, 4, 1, 6), xpd = TRUE)
  bp <- barplot(
    bar.matrix, 
    col = c("indianred1", "grey", "dodgerblue"), 
    border = "white", 
    xlab = k27.comps[comp.i], 
#    ylab = "Proportion",
    beside = TRUE,
    bty = "L"
    )
  text(bp, 0, bar.matrix, cex = 0.7, pos = 3)
  legend("topright", legend = c("KO", "Common", "Control"), fill = c("indianred1", "grey", "dodgerblue"), inset = c(-0.2, 0))
  dev.off()
}

# make barplots of proportion up/downregulated for each KO for K119
AEBP2sg_K119_UP <- fread(file.path(cnr.diff.dir, paste0("diff_AEBP2sgRNAvNT2_H2AK119_c3.0_cond1.bed")))
PROP_AEBP2sg_K119_UP <- sum(AEBP2sg_K119_UP$SYMBOL %in% bivalent$SYMBOL)/nrow(AEBP2sg_K119_UP)
AEBP2sg_K119_DOWN <- fread(file.path(cnr.diff.dir, paste0("diff_AEBP2sgRNAvNT2_H2AK119_c3.0_cond2.bed")))
PROP_AEBP2sg_K119_DOWN <- sum(AEBP2sg_K119_DOWN$SYMBOL %in% bivalent$SYMBOL)/nrow(AEBP2sg_K119_DOWN)
MTF2sg_K119_UP <- fread(file.path(cnr.diff.dir, paste0("diff_MTF2sgRNAvNT2_H2AK119_c3.0_cond1.bed")))
PROP_MTF2sg_K119_UP <- sum(MTF2sg_K119_UP$SYMBOL %in% bivalent$SYMBOL)/nrow(MTF2sg_K119_UP)
MTF2sg_K119_DOWN <- fread(file.path(cnr.diff.dir, paste0("diff_MTF2sgRNAvNT2_H2AK119_c3.0_cond2.bed")))
PROP_MTF2sg_K119_DOWN<- sum(MTF2sg_K119_DOWN$SYMBOL %in% bivalent$SYMBOL)/nrow(MTF2sg_K119_DOWN)

pdf(file = file.path(plots.dir, "Barplot_bivalent_proportion_H2AK119_bdgdiff.pdf"), width = 6, height = 6)
par(mar = c(4, 8, 2, 4))
barplot(
  c(PROP_MTF2sg_K119_DOWN, PROP_MTF2sg_K119_UP, PROP_AEBP2sg_K119_DOWN, PROP_AEBP2sg_K119_UP), 
  las = 2, 
  main = "Bivalent proportion of up/down genes", 
  names.arg = c("MTF2sg_K119_DOWN", "MTF2sg_K119_UP", "AEBP2sg_K119_DOWN", "AEBP2sg_K119_UP"),
  col = c("firebrick1", "dodgerblue"),
  horiz = TRUE
  )
dev.off()
```

# make gene profile and heatmap plots on RPCG norm data
```{bash}
# from RPCG BW dir
cd BW_RPGC_norm/

# submitted to cluster as:
sbatch ../../scripts/DeeptoolsBWMatrix.sbatch

# commands submitted in sbatch
# Doing each experiment separately, first for CSCT05
computeMatrix scale-regions -S \
MHC-CSCT05-K562-NT2-H3K4me3_S2.RPGC.bw MHC-CSCT05-K562-AEBP2sgRNA-H3K4me3_S3.RPGC.bw MHC-CSCT05-K562-MTF2sgRNA-H3K4me3_S4.RPGC.bw \
MHC-CSCT05-K562-NT2-H3K27me3_S5.RPGC.bw MHC-CSCT05-K562-AEBP2sgRNA-H3K27me3_S6.RPGC.bw MHC-CSCT05-K562-MTF2sgRNA-H3K27me3_S7.RPGC.bw \
MHC-CSCT05-K562-NT2-H2AK119_S8.RPGC.bw MHC-CSCT05-K562-AEBP2sgRNA-H2AK119_S9.RPGC.bw MHC-CSCT05-K562-MTF2sgRNA-H2AK119_S10.RPGC.bw \
-R /data/reference/dawson_labs/bed_files/Hg19/Hg19EnsGene1kbProm.bed -a 3000 -b 3000 -m 5000 -o CnTmatrix_CUTandTAG_RPGCnorm_1kPromAllGenes.gz

plotProfile -m CnTmatrix_CUTandTAG_RPGCnorm_1kPromAllGenes.gz --perGroup --samplesLabel \
NT2-H3K4me3 AEBP2sgRNA-H3K4me3 MTF2sgRNA-H3K4me3 \
NT2-H3K27me3 AEBP2sgRNA-H3K27me3 MTF2sgRNA-H3K27me3 \
NT2-H2AK119 AEBP2sgRNA-H2AK119 MTF2sgRNA-H2AK119 \
-o ../../plots/Profile_CnT_RPGCnorm_1kbPromAllGenes.pdf --plotTitle "Cut&Tag All genes"

plotHeatmap -m CnTmatrix_CUTandTAG_RPGCnorm_1kPromAllGenes.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
NT2-H3K4me3 AEBP2sgRNA-H3K4me3 MTF2sgRNA-H3K4me3 \
NT2-H3K27me3 AEBP2sgRNA-H3K27me3 MTF2sgRNA-H3K27me3 \
NT2-H2AK119 AEBP2sgRNA-H2AK119 MTF2sgRNA-H2AK119 \
--colorMap Reds Reds Reds Blues Blues Blues Oranges Oranges Oranges -o ../../plots/Heatmap_CnT_RPGCnorm_1KbPromAllGenes.pdf --plotTitle "Cut&Tag All genes"

# now for CSCT06
computeMatrix scale-regions -S \
MHC-CSCT06-K562-CAS-EZH2i-H3K4me3_S12.RPGC.bw MHC-CSCT06-K562-MLL1-2ko-EZH2i-H3K4me3_S14.RPGC.bw \
MHC-CSCT06-K562-CAS-EZH2i-IFN-H3K4me3_S13.RPGC.bw MHC-CSCT06-K562-MLL1-2ko-EZH2i-IFN-H3K4me3_S15.RPGC.bw \
-R /data/reference/dawson_labs/bed_files/Hg19/Hg19EnsGene1kbProm.bed -a 3000 -b 3000 -m 5000 -o CnTmatrix_CSCT06_RPGCnorm_1kPromAllGenes.gz

plotProfile -m CnTmatrix_CSCT06_RPGCnorm_1kPromAllGenes.gz --perGroup --samplesLabel \
CAS-EZH2i-H3K4me3 MLL1-2ko-EZH2i-H3K4me3 \
CAS-EZH2i-IFN-H3K4me3 MLL1-2ko-EZH2i-IFN-H3K4me3 \
-o ../../plots/Profile_CSCT06_RPGCnorm_1kbPromAllGenes.pdf --plotTitle "Cut&Tag All genes"

plotHeatmap -m CnTmatrix_CSCT06_RPGCnorm_1kPromAllGenes.gz --sortUsing sum --boxAroundHeatmaps no --samplesLabel \
CAS-EZH2i-H3K4me3 MLL1-2ko-EZH2i-H3K4me3 \
CAS-EZH2i-IFN-H3K4me3 MLL1-2ko-EZH2i-IFN-H3K4me3 \
--colorMap Reds Reds Reds Reds -o ../../plots/Heatmap_CSCT06_RPGCnorm_1KbPromAllGenes.pdf --plotTitle "Cut&Tag All genes"

# now make CSCT05 plots separately for each mark
sbatch ../../scripts/DTMatrixK4.sbatch
sbatch ../../scripts/DTMatrixK27.sbatch
sbatch ../../scripts/DTMatrixK119.sbatch

# redo heatmap colours
sbatch ../../scripts/DTHeat.sbatch
```


# make barplots of proportion up/down regulated for each KO per mark in CSCT05
```{r}
# loop through marks and make a plot for each
for(mark in marks){
  # get up and down peaks per macs for each KO, then divide into bivalent and not
  aebp.up <- fread(file.path(cnr.diff.dir, paste0("diff_AEBP2sgRNAvNT2_", mark, "_c3.0_cond1.bed")))
  aebp.down <- fread(file.path(cnr.diff.dir, paste0("diff_AEBP2sgRNAvNT2_", mark, "_c3.0_cond2.bed")))
  mtf.up <- fread(file.path(cnr.diff.dir, paste0("diff_MTF2sgRNAvNT2_", mark, "_c3.0_cond1.bed")))
  mtf.down <- fread(file.path(cnr.diff.dir, paste0("diff_MTF2sgRNAvNT2_", mark, "_c3.0_cond2.bed")))
  # limit each to regions of interest
  keep <- c("Promoter (<=1kb)", "3' UTR", "Intron", "Exon", "5' UTR")
  aebp.up <- aebp.up[aebp.up$annotation %in% keep, ]
  aebp.down <- aebp.down[aebp.down$annotation %in% keep, ]
  mtf.up <- mtf.up[mtf.up$annotation %in% keep, ]
  mtf.down <- mtf.down[mtf.down$annotation %in% keep, ]
  
  # get proportion bivalent for each
  aebp.bi.up <- length(unique(intersect(aebp.up$ENSEMBL, bivalent$ENSEMBL)))/length(unique(aebp.up$ENSEMBL))
  aebp.bi.down <- length(unique(intersect(aebp.down$ENSEMBL, bivalent$ENSEMBL)))/length(unique(aebp.down$ENSEMBL))
  mtf.bi.up <- length(unique(intersect(mtf.up$ENSEMBL, bivalent$ENSEMBL)))/length(unique(mtf.up$ENSEMBL))
  mtf.bi.down <- length(unique(intersect(mtf.down$ENSEMBL, bivalent$ENSEMBL)))/length(unique(mtf.down$ENSEMBL))
  
  pdf(file = file.path(plots.dir, paste0("Barplot_bivalent_proportion_", mark, "_diffpeaks.pdf")), width = 6, height = 6)
  par(mar = c(4, 10, 2, 4))
  barplot(
    c(mtf.bi.down, mtf.bi.up, aebp.bi.down, aebp.bi.up), 
    las = 2, 
    main = paste0("Proportion of genes with up/down\n", mark, " binding which are bivalent"), 
    names.arg = c("MTF2sgRNA down", "MTF2sgRNA up", "AEBP2sgRNA down", "AEBP2sgRNA up"),
    col = c("firebrick1", "dodgerblue"),
    xlim = c(0, 1),
    horiz = TRUE
    )
  dev.off()
}

```

# make gene profile and heatmap plots w/genes only bed file on RPCG norm data
```{bash}
# from RPCG BW dir
cd BW_RPGC_norm/

sbatch ../../scripts/DTMatrixK4_allgenes.sbatch
sbatch ../../scripts/DTMatrixK27_allgenes.sbatch
sbatch ../../scripts/DTMatrixK119_allgenes.sbatch
sbatch ../../scripts/DTMatrix_CSCT06_allgenes.sbatch
```

# make bivalent list for each experiment then make new list for bivlent in 2/3
```{r}
# read in ChIP bivalent gene list
chip.bi <- scan("/dawson_genomics/Projects/Menin/ChIPseq_combined_200320_210422_210623/sample_info/K562_bivalent_genes.txt", what = "character")

# get bivalent list for each C&T experiment
nt.bi <- intersect(
  unique(bi.ann.list$`NT2-H3K4me3_S2`[bi.ann.list$`NT2-H3K4me3_S2`$annotation %in% keep, c("ENSEMBL", "SYMBOL")]),
  unique(bi.ann.list$`NT2-H3K27me3_S5`[bi.ann.list$`NT2-H3K27me3_S5`$annotation %in% keep, c("ENSEMBL", "SYMBOL")])
  )
cas.bi <- intersect(
  unique(bi.ann.list$`CAS-H3K4me3_S2`[bi.ann.list$`CAS-H3K4me3_S2`$annotation %in% keep, c("ENSEMBL", "SYMBOL")]),
  unique(bi.ann.list$`CAS-H3K27me3_S6`[bi.ann.list$`CAS-H3K27me3_S6`$annotation %in% keep, c("ENSEMBL", "SYMBOL")])
  )

# put into single list and tally
all.bi <- c(nt.bi$ENSEMBL, cas.bi$ENSEMBL, chip.bi)
all.bi.table <- as.data.frame(table(all.bi))
# keep only in at least 2 and get ENSG
all.bi.keep <- as.data.frame(all.bi.table[which(all.bi.table$Freq >= 2), 1])
names(all.bi.keep) <- "ENSEMBL"

# merge with list for Christina to get symbols, then write out
all.bi.list <- unique(merge(all.bi.keep, k4k27.peaks))
write.table(
  all.bi.list,
  file.path(bi.dir, "K562_bivalent_genes_2of3.txt"),
  sep = "\t",
  col.names = TRUE,
  row.names = FALSE,
  quote = FALSE
)

# remove NAs and write out separate lists
nt.bi <- nt.bi[-1, ]
cas.bi <- cas.bi[-1, ]
write.table(
  nt.bi,
  file.path(bi.dir, "CSCT05_NT_bivalent_genes.txt"), 
  sep = "\t",
  col.names = TRUE,
  row.names = FALSE,
  quote = FALSE
)
write.table(
  cas.bi,
  file.path(bi.dir, "CSCT03_CAS_bivalent_genes.txt"), 
  sep = "\t",
  col.names = TRUE,
  row.names = FALSE,
  quote = FALSE
)
```

# make new heatmaps, just genes with peaks for each mark and each with single colour
# make new bed files first
```{bash}
# intersect genomewide bed file with all 3 peaks files for each mark with -u to report only -a coords if any overlap found in -b
#run from cnr macs peaks dir
cd cnr_tools_wd/macs2.broad.all.frag.aug18
module load bedtools/2.27.1

bedtools intersect -a /data/reference/dawson_labs/bed_files/Hg19/Hg19EnsGeneDT.bed -b MHC-CSCT05-K562-NT2-H3K4me3_S2_aligned_reads_peaks.broadPeak MHC-CSCT05-K562-AEBP2sgRNA-H3K4me3_S3_aligned_reads_peaks.broadPeak MHC-CSCT05-K562-MTF2sgRNA-H3K4me3_S4_aligned_reads_peaks.broadPeak -u > ../../reference_files/Hg19EnsGeneDT_K4peaks.bed

bedtools intersect -a /data/reference/dawson_labs/bed_files/Hg19/Hg19EnsGeneDT.bed -b MHC-CSCT05-K562-NT2-H3K27me3_S5_aligned_reads_peaks.broadPeak MHC-CSCT05-K562-AEBP2sgRNA-H3K27me3_S6_aligned_reads_peaks.broadPeak MHC-CSCT05-K562-MTF2sgRNA-H3K27me3_S7_aligned_reads_peaks.broadPeak -u > ../../reference_files/Hg19EnsGeneDT_K27peaks.bed

bedtools intersect -a /data/reference/dawson_labs/bed_files/Hg19/Hg19EnsGeneDT.bed -b MHC-CSCT05-K562-NT2-H2AK119_S8_aligned_reads_peaks.broadPeak MHC-CSCT05-K562-AEBP2sgRNA-H2AK119_S9_aligned_reads_peaks.broadPeak MHC-CSCT05-K562-MTF2sgRNA-H2AK119_S10_aligned_reads_peaks.broadPeak -u > ../../reference_files/Hg19EnsGeneDT_K119peaks.bed

# submit new heatmaps, both for RPGC norm and spike-in norm
# run from respective BW dirs
cd ../../alignment/BW_RPGC_norm

sbatch ../../scripts/DTMatrix_K4_Peaks_genes.sbatch
sbatch ../../scripts/DTMatrix_K27_Peaks_genes.sbatch
sbatch ../../scripts/DTMatrix_K119_Peaks_genes.sbatch

cd ../BW_spikein_norm/

sbatch ../../scripts/DTMatrix_K4_Peaks_genes_spikein.sbatch
sbatch ../../scripts/DTMatrix_K27_Peaks_genes_spikein.sbatch
sbatch ../../scripts/DTMatrix_K119_Peaks_genes_spikein.sbatch
```

# try to make new bivalent list from CSCT03 limiting to TSS +/-2kbp
```{r}
cas.bi <- intersect(
  unique(bi.ann.list$`CAS-H3K4me3_S2`[abs(bi.ann.list$`CAS-H3K4me3_S2`$distanceToTSS) <= 2000, c("ENSEMBL", "SYMBOL")]),
  unique(bi.ann.list$`CAS-H3K27me3_S6`[abs(bi.ann.list$`CAS-H3K27me3_S6`$distanceToTSS) <= 2000, c("ENSEMBL", "SYMBOL")])
  )

write.table(
  cas.bi,
  file.path(bi.dir, "CSCT03_CAS_bivalent_genes_2kTSS.txt"), 
  sep = "\t",
  col.names = TRUE,
  row.names = FALSE,
  quote = FALSE
)

# now redo with -2000 and +5000
cas.bi.2k5k <- intersect(
  unique(bi.ann.list$`CAS-H3K4me3_S2`[bi.ann.list$`CAS-H3K4me3_S2`$distanceToTSS >= -2000 & bi.ann.list$`CAS-H3K4me3_S2`$distanceToTSS <= 5000, c("ENSEMBL", "SYMBOL")]),
  unique(bi.ann.list$`CAS-H3K27me3_S6`[bi.ann.list$`CAS-H3K27me3_S6`$distanceToTSS >= -2000 & bi.ann.list$`CAS-H3K27me3_S6`$distanceToTSS <= 5000, c("ENSEMBL", "SYMBOL")])
  )

write.table(
  cas.bi.2k5k,
  file.path(bi.dir, "CSCT03_CAS_bivalent_genes_2k5kTSS.txt"), 
  sep = "\t",
  col.names = TRUE,
  row.names = FALSE,
  quote = FALSE
)
```

# check proportion of MLL 2kTSS lists on 2k bivalent list and menin binding
```{r}
mll.up.peaks <- fread("../CUTandRUN_220310_NB501056_0771_AHMVHHBGXL/reference_files/CSCR01_1RPM_MLL_UP_K4only_TSS2k_K4_counts.bed")
mll.down.peaks <- fread("../CUTandRUN_220310_NB501056_0771_AHMVHHBGXL/reference_files/CSCR01_1RPM_MLL_DOWN_K4only_TSS2k_K4_counts.bed")

# get new 2k bi list
bi.tss <- fread(file.path(bi.dir, "CSCT03_CAS_bivalent_genes_2kTSS.txt"))
  
# get genes with peaks
mll.up.genes <- unique(na.omit(mll.up.peaks$V6))
mll.down.genes <- unique(na.omit(mll.down.peaks$V6))

mll.up.prop <- c(
  length(which(!(mll.up.genes %in% bi.tss$ENSEMBL) & !(mll.up.genes %in% menin$V4)))/length(mll.up.genes),
  length(which(mll.up.genes %in% bi.tss$ENSEMBL & !(mll.up.genes %in% menin$V4)))/length(mll.up.genes),
  length(which(!(mll.up.genes %in% bi.tss$ENSEMBL) & mll.up.genes %in% menin$V4))/length(mll.up.genes),
  length(which(mll.up.genes %in% bi.tss$ENSEMBL & mll.up.genes %in% menin$V4))/length(mll.up.genes)
  )
mll.down.prop <- c(
  length(which(!(mll.down.genes %in% bi.tss$ENSEMBL) & !(mll.down.genes %in% menin$V4)))/length(mll.down.genes),
  length(which(mll.down.genes %in% bi.tss$ENSEMBL & !(mll.down.genes %in% menin$V4)))/length(mll.down.genes),
  length(which(!(mll.down.genes %in% bi.tss$ENSEMBL) & mll.down.genes %in% menin$V4))/length(mll.down.genes),
  length(which(mll.down.genes %in% bi.tss$ENSEMBL & mll.down.genes %in% menin$V4))/length(mll.down.genes)
  )

mll.prop.table <- as.data.frame(rbind(mll.up.prop, mll.down.prop))
colnames(mll.prop.table) <- c("non.Menin.non.bivalent", "non.Menin.bivalent", "Menin.non.bivalent", "Menin.bivalent")

# add columns for total bivalent proportion and total menin bound proportion
mll.prop.table$total.bivalent <- mll.prop.table$non.Menin.bivalent + mll.prop.table$Menin.bivalent
mll.prop.table$total.menin.bound <- mll.prop.table$Menin.non.bivalent + mll.prop.table$Menin.bivalent

# save table
write.table(
  mll.prop.table,
  "reference_files/MLL_up_down_genes_bivalent_menin_prop_table.txt", 
  sep = "\t",
  col.names = NA,
  row.names = TRUE,
  quote = FALSE
)
```

# make k27 and k119 heatmaps on 2ktss bivalent genes only
# first need bed file of 2k bivalent genes
```{r}
all.bed <- fread("/data/reference/dawson_labs/bed_files/Hg19/Hg19EnsGeneDT.bed")

bi.2k.bed <- all.bed[which(all.bed$V4 %in% bi.tss$ENSEMBL), ]
# save bed file
write.table(
  bi.2k.bed,
  "reference_files/CSCT03_CAS_bivalent_genes_2kTSS.bed",
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE,
  quote = FALSE
)
```

# submit heatmaps jobs
```{bash}
cd alignment/BW_RPGC_norm

sbatch ../../scripts/DTMatrix_K27_bivalent_genes.sbatch
sbatch ../../scripts/DTMatrix_K119_bivalent_genes.sbatch
```

# check up/down binding on K27 for AEBP2 KO, similar to MLL heatmaps
```{r}
# get only samples for NT and AEBP2KO
k27.norm <- countsNorm[ , c("NT2_H3K27me3_S5", "AEBP2sgRNA_H3K27me3_S6")]

# add coordinates to table
chr.pos <- strsplit2(rownames(k27.norm), ":")
k27.norm$Chr <- chr.pos[,1]
start.end <- strsplit2(chr.pos[,2], "-")
k27.norm$Start <- as.numeric(start.end[,1])
k27.norm$End <- as.numeric(start.end[,2])
# remove those with 0 reads in both
k27.norm <- k27.norm[-which(rowSums(k27.norm[, 1:2]) == 0), ]

# make genomic ranges object for annotation
gr.k27.table <- with(k27.norm, GRanges(Chr, IRanges(start=Start, end=End)))
seqlevelsStyle(gr.k27.table) <- "UCSC"
k27.ann <- annotatePeak(gr.k27.table, TxDb = txdb, annoDb = "org.Hs.eg.db")
k27.ann.table <- as.data.frame(k27.ann)
k27.counts.table <- cbind(k27.norm, k27.ann.table)
# fix names
intron <- which(substr(k27.counts.table$annotation, 1, 6) == "Intron")
k27.counts.table$annotation[intron] <- "Intron"
exon <- which(substr(k27.counts.table$annotation, 1, 4) == "Exon")
k27.counts.table$annotation[exon] <- "Exon"

# limit to genic regions
k27.counts <- k27.counts.table[k27.counts.table$annotation %in% keep, ]

# subset to all samples >1RPM
k27.1rpm <- subset(k27.counts, AEBP2sgRNA_H3K27me3_S6 >= 1 & NT2_H3K27me3_S5 >= 1)

# put in bed order
bed.1rpm <- k27.1rpm[, c(3:5, 1:2)]
#separate into up/down
bed.1rpm.up <- bed.1rpm[which(bed.1rpm$AEBP2sgRNA_H3K27me3_S6 > (bed.1rpm$NT2_H3K27me3_S5+1)), ]
bed.1rpm.down <- bed.1rpm[which(bed.1rpm$AEBP2sgRNA_H3K27me3_S6 < (bed.1rpm$NT2_H3K27me3_S5-1)), ]

bed.dir <- file.path(project.dir, "bed_files")

# write out
write.table(
	bed.1rpm.up,
	file.path(bed.dir, '1RPMdiff_AEBP2_K27_UP.bed'),
	sep = '\t',
	col.names = FALSE,
	row.names = FALSE,
	quote = FALSE
	)

write.table(
	bed.1rpm.down,
	file.path(bed.dir, '1RPMdiff_AEBP2_K27_DOWN.bed'),
	sep = '\t',
	col.names = FALSE,
	row.names = FALSE,
	quote = FALSE
	)
```

# now make heatmap
```{bash}
# from RPGC bigwig dir
sbatch ../../scripts/DTMatrixK27_AEBP2_UP_DOWN.sbatch 
```

# get stats for peaks in above heatmaps
```{r}
# get up/down in full table format to have ensemble ids
k27.1rpm.up <- k27.1rpm[which(k27.1rpm$AEBP2sgRNA_H3K27me3_S6 > (k27.1rpm$NT2_H3K27me3_S5+1)), ]
k27.1rpm.down <- k27.1rpm[which(k27.1rpm$AEBP2sgRNA_H3K27me3_S6 < (k27.1rpm$NT2_H3K27me3_S5-1)), ]
```

# now add EZH2 and SUZ12 to heatmap also
```{bash}
sbatch ../../scripts/DTMatrixK27_AEBP2_UP_DOWN.sbatch 
```

# make bivalent heatmap for K4 as well
```{bash}
sbatch ../../scripts/DTMatrix_K4_bivalent_genes.sbatch

# also for EZH2i 2KO samples
sbatch ../../scripts/DTMatrix_EZH2i_K4_bivalent_genes.sbatch
# same data on MLL up and down genes
sbatch ../../scripts/DTMatrix_EZH2i_K4_MLL_UP_genes.sbatch
sbatch ../../scripts/DTMatrix_EZH2i_K4_MLL_DOWN_genes.sbatch
```

# save session info
```{r}
sesh.info <- capture.output(sessionInfo())
writeLines(
  sesh.info,
  file.path(project.dir, "session-info", paste0(Sys.Date(), "_CutAndTag_analysis_220201.txt"))
)
```
