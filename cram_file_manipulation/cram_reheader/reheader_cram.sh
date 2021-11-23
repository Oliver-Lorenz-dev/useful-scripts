#!/bin/bash

# load modules
module load samtools/1.9

# generate new header
for file in /lustre/scratch118/infgen/pathdev/ol6/DT-236/fastq_copy/*.cram; do
FILENAME=`basename ${file%%.*}`
echo $FILENAME
samtools view -H $file > header.hr
head -1 header.hr > header
head -1 id.txt >> header
tail -n +2 header.hr >> header
sed -i "s/20307_3#27/$FILENAME/g" header
samtools reheader header $file > $file"_reheader"
samtools reheader -i header $file"_reheader"
mv $file"_reheader" $file
done

# for some reason the -i option will only work if you
# have already reheadered the cram before
# idk why, odd!
