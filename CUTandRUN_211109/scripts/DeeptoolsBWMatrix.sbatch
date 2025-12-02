#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=40G
#SBATCH --time=1-0:00:00
#SBATCH --output=../logs/deeptoolsMatrix%j.stdout
#SBATCH --error=../logs/deeptoolsMatrix%j.err
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=end
#SBATCH --job-name="deeptools"
#SBATCH --partition=prod_med

module load deeptools/3.0.0

computeMatrix scale-regions -S \
NormBW/MHC-CSCR01-K562-CAS-H3K27me3_S15.bw NormBW/MHC-CSCR01-K562-MEN1c4-KO-H3K27me3_S16.bw \
NormBW/MHC-CSCR01-K562-CAS-MLL1_S11.bw NormBW/MHC-CSCR01-K562-MEN1c4-KO-MLL1_S12.bw \
NormBW/MHC-CSCR01-K562-CAS-RNAPII_S17.bw NormBW/MHC-CSCR01-K562-MEN1c4-KO-RNAPII_S18.bw \
NormBW/MHC-CSCR01-K562-CAS-SUZ12_S13.bw NormBW/MHC-CSCR01-K562-MEN1c4-KO-SUZ12_S14.bw \
-R /dawson_genomics/Projects/Menin/ChIPseq_200320_NB501056_0470_AH5NJJBGXF/scripts/MeninGenes.bed \
-a 3000 -b 3000 -m 5000 -o CnRmatrix_CUTandRUN_Norm_Menin_Genes.gz
