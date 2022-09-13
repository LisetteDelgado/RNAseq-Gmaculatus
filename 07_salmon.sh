#!/usr/bin/env bash

set -euxo pipefail
set -o errtrace

# do we have arguments
if [ $# -ne 2 ]; then
    echo "This script expects two arguments: fwd fastq, rev fastq"\
    exit 1
fi

# fwd exists?
if [ ! -f $1 ]; then
    echo "The first argument must be an existing file"\
    exit 1
fi

# rev exists?
if [ ! -f $2 ]; then
    echo "The second argument must be an existing file"\
    exit 1
fi

# only once need to get the index of the assembly

salmon index -t assembly.ORP.fasta -i assembly_index

# make sure to modified the assembly_index name
# run salmon

salmon quant -l A \
-i assembly_index \
-1 $1 -2 $2 \
-o salmon_output/$(basename ${1/_sortmerna_trimmomatic_1.fq.gz/}) --seqBias --gcBias -p 8
