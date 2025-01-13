/* indexbam: indexes sorted bam file for fast random access
http://www.htslib.org/doc/samtools-index.html

input:
    tuple: sample name, duplicates marked sorted aligned reads in bam format
output:
    tuple: sample name, indexed duplicates marked sorted aligned reads in bam format, index file in bai format
*/

process indexbam {
    // directives
    container 'quay.io/biocontainers/samtools:1.20--h50ea8bc_0'
    
    input:
        tuple val(prefix), path(bamfile)

    output:
        tuple val(prefix), path("${bamfile}"), path("${prefix}_bwapicard.bam.bai"), emit: indexedbam

    script:
    """
    samtools index ${bamfile} > ${prefix}_bwapicard.bam.bai
    """
}