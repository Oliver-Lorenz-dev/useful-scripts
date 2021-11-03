#!/usr/bin/env python3

"""USAGE: ls -l > filepaths.txt on a symlink directory, delete first line, then ./upload_to_s3.py"""

import os, sys
bucket = "s3://vo_agam_output"

with open ("filepaths.txt", 'r') as f:
	data = f.readlines()
	for line in data:
		sample_id_file = line.split(" ")
		sample_id_file = sample_id_file[9]
		sample_id_file = sample_id_file.strip()
		filepath = line.split(" ")
		filepath = filepath[11]
		filepath = filepath.strip()
		s3command = "s3cmd put " + filepath + " s3://vo_agam_output"  + sample_id_file
		os.system(s3command)
