rm(list=ls(all=TRUE))
options(stringsAsFactors=FALSE)
graphics.off()
  
setwd("/home/working/")

args = commandArgs(trailingOnly=TRUE)

inputfile = args[1]
outputfile = args[2] 
martfile = "./mart_export.txt"

FD <- read.delim(inputfile,sep = ",",check.names=FALSE)
rownames(FD) = FD$RSID
colnames(FD) = c("Variant_name","CHROMOSOME","POSITION","Variant_alleles")
FD$CHROMOSOME = NULL
FD$POSITION = NULL

data <- read.delim(mart_file,sep = "\t",check.names=FALSE)
data$"Variant alleles" = gsub("/","",data$"Variant alleles")
colnames(data) = gsub(" ","_",colnames(data))
data = data[data$Variant_alleles %in% FD$Variant_alleles,]
data = data[data$Phenotype_description !="",]

merged = merge(data,FD)
merged = merged[order(merged$P_value,decreasing=FALSE),]

write.table(merged,outputfile,sep="\t",quote=FALSE,row.names=FALSE)

