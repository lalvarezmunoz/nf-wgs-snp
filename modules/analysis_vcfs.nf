/*report: renders an Rmarkdown report to html summarizing pipeline results

input:
    val: if snpeff parameter was used or not (snpeff)
    str: path to vcf files (????)

output:
    path: results_vcfs file (.tsv)
*/

process report {
    container "lalvarezmunoz/my_rocker:1.0.0" //here goes the container, rocker with rmarkdown

    input:
        val(snpeff)
        path(vcfs)
        
    output:
        path("results_vcfs.tsv"), emit: results_vcfs

    script:
        """
        #!/usr/local/bin/Rscript

        if (params.snpeff) {
            tag = "_annotated"
        } else {
            tag = ""
        }

        listvcf <- list.files("${vcfs}", pattern= "_results"tag".vcf", full.names = TRUE)

        data_vcfs <- lapply(listvcf, function(x){
            id <- sub("_results"tag".vcf", "", sub("${vcfs}", "", x)) #select names of samples from file names
            vcf <- read.vcfR(x, verbose = FALSE)  #read vcf files
            df <- as.data.frame(getFIX(vcf)) #extract basic information
            if (nrow(df) > 0) { 
                df$$sample <- "TRUE"    #create new column with TRUE value to indicate presence of the variant
                names(df)[names(df) == "sample"] <- id #add sample name to dataframe
                df <- df[,c(1,2,4,5,8)]
                if (params.snpeff) {
                    df$$ANN <- extract.info(vcf, element = "ANN")
                    }
                df
            } else {
                NULL
            }
        })

        data_vcfs[sapply(data_vcfs,is.null)] <- NULL

        #combine all dataframes from the list, full_join
        finaldf <- Reduce(full_join, data_vcfs)
        #substitute NAs for FALSE
        finaldf[is.na(finaldf)] <- FALSE
        finaldf <- finaldf %>% select(-"ANN","ANN")

        #export file
        fwrite(finaldf, "all_variants.tsv", sep="\t")                
        """
}