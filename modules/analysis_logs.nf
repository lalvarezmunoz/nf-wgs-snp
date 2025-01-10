/*analysis_logs: summarizes log files created by flagstat from the BWA-MEM alignment

input:
    path: to collected flagstat log files

output:
    path: results_logs file (.tsv)
*/

process analysis_logs {
    container "my_rocker:1.1.0"

    input:
        path(logs)
        
    output:
        path("results_logs.tsv"), emit: results_logs

    script:
        """
        #!/usr/bin/Rscript

        library(data.table)

        bwalogs <- list.files(".", pattern= "_bwa_stats.txt", full.names = TRUE)

        # extract data from log files: id, total reads, mapped reads
        data_bwa <- lapply(bwalogs, function(x){
            id <- sub("_bwa_stats.txt", "", basename(x)) #select names of samples from file names
            file <- readLines(x)  #read bwa log files
            totalreads <- as.numeric(sub(" +(.*)", "", file[1]))
            mappedreads <- as.numeric(sub(" +(.*)", "", file[7]))
            return(list(id = id, total_reads = totalreads, mapped_reads = mappedreads))
        })

        # prepare dataframes
        df <- rbindlist(data_bwa)

        # export data
        fwrite(df, "results_logs.tsv", sep="\t")
        """
}