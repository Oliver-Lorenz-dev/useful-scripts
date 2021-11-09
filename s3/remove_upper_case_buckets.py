#!/usr/bin/env python3

# s3cmd ls | grep '[A-Z]' | awk '{print $3}' to get upper case buckets
# script creates lower case bucket and syncs it with original upper case bucket
# deletions to be done manually

import os, sys

with open ("buckets.txt", 'r') as f:
        data = f.readlines()
        for line in data:
            upper_bucket = line.strip()
            lower_bucket = upper_bucket.lower()
            # make lower case bucket
            make_new_bucket_cmd = "s3cmd mb " + lower_bucket
            os.system(make_new_bucket_cmd)
            # sync uppercase bucket with lower case bucket
            sync_buckets_cmd = "s3cmd sync " + upper_bucket + " " + lower_bucket
            os.system(sync_buckets_cmd)
