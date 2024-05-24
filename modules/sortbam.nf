process sortbam {
    // directives
    container 'quay.io/biocontainers/samtools:1.20--h50ea8bc_0'
    
    input:
        tuple val(prefix), path(bamfile)

    output:
        tuple val(prefix), path("${prefix}_bwasorted.bam"), emit: bam

    script:
    """
    sort -t ${task.cpus} -o ${prefix}_bwasorted.bam ${bamfile}
    """
}