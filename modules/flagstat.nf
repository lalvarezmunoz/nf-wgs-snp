process flagstat {
    // directives
    container 'quay.io/biocontainers/samtools:1.20--h50ea8bc_0'
    
    input:
        tuple val(prefix), path(bamfile)

    output:
        tuple val(prefix), path("${prefix}_bwa_stats.txt"), emit: log

    script:
    """
    samtools flagstat -@${task.cpus} ${bamfile} > ${prefix}_bwa_stats.txt
    """
}