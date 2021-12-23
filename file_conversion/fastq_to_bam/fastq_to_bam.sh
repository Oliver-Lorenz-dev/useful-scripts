#!/bin/bash

# load modules
module load bwa/0.7.17-r1188 samtools/1.9

# convert fastq to cram

# align fastq using bwa + convert to bam
bwa mem /lustre/scratch118/infgen/pathogen/pathpipe/malariaGEN/vectors/references/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4.fa \
SAMPLEID_1.fastq.gz SAMPLEID_2.fastq.gz | samtools view -o SAMPLEID.bam
samtools fixmate -O bam,level=1 -m SAMPLEID.bam SAMPLEID.fixmate.bam

# sort bam
samtools sort -l 1 -o SAMPLEID.pos.srt.bam -T tmp SAMPLEID.fixmate.bam

# mark dupes
samtools markdup -O bam,level=1 SAMPLEID.pos.srt.bam SAMPLEID.markdup.bam

# convert to cram
samtools view -T /lustre/scratch118/infgen/pathogen/pathpipe/malariaGEN/vectors/references/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4.fa \
SAMPLEID.markdup.bam -o SAMPLEID.cram
