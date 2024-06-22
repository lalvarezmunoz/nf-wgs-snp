process vcf_annotation {
    // directives
    container 'quay.io/biocontainers/snpeff:5.2--hdfd78af_0'
    containerOptions '--user root'       //--user root is needed because the regulr user is ignoring the -dataDir parameter form snpEff and has no permission to download the required files
    
    input:
        tuple val(prefix), path(vcffile)
        val(strain)

    output:
        tuple val(prefix), path("${prefix}_results.vcf"), emit: vcf

    script:
    """
    snpEff ${strain} ${vcffile} -stats ${prefix}_results > ${prefix}_results.vcf
    """
}