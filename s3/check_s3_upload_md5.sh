#!/bin/bash

# script takes in a file containing lustre paths in the same order as files on the s3 bucket
# to get that order files by sample name - samples may be off simlinks or a sql query

usage() {
  cat <<EOT
Usage: ./$(basename $0) <OPTION>...
       Checks md5sum of s3 upload -
       Script takes a file containing lustre paths of the same order as files on the s3 bucket.
       To get that order files by sample name - samples may be off simlinks or a sql query
       -b,
       The name of the s3 bucket - s3://<bucket_name> (mandatory)

       -l,
       File containing all of the local filepaths (vcf filepaths) (mandatory)

EOT
}

if [[ "$#" == "0" ]]; then
    usage
    exit 0
fi

while getopts "n:i:r:" arg;
do
    case $arg in
      n) bucket="${OPTARG}";;
      i) local_files="${OPTARG}";;
    esac
done

# check if files exist and remove if they do
check_filepath () {
    if [[ -f $1 ]]; then
      rm $1
  fi
}

check_filepath $bucket
check_filepath $local_files

# get s3 md5s
s3cmd ls --list-md5 $bucket > md5s_s3.txt

# get lustre md5s
while read -r LINE
do
   echo "md5sum $LINE" >> md5s_lustre.txt
done > $local_files

# compare md5s
check_filepath md5_differences.txt
awk 'NR==FNR{c[$1]++;next};c[$2] == 0' md5s_lustre.txt md5s_s3.txt >> md5_differences.txt

