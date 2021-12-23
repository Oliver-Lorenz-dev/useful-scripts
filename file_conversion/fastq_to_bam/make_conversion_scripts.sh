#!/bin/bash

for f in *_1.fastq.gz
do
    filename_base_name=`basename ${f%%.*}`
    filename=${filename_base_name::-2}
    sed "s:SAMPLEID:${filename}:g" fastq_to_bam.sh > $filename"_fastq_to_bam.sh"
done

chmod +x *_fastq_to_bam.sh
