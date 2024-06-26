library("dplyr")
library("ggplot2")
library("reshape2")
library("data.table")

setwd("C:/git/nf-wgs-snp/results/logs")

##### batch read bwa log files ################################
bwalogs <- list.files("C:/git/nf-wgs-snp/results/logs", pattern= "_bwa_stats.txt", full.names = TRUE)

data_bwa <- lapply(bwalogs, function(x){
  id <- sub("_bwa_stats.txt", "", sub("C:/git/nf-wgs-snp/results/logs/", "", x)) #select names of samples from file names
  file <- readLines(x)  #read bwa log files
  totalreads <- as.numeric(sub(" +(.*)", "", file[1]))
  mappedreads <- as.numeric(sub(" +(.*)", "", file[7]))
  read_num <- c("id" = id, "total_reads" = totalreads, "mapped_reads" = mappedreads)
})

df1 <- data.frame(t(sapply(data_bwa,c)))
df1$total_reads <- as.numeric(df1$total_reads)
df1$mapped_reads <- as.numeric(df1$mapped_reads)

#export data
fwrite(df1, "bwa_results.tsv", sep="\t")

####################################
###### PLOT ALIGNED  READS #########
####################################

mdf <- melt(df1, id = "id")

myplot <- ggplot(mdf,aes(x=id,y=value,fill=variable)) +
  geom_bar(stat="identity",position = "identity") +
  scale_fill_manual(values = c("aquamarine3", "cornflowerblue"))
myplot

ggsave((filename = "bwa_barchart.pdf"), width = 15, height = 5, units = c("in"))

