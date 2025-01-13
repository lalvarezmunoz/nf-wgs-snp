/* bwa_index: creates index for BWA-MEM
https://bio-bwa.sourceforge.net/

input:
    val: genome assembly accession number (GCA or GCF)
    path: assembly .fna file
output:
    tuple: assembly accession number, bwa index files (.amb, .ann, .bwt, .pac, .sa) 
*/

process bwa_index {
    // directives
    container 'quay.io/biocontainers/bwa:0.7.18--he4a0461_0'
    
    input:
        val(prefix)
        path(reference)

    output:
        tuple val(prefix), path("${prefix}.{amb,ann,bwt,pac,sa}"), emit: index

    script:
    """
    bwa index -p "${prefix}" "${reference}"
    """

}

/* bwa_mem: aligns reads agaisnt a reference genome
https://bio-bwa.sourceforge.net/

input:
    tuple: sample name, read R1, read R2, reference genome accession number (GCA or GCF), genome index files
output:
    tuple: sample name, aligned reads in bam format
*/

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
    //first copies reference file to local folder, because the db prefix needs to be found in the working folder
}