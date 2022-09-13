# RNAseq-Gmaculatus

Brief overview of the pipeline used to analyzed RNAseq data of Galaxias maculatus' gill

Analyses were performed on a linux computer or Compute Canada (in the case the analyses were computational intensive).
First, the quality of reads were checked using FastQC (Andrews 2010), then rRNA was removed using SortMeRNA (Kopylova et al. 2012) and reads were trimmed using trimmomatic (Bolger et al. 2014).
Before performing the de novo transcriptome assembly, the samples selected were further checked for sequencing error using Rcorrector (Song & Florea 2015). The assembly was performed using Oyster River Protocol (ORP) (MacManes 2008). The assembly “correctness” and “completeness” was tested using Transrate (Smith-Unna et al. 2016) and Busco (Seppey et al. 2019). Finally, the de novo transcripome annotation was done using the software dammit (Scott 2016).
Sample reads were pseudo-aligned to the new reference transcriptome using Salmon (Patro et al. 2017)) and finally, the differential gene expression analysis was performed in R with the package DeSeq2 (Love et al. 2014).

![RNAseqPipeline](https://user-images.githubusercontent.com/109176403/189930012-83f0f54a-6faa-49cc-81f3-040e1d401e5f.png)
