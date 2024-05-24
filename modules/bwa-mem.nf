process bwa-mem {
    // directives
    container 'quay.io/biocontainers/bwa:0.7.18--he4a0461_0'
    
    input:
        tuple val(prefix), path(R1), path(R2)
        path(reference)

    output:
        tuple val(prefix), path("${prefix}_bwa.bam"), emit: bam

    script:
    """
    bwa mem ${reference} ${R1} ${R2} -t ${task.cpus} > ${prefix}_bwa.bam
    """
}