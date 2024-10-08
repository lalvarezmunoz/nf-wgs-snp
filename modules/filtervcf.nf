/* filtervcf: filter vcf file based on quality score
https://vcftools.github.io/man_latest.html

Filter by minimum quality (minQ): includes only sites with Quality value above the threshold

input:
    tuple: sample name, vcf file
output:
    tuple: sample name, filtered vcf file
*/

process filtervcf {
    // directives
    container 'quay.io/biocontainers/vcftools:0.1.16--pl5321hdcf5f25_10'
    
    input:
        tuple val(prefix), path(vcffile)

    output:
        tuple val(prefix), path("${prefix}_freebayes_q20.vcf"), emit: vcf

    script:
    """
    vcftools --minQ 20 --recode --recode-INFO-all --vcf ${vcffile} --out ${prefix}_freebayes_q20
    mv ${prefix}_freebayes_q20.recode.vcf ${prefix}_freebayes_q20.vcf
    """
}
