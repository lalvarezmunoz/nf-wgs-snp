setwd("C:/git/nf-wgs-snp/results/vcf_files")

library("vcfR")
library("dplyr")
library("data.table")


#list files
listvcf <- list.files("C:/git/nf-wgs-snp/results/vcf_files", pattern= ".vcf", full.names = TRUE)

data_vcfs <- lapply(listvcf, function(x){
  id <- sub("_results.vcf", "", sub("C:/git/nf-wgs-snp/results/vcf_files/", "", x)) #select names of samples from file names
  vcf <- read.vcfR(x, verbose = FALSE)  #read vcf files
  df <- as.data.frame(getFIX(vcf)) #extract basic information
  df$sample <- "TRUE"    #create new column with TRUE value to indicate presence of the variant
  names(df)[names(df) == "sample"] <- id #add sample name to dataframe
  df <- df[,c(1,2,4,5,8)]
})

#combine all dataframes from the list, full_join
finaldf <- Reduce(full_join, data_vcfs)
#substitute NAs for FALSE
finaldf[is.na(finaldf)] <- FALSE

#export file
fwrite(finaldf, "all_variants.tsv", sep="\t")
