/*analysis_vcfs: summarizes vcf files created by freebayes or snpeff

input:
    val(snpeff)
    path to collected vcf files

output:
    path: results_vcfs file (.tsv)
*/

process analysis_vcfs {
    container "my_rocker:1.1.0"

    input:
        val(snpeff)
        path(vcfs)
        
    output:
        path("results_vcfs.tsv"), emit: results_vcfs

    script:
    
        def tag = snpeff ? '_annotated' : ''

        """
        #!/usr/bin/Rscript

        library("vcfR")
        library("dplyr")
        library("data.table")

        tag = "${tag}"

        listvcf <- list.files(".", pattern= paste0("_results", tag, ".vcf"), full.names = TRUE)

        data_vcfs <- lapply(listvcf, function(x){
            id <- sub(paste0("_results", tag, ".vcf"), "", basename(x)) #select names of samples from file names
            vcf <- read.vcfR(x, verbose = FALSE)  #read vcf files
            df <- as.data.frame(getFIX(vcf)) #extract basic information
            if (nrow(df) > 0) { 
                df["sample"] <- "TRUE"    #create new column with TRUE value to indicate presence of the variant
                names(df)[names(df) == "sample"] <- id #add sample name to dataframe
                df <- df[,c(1,2,4,5,8)]
                if (tag == "_annotated") {
                    df["ANN"] <- extract.info(vcf, element = "ANN")
                }
                df
            } else {
                NULL
            }
            df
        })

        data_vcfs[sapply(data_vcfs,is.null)] <- NULL

        #combine all dataframes from the list, full_join
        finaldf <- Reduce(full_join, data_vcfs)
        #substitute NAs for FALSE
        finaldf[is.na(finaldf)] <- FALSE
        if (tag == "_annotated") {
            finaldf <- finaldf %>% select(-"ANN","ANN")
        }
        finaldf

        #export file
        fwrite(finaldf, "results_vcfs.tsv", sep="\t")                
        """
}