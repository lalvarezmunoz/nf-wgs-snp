library("data.table")

# for tests:
setwd("C:/git/nf-wgs-snp/test/results")
bwalogs <- list.files("C:/git/nf-wgs-snp/test/results/logs", pattern= "_bwa_stats.txt", full.names = TRUE)

# extract data from log files: id, total reads, mapped reads
data_bwa <- lapply(bwalogs, function(x){
  id <- sub("_bwa_stats.txt", "", sub("C:/git/nf-wgs-snp/test/results/logs/", "", x)) #select names of samples from file names
  file <- readLines(x)  #read bwa log files
  totalreads <- as.numeric(sub(" +(.*)", "", file[1]))
  mappedreads <- as.numeric(sub(" +(.*)", "", file[7]))
  read_num <- c("id" = id, "total_reads" = totalreads, "mapped_reads" = mappedreads)
})

# prepare dataframes
df1 <- data.frame(t(sapply(data_bwa,c)))
df1$total_reads <- as.numeric(df1$total_reads)
df1$mapped_reads <- as.numeric(df1$mapped_reads)

# export data
fwrite(df1, "bwa_results.tsv", sep="\t")