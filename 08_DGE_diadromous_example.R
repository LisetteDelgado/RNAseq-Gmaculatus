library(DESeq2)
library("lattice")
library(tximport)
library(readr)
library(RColorBrewer)
library(gplots)
source('/home/lisette/RNAseq/scripts-rnaseq/plotPCAWithSampleNames.R')

#make sure set the working directory where the salmon output files are located
setwd("salmon_quant")
dir<-'~/RNAseq/Gills/'

#get a list of files from with salmon outputs
files_list = list.files()
files_list
files <- file.path(dir, "salmon_output",files_list, "quant.sf")
names(files) <- c("01GillS01", "02GillS61", "03GillS62", "04GillS63", "07GillS82", "08GillS23", "09GillS24", "10GillS25", "11GillS27", "12GillS28", "13GillS68", "14GillS87")
files
print(file.exists(files))

#get the list of genes and transcript ids
tx2gene <- read.csv("~/RNAseq/Gills/Dia_FWvsSW/new_assemnly_gene_name_id.csv")
tx2gene <- tx2gene[,c(2,3)]
cols<-c("transcript_id","gene_id")
colnames(tx2gene)<-cols
head(tx2gene)

txi.salmon <- tximport(files , type = "salmon", tx2gene = tx2gene, importer=read.delim)
head(txi.salmon$counts)
dim(txi.salmon$counts)

#set the conditions in the same order as the list of samples
condition = factor(c("FW","FW","FW","FW","FW","SW","SW","SW","SW","SW","SW","SW")) 
ExpDesign <- data.frame(row.names=colnames(txi.salmon$counts), population = condition)
ExpDesign

dds <- DESeqDataSetFromTximport(txi.salmon, ExpDesign, ~population)
#in this case FW will be the reference
dds$population<-relevel(dds$population,ref="FW")
dds <- DESeq(dds, betaPrior=FALSE)

matrix(resultsNames(dds))
# results:
#"Intercept"
#"population_SW_vs_FW" 

# get counts
counts_table = counts( dds, normalized=TRUE )

filtered_norm_counts<-counts_table[!rowSums(counts_table==0)>=1, ]
filtered_norm_counts<-as.data.frame(filtered_norm_counts)
GeneID<-rownames(filtered_norm_counts)
filtered_norm_counts<-cbind(filtered_norm_counts,GeneID)
dim(filtered_norm_counts)
head(filtered_norm_counts)

plotDispEsts(dds)

log_dds<-rlog(dds)

#get a PCA
pdf(file = "PCA_Dia_SWandFW.pdf")
plotPCAWithSampleNames(log_dds, intgroup="population", ntop=42670)
dev.off()

#comparissons two conditions
res<-results(dds, name="Intercept")
res1<-results(dds, name="population_SW_vs_FW")
#replace with:
#"Intercept"
#"population_SW_vs_FW" 

#For population_SW_vs_FW, can do the same for the intercept, just replace res1 for res
head(res1)
res1_ordered<-res1[order(res1$padj),]
GeneID<-rownames(res1_ordered)
res1_ordered<-as.data.frame(res1_ordered)
res1_genes<-cbind(res1_ordered,GeneID)
dim(res1_genes)
head(res1_genes)
dim(res1_genes)
res1_genes_merged <- merge(res1_genes,filtered_norm_counts,by=unique("GeneID"))
dim(res1_genes_merged)
head(res1_genes_merged)
res1_ordered<-res1_genes_merged[order(res1_genes_merged$padj),]
write.csv(res1_ordered, file="population_SW_vs_FW.csv" )

res1Sig = res1_ordered[res1_ordered$padj < 0.01, ]
res1Sig = res1Sig[res1Sig$log2FoldChange > 1 | res1Sig$log2FoldChange < -1,]
write.csv(res1Sig,file="population_SW_vs_FW_padj0.01.csv")

plot(log2(res1_ordered$baseMean), res1_ordered$log2FoldChange, col=ifelse(res1_ordered$padj < 0.01, "red","gray67"),main="population_SW_vs_FW(padj<0.01)",xlim=c(1,20),pch=20,cex=1,ylim=c(-12,12))
genes1<-res1Sig$GeneID
mygenes1 <- res1Sig[,]
baseMean_mygenes1 <- mygenes1[,"baseMean"]
log2FoldChange_mygenes1 <- mygenes1[,"log2FoldChange"]
text(log2(baseMean_mygenes1),log2FoldChange_mygenes1,labels=genes1,pos=2,cex=0.60)

#heatmap
d1<-res1Sig
dim(d1)
head(d1)
colnames(d1)
d1<-d1[,c(7:21)]
d1<-as.matrix(d1)
d1<-as.data.frame(d1)
d1<-as.matrix(d1)
rownames(d1) <- res1Sig[,1]
head(d1)

hr <- hclust(as.dist(1-cor(t(d1), method="pearson")), method="complete")
mycl <- cutree(hr, h=max(hr$height/1.5))
clusterCols <- rainbow(length(unique(mycl)))
myClusterSideBar <- clusterCols[mycl]
myheatcol <- greenred(75)
#myheatcol <- colorRampPalette(c("red", "green"))(n = 75)
pdf(file = "Heatmap_Dia_SWandFW.pdf")
heatmap(d1, main="population_SW_vs_FW(padj<0.01)", 
        Rowv=as.dendrogram(hr),
        cexRow=0.75,cexCol=0.8,srtCol= 90,
        adjCol = c(NA,0),offsetCol=2.5, 
        Colv=NA, dendrogram="row", 
        scale="row", col=myheatcol, 
        density.info="none", 
        trace="none", RowSideColors= myClusterSideBar)
dev.off()