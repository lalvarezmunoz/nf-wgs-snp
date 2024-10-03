// fix chromosome names between VCF and SnpEff database (avoid ERROR_CHROMOSOME_NOT_FOUND)

process fix_names {
    //directives
    container 'lalvarezmunoz/vcf-snpeff-formatter:0.3.0'
    containerOptions '--user root'       //--user root is needed because the regular user is ignoring the -dataDir parameter form snpEff and has no permission to download the required files


    input:
        val(accession_number)
        tuple val(prefix), path(vcffile)

    output:
        tuple val(prefix), path("${prefix}_fixed.vcf"), emit: vcf
        path("assembly_report.txt"), emit: asssembly_report

    script:
    """
    mv ${vcffile} "${prefix}.vcf"
    python3 /renamer/renamer.py ${accession_number} "${prefix}.vcf"

    """
}
