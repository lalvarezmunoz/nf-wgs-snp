/*report: renders an Rmarkdown report to html summarizing pipeline results

input:
    str: path to Rmd template (.Rmd)
    str: path to results_logs output (.tsv)
    str: path to results_vcfs output (.tsv)

output:
    path: report file (.html)
*/

process report {
    container "lalvarezmunoz/my_rocker:1.0.0" //here goes the container, rocker with rmarkdown

    input:
        path(template)
        path(logs)
        path(vcfs)
        
    output:
        path("report.html"), emit: summary

    script:
        """
        #!/usr/local/bin/Rscript
        file.copy("${template}", paste0(getwd(), "/template.Rmd"))
        file.copy("${logs}", paste0(getwd(), "/logs.tsv"))              #need to be rechecked
        file.copy("${vcfs}", paste0(getwd(), "/vcfs.tsv"))              #need to be rechecked
        rmarkdown::render(
            input = "template.Rmd",
            envir = new.env(),
            params = list(
                results_logs = "${logs}"
                results_vcfs = "${vcfs}"
            ),
            knit_root_dir = getwd(),
            output_dir = getwd(),
            output_file = "report.html"
        )
        """
}