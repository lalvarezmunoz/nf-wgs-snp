/* flagstat: calculates the statistics of the alignment
http://www.htslib.org/doc/samtools-flagstat.html

input:
    tuple: sample name, aligned reads in bam format
output:
    path: alignment statistics in txt format
*/

process flagstat {
    // directives
    container 'quay.io/biocontainers/samtools:1.20--h50ea8bc_0'
    
    input:
        tuple val(prefix), path(bamfile)

    output:
        path("${prefix}_bwa_stats.txt"), emit: log

    script:
    """
    samtools flagstat -@${task.cpus} ${bamfile} > ${prefix}_bwa_stats.txt
    """
}