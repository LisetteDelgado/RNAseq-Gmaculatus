#!/usr/bin/bash

# ONLY for samples that will be used for the assembly

# loop through list of samples

File = "FileWSampleNames.txt"

for name in $(cat $File)

do

	perl ~/bioinformatic-tools/Rcorrector/run_rcorrector.pl -1 "$name"_sortmerna_forward_paired.fq.gz -2 "$name"_sortmerna_reverse_paired.fq.gz -t 8

done

