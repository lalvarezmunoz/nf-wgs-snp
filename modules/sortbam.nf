/* sortbam: sorts alignments by leftmost coordinates
http://www.htslib.org/doc/samtools-sort.html

input:
    tuple: sample name, aligned reads in bam format
output:
    tuple: sample name, sorted aligned reads in bam format
*/

process sortbam {
    // directives
    container 'quay.io/biocontainers/samtools:1.20--h50ea8bc_0'
    
    input:
        tuple val(prefix), path(bamfile)

    output:
        tuple val(prefix), path("${prefix}_bwasorted.bam"), emit: bam

    script:
    """
    samtools sort -t ${task.cpus} -o ${prefix}_bwasorted.bam ${bamfile}
    """
}