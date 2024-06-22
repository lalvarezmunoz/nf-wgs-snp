library("dplyr")
library("ggplot2")
library("reshape2")

##### batch read cutadapt and bowtie log files ################################
bwalogs <- list.files("C:/git/nf-wgs-snp/results/logs", pattern= "_bwa_stats.txt", full.names = TRUE)

data_bwa <- lapply(bwalogs, function(x){
  file <- readLines(x)  #read bwa log files
  id <- sub("Command line parameters: -m 15 -o (.*)_step3_cutadapt.*", "\\1", file)
  total <- as.numeric(gsub(",", "", sub("Total reads processed:[[:space:]]+(.*)", "\\1", file)))
  total <- total[!is.na(total)]
  trimmed <- as.numeric(gsub(",", "", sub("Reads written \\(passing filters\\):[[:space:]]+(.*) \\(.*", "\\1", file)))
  trimmed <- trimmed[!is.na(trimmed)]
  read_num <- c("id" = id[2], "total" = total, "trimmed" = trimmed)
})

myfiles2 <- list.files("C:/git/nf-tnseq/results/bowtie2", pattern= "_BowtieMAP.log", full.names = TRUE)

data_bowtie2 <- lapply(myfiles2, function(x){
  file <- readLines(x)  #read Bowtie log files
  id <- sub("Warning: Output file '(.*)_BowtieMAP.txt.*", "\\1", file)
  
  aligned1 <- as.numeric(sub("[[:space:]]+(.*) \\(.*\\) aligned exactly 1 time", "\\1", file))
  aligned1 <- aligned1[!is.na(aligned1)]
  
  aligned2 <- as.numeric(sub("[[:space:]]+(.*) \\(.*\\) aligned >1 times", "\\1", file))
  aligned2 <- aligned2[!is.na(aligned2)]
  read_num <- c("id" = id[1], "aligned" = aligned1 + aligned2)
})

#combine data into single dataframe
df1 <- data.frame(t(sapply(data_cutadapt,c)))
df2 <- data.frame(t(sapply(data_bowtie2,c)))

finaldata <- left_join(df1, df2, by = "id")
finaldata[,c(2:4)] <- sapply(finaldata[,c(2:4)], as.numeric)



####################################
###### PLOT ALIGNED  READS #########
####################################

mdf <- melt(finaldata, id = "id")

myplot <- ggplot(mdf,aes(x=id,y=value,fill=variable)) +
  geom_bar(stat="identity",position = "identity") +
  scale_fill_manual(values = c("aquamarine3", "cornflowerblue", "mediumpurple4"))
myplot