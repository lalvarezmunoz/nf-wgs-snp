/*report: renders an Rmarkdown report to html summarizing pipeline results

input:
    str: path to Rmd template (.Rmd)
    str: path to results_logs output (.tsv)
    str: path to results_vcfs output (.tsv)

output:
    path: report file (.html)
*/

process report {
    container "lalvarezmunoz/my_rocker:1.2.1"

    input:
        path(template)
        path(results_logs)
        path(results_vcfs)
        
    output:
        path("report.html"), emit: summary

    script:
        """
        #!/usr/bin/Rscript
   #     file.copy("${template}", paste0(getwd(), "/template.Rmd"))
   #     file.copy("${results_logs}", paste0(getwd(), "/logs.tsv"))              #need to be rechecked
   #     file.copy("${results_vcfs}", paste0(getwd(), "/vcfs.tsv"))              #need to be rechecked
        rmarkdown::render(
            input = "${template}",
            envir = new.env(),
            params = list(
                results_logs = "${results_logs}",
                results_vcfs = "${results_vcfs}"
            ),
            knit_root_dir = getwd(),
            output_dir = getwd(),
            output_file = "report.html"
        )
        """
}