rm(list=ls(all=TRUE))
options(stringsAsFactors=FALSE)
graphics.off()
  
wd = getwd()
setwd(wd)
args = commandArgs(trailingOnly=TRUE)

file_name = args[1]

inputfile = paste(wd, "/app/database/input/", args[1], sep="")
outputfile = paste(wd, "/app/database/output/", args[1], sep="")
martfile = paste(wd, "/app/database/mart_export.txt", sep="")

file.create(outputfile)

FD <- read.delim(inputfile,sep = ",",check.names=FALSE)
rownames(FD) = FD$RSID
colnames(FD) = c("Variant_name","CHROMOSOME","POSITION","Variant_alleles")
FD$CHROMOSOME = NULL
FD$POSITION = NULL

data <- read.delim(martfile,sep = "\t",check.names=FALSE)
data$"Variant alleles" = gsub("/","",data$"Variant alleles")
colnames(data) = gsub(" ","_",colnames(data))
data = data[data$Variant_alleles %in% FD$Variant_alleles,]
data = data[data$Phenotype_description !="",]

merged = merge(data,FD)
merged = merged[order(merged$P_value,decreasing=FALSE),]

write.table(merged,outputfile,sep="\t",quote=FALSE,row.names=FALSE)

