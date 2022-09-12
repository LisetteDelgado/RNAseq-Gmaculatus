#!/usr/bin/bash

##Transrate

#first unzip one samples used to build the assembly

gzip -d -c GillSX_sortmerna_forward_paired.cor.fq.gz > GillSX_sortmerna_forward_paired.cor.fq
gzip -d -c GillSX_sortmerna_reverse_paired.cor.fq.gz > GillSX_sortmerna_reverse_paired.cor.fq

#run transrate by selecting one of the samples used to build the assembly

transrate \
  --assembly=assemblyX_ORP.fasta \
  --left=GillSX_sortmerna_forward_paired.cor.fq \
  --right=GillSX_sortmerna_reverse_paired.cor.fq |& tee transrate.log

##Busco

#make sure to download the database in this case: actinopterygii

busco -i assemblyX_ORP.fasta -c 8 -o busco_assemblyX.ORP -m tran --long -l actinopterygii_odb10
