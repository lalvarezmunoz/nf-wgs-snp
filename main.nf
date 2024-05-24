#!/usr/bin/env nextflow
nextflow.enable.dsl=2


include {bwa_mem} from "./modules/bwa_mem.nf"
include {flagstat} from "./modules/flagstat.nf"
include {sortbam} from "./modules/sortbam.nf"
include {markduplicates} from "./modules/markduplicates.nf"
include {indexbam} from "./modules/indexbam.nf"
include {freebayes} from "./modules/freebayes.nf"
include {filtervcf} from "./modules/filtervcf.nf"
//include {fix_names} from "./modules/fix_names.nf"
include {vcf_annotation} from "./modules/vcf_annotation.nf"

//nextflow run main.nf --input manifest.csv --reference_genome references/Acinetobacter_baumannii_gca_000963815 -profile prod -resume
//nextflow run main.nf --input manifest.csv --reference_genome references/AB5075bwa -profile prod -resume

workflow {

    // manifest reader, csv reader
    Channel
        .fromPath(params.input)
        .splitCsv(header: true)
        .map {row -> tuple(row.id, file(row.R1), file(row.R2))}
        .set {raw_reads}

    //reference reader
    Channel
        .fromPath(params.reference_genome)
        .set {reference}
    
    // read a CSV with id,R1,R2
    raw_reads.view()
    reference.view()

    // bwa_mem
    bwa_mem(raw_reads, reference)
    
    //flagstats
    flagstat(bwa_mem.out.bam)
    flagstat.out.log.view()

    //sort bam files

    //mark duplicates with picard

    //index alignment

    //variant calling with freebayes

    //filter by quality

    //fix names

    //annotation of vcf file
   




    vcf_annotation.out.vcf.view()
    
}