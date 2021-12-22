#!/bin/bash

module load biobambam/2.0.87--1

for f in *.cram; do
cram_file=$(basename ${f})
filename_stem=${cram_file%.cram}
bamtofastq collate=1 inputformat=cram exclude=SECONDARY,SUPPLEMENTARY \
            F=${filename_stem}_1.fastq \
            O=${filename_stem}_1_orphan.fastq \
            F2=${filename_stem}_2.fastq \
            O2=${filename_stem}_2_orphan.fastq \
            S=${filename_stem}_single_end.fastq \
            < ${f}
done

find . -type f -name '*.fastq' -size 0 -delete
gzip *.fastq
