#!/usr/bin/bash

#Fail on error
set -o errexit
#Fail on error in subcommands
set -o errtrace
#Fail on errors in pipes
set -o pipefail
#Fail on unset variable
set -o nounset
#Print trace info
set -o xtrace

#basename
i=$1

mkdir sortmerna_${i}

echo "Running SortMeRNA for ${i}"
sortmerna \
  --ref /home/lisette/bioinformatic-tools/sortmerna/db/rfam-5.8s-database-id98.fasta \
  --ref /home/lisette/bioinformatic-tools/sortmerna/db/rfam-5s-database-id98.fasta \
  --ref /home/lisette/bioinformatic-tools/sortmerna/db/silva-arc-16s-id95.fasta \
  --ref /home/lisette/bioinformatic-tools/sortmerna/db/silva-arc-23s-id98.fasta \
  --ref /home/lisette/bioinformatic-tools/sortmerna/db/silva-bac-16s-id90.fasta \
  --ref /home/lisette/bioinformatic-tools/sortmerna/db/silva-bac-23s-id98.fasta \
  --ref /home/lisette/bioinformatic-tools/sortmerna/db/silva-euk-18s-id95.fasta \
  --ref /home/lisette/bioinformatic-tools/sortmerna/db/silva-euk-28s-id98.fasta \
  --reads ${i}_R1.fq.gz \
  --reads ${i}_R2.fq.gz \
  --workdir /home/lisette/RNAseq/Brain/sortmerna_${i}/\
  --out2 \
  --fastx \
  --threads 8 -m 4000\
  --paired_in \
  --other "${i}_sortmerna" |&
  tee /home/lisette/RNAseq/Brain/${i}_sortmerna.log

pigz -p8 ${i}_sortmerna_fwd.fq
pigz -p8 ${i}_sortmerna_rev.fq
