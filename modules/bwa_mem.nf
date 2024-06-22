process bwa_mem {
    // directives
    container 'quay.io/biocontainers/bwa:0.7.18--he4a0461_0'
    
    input:
        tuple val(prefix), path(R1), path(R2)
        path(reference)

    output:
        tuple val(prefix), path("${prefix}_bwa.bam"), emit: bam

    script:
    """
    cp -r ${reference}/* .
    bwa mem ${reference} ${R1} ${R2} -t ${task.cpus} > ${prefix}_bwa.bam
    """
    //first copies reference file to local folder, because the db prefix need to be found in the working folder
}