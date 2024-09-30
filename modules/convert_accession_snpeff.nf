process convert_accession_snpeff {
    // directives
    container 'python:3.12'
    
    input:
        val accession_number 

    output:
        stdout

    script:
    """
        #!/usr/bin/env python
        import sys
        #format accession number
        acc_split = "${accession_number}".split("_")
        suffix = acc_split[1]
        suffix1 = suffix.split(".")[0]
        snpeff_an = 'gca_'+suffix1
        print(snpeff_an, file=sys.stdout, end="")
    """
}