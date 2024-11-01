# nf-wgs-snp
Nextflow pipeline for whole genome sequencing (WGS) and variant calling of bacterial genomes.


## Description

This is a Nextflow pipeline designed to simplify WGS and variant calling analyses of bacterial genomes. It uses Docker containers making installation trivial and results highly reproducible.

The user provides the path to the FASTQ files and an accession number.

First, reference sequence files are downloaded from NCBI database to be used as the reference in BWA-MEM. The aligned reads are then sorted using Samtools, duplicate reads are marked with Picard and the BAM files are indexed. Variant calling is performed using Freebayes and, finally, VCF files are annotated using SnpEff.


## Requirements

- Nextflow version 24.04.4.5917
- Docker version 27.2.0


## Usage

Step 1: create a **results** folder in the working folder

Step 2: create a sample file

Step 3: run standard CLI code:

```bash
nextflow run main.nf --input <samples.csv> --accession_number <acc_number> --profile prod -resume
```

Step 4: output files will be created in the **results** folder.

*Example:*

```bash
nextflow run main.nf --input mysamples.csv --accession_number GCA_000092025.1 --profile prod -resume
```

---

## Input

### Sample file

CSV file with the following format:
id,R1,R2

- id: sample identification
- R1: path to FASTQ file with sequencing results R1 reads
- R2: path to FASTQ file with sequencing results R2 reads

Example:

```
id,R1,R2
sample1,/mnt/c/myfolder/sample1_S1_L001_R1_001.fastq.gz,/mnt/c/myfolder/sample1_S1_L001_R2_001.fastq.gz
sample2,/mnt/c/myfolder/sample2_S2_L001_R1_001.fastq.gz,/mnt/c/myfolder/sample2_S2_L001_R2_001.fastq.gz
[...]
```

### Accession number

Assembly accession number from NCBI: GCF_xxxxxxxxx.x or GCA_xxxxxxxxx.x

Example:

```
Taxon  Agrobacterium fabrum str. C58
NCBI RefSeq assembly  GCF_000092025.1
Submitted GenBank assembly  GCA_000092025.1
```


## Output

### References

- Reference genome .fna multifasta file
- Reference genome .gff GFF3 file
- Assembly report

### Logs

- BWA-MEM statistics: information about aligned reads
- Picard metrics: information about duplicate reads

### Bam files

Indexed aligned reads in .bam and .bai format.

### Vcf files

Variant calling report files, containing the following information:

```
#CHROM	POS	ID	REF	ALT	QUAL    FILTER	INFO	FORMAT	unknown
```

Information lines describing the *FILTER*, *INFO* and *FORMAT* entries used in the body of the VCF file are included in the meta-information section (file header).

Functional annotations are described under the **INFO: ANN** entry. For details: http://pcingola.github.io/SnpEff/adds/VCFannotationformat_v1.0.pdf

---

## Tools and references

- NCBI genome assemblies (https://www.ncbi.nlm.nih.gov/datasets/genome/)
- BWA-MEM (https://bio-bwa.sourceforge.net/)
- samtools/flagstat (http://www.htslib.org/doc/samtools-flagstat.html)
- samtools/sort (http://www.htslib.org/doc/samtools-sort.html)
- Picard/MarkDuplicates (https://broadinstitute.github.io/picard/)
- Freebayes (https://github.com/freebayes/freebayes)
- VCFtools (https://vcftools.github.io/index.html)
- VCF-SnpEff formatter (https://github.com/lalvarezmunoz/vcf-snpeff-formatter)
- SnpEff (https://pcingola.github.io/SnpEff/snpeff/introduction/)


## Acknowledgements

Thanks to [loAlon](https://github.com/loalon) for his contribution and guidance.


## Citing this pipeline

Please, refer to the GitHub repository when using this pipeline:

> L. Alvarez, nf-wgs-snp pipeline, (2024), GitHub repository, https://github.com/lalvarezmunoz/nf-wgs-snp
