/* snpeff_accession: searches the SnpEff database for the entry with the input accession number and provides the SnpEff entry identification
https://pcingola.github.io/SnpEff/snpeff/introduction/

input:
    val: genome assembly accession number
output:
    stdout: entry name in SnpEff database
*/

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

/* vcf_annotation: annotate vcf file using SnpEff
https://pcingola.github.io/SnpEff/snpeff/introduction/

input:
    tuple: sample name, renamed chromosomes vcf file
    val: entry name in SnpEff database
output:
    tuple: sample name, annotated vcf file
*/

process vcf_annotation {
    // directives
    container 'quay.io/biocontainers/snpeff:5.2--hdfd78af_0'
    containerOptions '--user root'       //--user root is needed because the regular user is ignoring the -dataDir parameter form snpEff and has no permission to download the required files
    
    input:
        tuple val(prefix), path(vcffile)
        val(snpeff_id)

    output:
        tuple val(prefix), path("${prefix}_results_annotated.vcf"), emit: vcf
        path("${prefix}_results_annotated.vcf"), emit: vcf_summary

    script:
    """
    snpEff ${snpeff_id} ${vcffile} -stats ${prefix}_results_annotated > ${prefix}_results_annotated.vcf
    """
}