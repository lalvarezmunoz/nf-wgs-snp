library("data.table")

# for tests:
setwd("C:/git/nf-wgs-snp/test/resultsDani")
bwalogs <- list.files("C:/git/nf-wgs-snp/test/resultsDani/logs", pattern= "_bwa_stats.txt", full.names = TRUE)

# extract data from log files: id, total reads, mapped reads
data_bwa <- lapply(bwalogs, function(x){
  id <- sub("_bwa_stats.txt", "", sub("C:/git/nf-wgs-snp/test/resultsDani/logs/", "", x)) #select names of samples from file names
  file <- readLines(x)  #read bwa log files
  totalreads <- as.numeric(sub(" +(.*)", "", file[1]))
  mappedreads <- as.numeric(sub(" +(.*)", "", file[7]))
  read_num <- c("id" = id, "total_reads" = totalreads, "mapped_reads" = mappedreads)
})

# prepare dataframes
df <- data.frame(t(sapply(data_bwa,c)))
df$total_reads <- as.numeric(df$total_reads)
df$mapped_reads <- as.numeric(df$mapped_reads)

# export data
fwrite(df, "bwa_results.tsv", sep="\t")