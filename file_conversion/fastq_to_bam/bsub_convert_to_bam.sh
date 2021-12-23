#!/bin/bash

module load bwa/0.7.17-r1188 samtools/1.9

for file in ./SRR*.sh; do
bsub -J fastq_to_bam -o %J.out -e %J.err -R "select[mem>8000] rusage[mem=8000] -M8000 \
-q normal $file
done

# sed magic to create the individual scripts
# clean up after use
