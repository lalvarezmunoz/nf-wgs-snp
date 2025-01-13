/* genome_downloader: fetches the fna and gff files from NCBI given an accession number
- wget to download compressed files from NCBI url
- unzip the compressed file
- move the .fna or .gff files to the desired folder: find in the specified folder the file with name "*.xxx" and then execute mv {the file} to folder . End process using \;

input:
    val: genome assembly accession number (GCA or GCF)
output:
    path: .fna file with multifasta sequence file
    path: .gff file with GFF3 feature file
*/

process genome_downloader {
    //directives

    input:
        val(accession_number)

    output:
        path("*.fna"), emit: fna
        path("*.gff"), emit: gff

    script:
    """
    wget -q -O ref.gz https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/${accession_number}/download?include_annotation_type=GENOME_FASTA
    wget -q -O refgff.gz https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/${accession_number}/download?include_annotation_type=GENOME_GFF
    unzip ref.gz -d ref
    unzip refgff.gz -d refgff
    find ref -name "*.fna" -exec mv {} ./${accession_number}.fna \\;
    find refgff -name "*.gff" -exec mv {} ./${accession_number}.gff \\;
    """
}