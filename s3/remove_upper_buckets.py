#!/usr/bin/env python3

# for deleting upper case buckets (after running copy_upper_case_s3bucket.py)
import os, sys

with open ("buckets.txt", 'r') as f:
        data = f.readlines()
        for line in data:
            upper_bucket = line.strip()
            # empty bucket
            empty_bucket_command = "s3cmd del --recursive " + upper_bucket
            os.system(empty_bucket_command)
            # delete bucket
            delete_bucket_command = "s3cmd rb " + upper_bucket
            os.system(delete_bucket_command)
