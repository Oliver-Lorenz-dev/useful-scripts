#!/bin/bash

# load modules
module load bwa/0.7.17-r1188 samtools/1.9

# convert fastq to cram

# align fastq using bwa + convert to bam
for index in {69..72}
do
    bwa mem /lustre/scratch118/infgen/pathogen/pathpipe/malariaGEN/vectors/references/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4.fa \
    SRR82857"${index}"_1.fastq.gz SRR82857"{index}"_2.fastq.gz | samtools view -o SRR82857"{index}".bam
done

# fix mates
for index in {69..72}
do
    samtools fixmate -O bam,level=1 -m SRR82857"{index}".bam SRR82857"{index}".fixmate.bam
done

# sort bam
for index in {69..72}
do
   samtools sort -l 1 -o SRR82857"{index}".pos.srt.bam -T tmp SRR82857"{index}".fixmate.bam
done

# mark dupes
for index in {69..72}
do
    samtools markdup -O bam,level=1 SRR82857"{index}".pos.srt.bam SRR82857"{index}".markdup.bam
done

# convert to cram
for index in {69..72}
do
    samtools view -T /lustre/scratch118/infgen/pathogen/pathpipe/malariaGEN/vectors/references/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4.fa \
    SRR82857"{index}".markdup.bam -o SRR82857"{index}".cram
done
