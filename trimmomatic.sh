#!/usr/bin/bash

# Make sure the adapter.fa file is in the directory where you are running the script
# adapter.fa must include:
	#>adapter1
	#AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC
	#>adapter2
	#AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT

# loop through list of samples

File = "FileWSampleNames.txt"

for name in $(cat $File)

do

	java -jar /home/lisette/bioinformatic-tools/Trimmomatic-0.39/trimmomatic-0.39.jar PE -phred33 -threads 8 "$name"_sortmerna_fwd.fastq.gz "$name"_sortmerna_rev.fastq.gz "$name"_sortmerna_forward_paired.fq "$name"_sortmerna_forward_unpaired.fq "$name"_sortmerna_reverse_paired.fq "$name"_sortmerna_reverse_unpaired.fq ILLUMINACLIP:adapter.fa:2:30:10 SLIDINGWINDOW:5:20 MINLEN:50

# gz output files
pigz -p8 "$name"_sortmerna_forward_paired.fq
pigz -p8 "$name"_sortmerna_reverse_paired.fq
