process vcf_annotation {
    // directives
    container 'quay.io/biocontainers/snpeff:5.2--hdfd78af_0'
    
    input:
        tuple val(prefix), path(vcffile)
        path(reference)

    output:
        tuple val(prefix), path("${prefix}_results.vcf"), emit: vcf

    script:
    """
    snpEff ${reference} ${vcffile} -stats ${prefix}_results > ${prefix}_results.vcf
    """
    //"snpEff -dataDir /wgs/references Acinetobacter_baumannii_gca_000963815 /wgs/sample_freebayes_q20.recode2.vcf -stats results > /wgs/results.vcf"
}