/* fix_names: renames the chromosomes in the vcf file to use the names used by SnpEff (avoid ERROR_CHROMOSOME_NOT_FOUND)
https://github.com/lalvarezmunoz/vcf-snpeff-formatter

If main chromosome keeps its accession number, it is automatically renamed as "chromosome"

input:
    val: genome assembly accession number
    tuple: sample name, vcf file
output:
    tuple: sample name, renamed chromosomes vcf file
    path: assembly report from NCBI used to find the names used by SnpEff
*/

process fix_names {
    //directives
    container 'lalvarezmunoz/vcf-snpeff-formatter:0.4.0'
    containerOptions '--user root'       //--user root is needed because the regular user is ignoring the -dataDir parameter form snpEff and has no permission to download the required files


    input:
        val(accession_number)
        tuple val(prefix), path(vcffile)

    output:
        tuple val(prefix), path("${prefix}_fixed.vcf"), emit: vcf
        path("assembly_report.txt"), emit: asssembly_report

    script:
    """
    mv ${vcffile} "${prefix}.vcf"
    python3 /renamer/renamer.py ${accession_number} "${prefix}.vcf"

    """
}
