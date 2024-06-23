process bwa_index {
    // directives
    container 'quay.io/biocontainers/bwa:0.7.18--he4a0461_0'
    
    input:
        tuple val(prefix), path(reference)

    output:
        tuple val(prefix), path("${prefix}.{amb,ann,bwt,pac,sa}"), emit: index

    script:
    """
    bwa index -p "${prefix}" "${reference}"
    """

}

process bwa_mem {
    // directives
    container 'quay.io/biocontainers/bwa:0.7.18--he4a0461_0'
    
    input:
        tuple val(prefix), path(R1), path(R2), val(ref_prefix), path(reference)

    output:
        tuple val(prefix), path("${prefix}_bwa.bam"), emit: bam

    script:
    """
    bwa mem -t ${task.cpus} ${ref_prefix} ${R1} ${R2} > ${prefix}_bwa.bam
    """
    //first copies reference file to local folder, because the db prefix need to be found in the working folder
}