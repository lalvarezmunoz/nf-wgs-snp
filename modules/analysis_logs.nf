/*analysis_logs: summarizes log files created by flagstat from the BWA-MEM alignment

input:
    str: path to log files (????)

output:
    path: results_logs file (.tsv)
*/

process report {
    container "lalvarezmunoz/my_rocker:1.0.0" //here goes the container, rocker with data.table

    input:
        path(logs)
        
    output:
        path("results_logs.tsv"), emit: results_logs

    script:
        """
        #!/usr/local/bin/Rscript

        bwalogs <- list.files("${logs}", pattern= "_bwa_stats.txt", full.names = TRUE)

        # extract data from log files: id, total reads, mapped reads
        data_bwa <- lapply(bwalogs, function(x){
            id <- sub("_bwa_stats.txt", "", sub("${logs}", "", x)) #select names of samples from file names
            file <- readLines(x)  #read bwa log files
            totalreads <- as.numeric(sub(" +(.*)", "", file[1]))
            mappedreads <- as.numeric(sub(" +(.*)", "", file[7]))
            read_num <- c("id" = id, "total_reads" = totalreads, "mapped_reads" = mappedreads)
        })

        # prepare dataframes
        df <- data.frame(t(sapply(data_bwa,c)))
        df$$total_reads <- as.numeric(df$$total_reads)
        df$$mapped_reads <- as.numeric(df$$mapped_reads)

        # export data
        fwrite(df, "results_logs.tsv", sep="\t")
        """
}