#!/bin/bash

# this script performs a basic check to see if a zarr file is populated with calldata or not

# very high level check to see if zarr has any calldata
check_zarr_high_level () {
   echo "Performing high level check on ${1}..."
   echo
   call_data_count=$( unzip -l $1 | awk '{ print $4 }' | grep calldata | wc -l)
   if [ $call_data_count == 0 ]; then
      echo "${1} has no calldata! High level check failed!"
      high_level_fail=true
   else
      echo "${1} has passed the high level check!"
      high_level_fail=false
   echo
   fi
}

# check if each individual contig has any calldata
check_individual_contigs_high_level () {
   echo "Checking contigs at high level for ${1}..."
   echo
   contigs=$(unzip -l $1 | awk '{ print $4 }' | awk -F/ '{print $2}' | grep -v ".zgroup" | sort -u)
   for contig in $contigs
   do
     call_data_count=$(unzip -l $1 | grep $contig | grep calldata | wc -l)
     if [ $call_data_count == 0 ]; then
       echo "${contig} has no calldata!"
     fi
   done
}

# check if contigs have a reasonable amount of population
# IMPORTANT: IF THEY DON'T HAVE, IT IS NOT NECESSARILY A PROBLEM, DEPENDS ON CONTIG LENGTH
check_individual_contigs_mid_level () {
   echo "Checking contigs at mid level for ${1}..."
   echo
   contigs=$(unzip -l $1 | awk '{ print $4 }' | awk -F/ '{print $2}' | grep -v ".zgroup" | sort -u)
   for contig in $contigs
   do
     call_data_count=$(unzip -l $1 | grep $contig | grep calldata | grep -v ".zgroup" |  wc -l)
     number_of_variants=$(unzip -l $1 | grep Y_unplaced | grep calldata | grep -v ".zgroup" | awk '{ print $4 }' | awk -F/ '{ print $4 }' | sort -u | wc -l)
     if (( $call_data_count <= (( $number_of_variants * 3 )) )); then
       echo "${contig} has a low amount of calldata.. please check this contig manually!"
     fi
   done
}

for f in *.zarr.zip
do
  check_zarr_high_level $f
  if [ $high_level_fail = true ]; then
    echo "----------------------------------------------------------------------"
    continue
  fi
  check_individual_contigs_high_level $f
  echo "Finished checking contigs at high level for ${f}"
  echo
  check_individual_contigs_mid_level $f
  echo "Finished checking contigs at mid level for ${f}"
  echo
  echo "----------------------------------------------------------------------"
  sleep 5
done


