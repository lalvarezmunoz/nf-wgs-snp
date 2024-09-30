process snpeff_accession {
    // directives
    container 'quay.io/biocontainers/snpeff:5.2--hdfd78af_0'
    
    input:
        val(snpeff_an)

    output:
        stdout

    script:
    """
    snpEff databases | grep ${snpeff_an} | awk '{printf("%s",\$1);}'
    """
}
//snpEff databases | grep ${snpeff_an} | awk '{print \$1}'

process vcf_annotation {
    // directives
    container 'quay.io/biocontainers/snpeff:5.2--hdfd78af_0'
    containerOptions '--user root'       //--user root is needed because the regular user is ignoring the -dataDir parameter form snpEff and has no permission to download the required files
    
    input:
        tuple val(prefix), path(vcffile)
        val(snpeff_id)

    output:
        tuple val(prefix), path("${prefix}_results.vcf"), emit: vcf

    script:
    """
    snpEff ${snpeff_id} ${vcffile} -stats ${prefix}_results > ${prefix}_results.vcf
    """
}