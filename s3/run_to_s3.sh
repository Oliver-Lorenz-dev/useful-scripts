#!/bin/bash

BUCKET="s3://vo_agam_output"

# give all files sample names if they do not have any already and upload to s3
while read -r path val
do
    filename=$(echo $path | sed 's:.*/::')
    val=$(echo $val | sed 's/\n//g')
    if [[ "$filename" =~ .*"$val"*. ]]; then
        s3command=$(echo s3cmd put $path ${BUCKET}/$filename)
        $s3command
        if $s3command ; then
            succeded=true
        else
            echo $s3command >> dt-190-failures.txt
        fi
    else
        s3command=$(echo s3cmd put $path ${BUCKET}/"$val.$filename")
        $s3command
        if $s3command ; then
            succeded=true
        else
            echo $s3command >> dt-190-failures.txt
        fi
    fi
done < query_result_final.txt
