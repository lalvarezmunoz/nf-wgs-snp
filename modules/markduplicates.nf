process markduplicates {
    // directives
    container 'quay.io/biocontainers/picard:3.1.1--hdfd78af_0'
    
    input:
        tuple val(prefix), path(sortedbamfile)

    output:
        tuple val(prefix), path("${prefix}_bwapicard.bam"), emit: bam
        tuple val(prefix), path("${prefix}_bwapicard_metrics.txt"), emit: log

    script:
    """
    picard MarkDuplicates -AS true -I ${sortedbamfile} -O ${prefix}_bwapicard.bam -M ${prefix}_bwapicard_metrics.txt
    """
}