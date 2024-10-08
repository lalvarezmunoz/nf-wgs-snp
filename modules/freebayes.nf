process freebayes {
    // directives
    // version 1.3.7 does not work properly
    container 'quay.io/biocontainers/freebayes:1.3.6--hb0f3ef8_7'
    
    input:
        tuple val(prefix), path(bamfile), path(bamindex)
        path(reference)

    output:
        tuple val(prefix), path("${prefix}_freebayes.vcf"), emit: vcf

    script:
    """
    freebayes -C 2 -F 0.2 --min-coverage 8 -q 15 -p 1 -f ${reference} ${bamfile} > ${prefix}_freebayes.vcf
    """
    /*freebayes parameters used

        # -C --min-alternate-count 2
            Require at least this count of observations supporting an alternate allele within a single individual in order to evaluate the position.  default: 1
            min-alternate-count 2
        # -F --min-alternate-fraction 0.2
            Require at least this fraction of observations supporting an alternate allele within a single individual in the in order to evaluate the position.  default: 0.0
            minimum allele frequency = 20% (-F 0.2)
        # -! --min-coverage 8
            Require at least this coverage to process a site.  default: 0
            minimum read depth = 8 (--min-coverage)
        # -q --min-base-quality 15
            Exclude alleles from analysis if their supporting base quality is less than Q.  default: 20
            minimum base quality = 15 (-q)
        # -p --ploidy 1
            Sets the default ploidy for the analysis to N.  default: 2
            -p --ploidy 1
    */
}