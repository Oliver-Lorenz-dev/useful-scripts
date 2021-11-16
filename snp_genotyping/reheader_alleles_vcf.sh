#!/bin/bash

# load modules
module load bcftools/1.9--h68d8f2e_9 samtools/1.9

usage() {
  cat <<EOT
Usage: ./$(basename $0) <OPTION>...
       Reheaders and reindexes the ag.allsites.nonN.vcf.gz generated from:
       https://gitlab.internal.sanger.ac.uk/sanger-pathogens/pipelines/scripts/-/tree/master/anopheles_genome_processor

       -a,
       The alleles file - (ag.allsites.nonN.vcf.gz) (mandatory)


EOT
}

if [[ "$#" == "0" ]]; then
    usage
    exit 0
fi

while getopts "a:" arg;
do
    case $arg in
      a) alleles_file="${OPTARG}";;
    esac
done

if  [ ! ${alleles_file} ]; then
    echo "alleles file (-a) is a mandatory argument, please ensure it is supplied using: -a <alleles_file>"
    echo ""
    usage
    exit 0
fi

# validate file paths
validate_filepath () {
    if [[ -d $1 ]]; then
      path_valid=true
    elif [[ -f $1 ]]; then
      path_valid=true
    else
      echo "$1 is not a valid filepath!"
      exit 1
  fi
}

validate_filepath $alleles_file

# create header.hr file
echo "Unzipping alleles file..."
gunzip $alleles_file
uncompressed_alleles_file=${alleles_file::-3}
echo " "

echo "Generating header..."
head -2 $uncompressed_alleles_file > header.hr
sed '1d' $uncompressed_alleles_file | awk '{print $1}' | sort | uniq -c | sort -rnk1 | awk '{print "##contig=<ID="$2",length="$1">"}' >> header.hr
bcftools view -h $uncompressed_alleles_file | grep "#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO"  >> header.hr
echo " "

# reheader alleles file
echo "Reheadering alleles file..."

# have to reheader to separate file here to avoid overwriting orignal and losing both files
bcftools reheader -h header.hr $uncompressed_alleles_file > $uncompressed_alleles_file"_reheader"

# move back to original filename - OVERWRITES ORIGINAL FILE W/O HEADER
mv $uncompressed_alleles_file"_reheader" $uncompressed_alleles_file
echo " "

# compress alleles file
echo "Compressing alleles file..."
bgzip $uncompressed_alleles_file
echo " "

# index alleles file
echo "Indexing alleles file..."
bcftools index -t $alleles_file

# cleanup
rm header.hr
