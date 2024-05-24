process indexbam {
    // directives
    container 'quay.io/biocontainers/samtools:1.20--h50ea8bc_0'
    
    input:
        tuple val(prefix), path(bamfile)

    output:
        tuple val(prefix), path("${prefix}_bwapicard.bam.bai"), emit: bai

    script:
    """
    samtools index ${bamfile} > ${prefix}_bwapicard.bam.bai
    """
}