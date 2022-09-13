#!/usr/bin/env bash

# Make sure to download actinopterygii database from BUSCO https://busco-data.ezlab.org/v4/data/lineages/
# install the database

dammit databases --database-dir /home/lisette/bioinformatic-tools/databases \
--install --busco-group actinopterygii

#run dammit to the assembly.fasta file
dammit annotate assemblyX.ORP.fasta --n_threads 8 --busco-group actinopterygii --database-dir /home/lisette/bioinformatic-tools/databases

# dammit will output 2 main files: *ORP.fasta.dammit.fasta, *ORP.fasta.dammit.gff3
# obtain the file with the seqid and gene name following the tutorial: https://dibsi-rnaseq.readthedocs.io/en/latest/dammit_annotation.html

cd ORP.nema.fasta.dammit
python
import pandas as pd
from dammit.fileio.gff3 import GFF3Parser
gff_file = "assemblyX.ORP.fasta.dammit.gff3"
annotations = GFF3Parser(filename=gff_file).read()
names = annotations.sort_values(by=['seqid', 'score'], ascending=True).query('score < 1e-05').drop_duplicates(subset='seqid')[['seqid', 'Name']]
new_file = names.dropna(axis=0,how='all')
new_file.head()
new_file.to_csv("assemblyX_annotation.csv")
exit()
