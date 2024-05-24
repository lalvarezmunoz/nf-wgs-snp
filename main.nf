#!/usr/bin/env nextflow
nextflow.enable.dsl=2


include {bwa-mem} from "./bwa-mem.nf"
include {flagstat} from "./flagstat.nf"
include {sortbam} from "./sortbam.nf"
include {markduplicates} from "./markduplicates.nf"
include {indexbam} from "./indexbam.nf"
include {freebayes} from "./freebayes.nf"
include {filtervcf} from "./filtervcf.nf"
include {fix_names} from "./fix_names.nf"
include {vcf_annotation} from "./vcf_annotation.nf"

//nextflow main.nf --input manifest.csv --reference_genome "/home/alonso.serrano.alvar@fohm.local/Git/nf_test/bowtie_reference" --organism AtC58 -profile prod -resume
//nextflow main.nf --input manifest.csv --reference_genome "/mnt/c/git/nf-tnseq/reference_genomes" --organism AtC58 -profile prod -resume

workflow {

    // CSV reader
    csv_reads = Channel
        .fromPath(params.input)
        .splitCsv(header: true)
        .map { row-> tuple(row.id, file(row.file))}
        .set {cutadapt_input}


    // reference = Channel
    //     .fromPath(params.reference_genome)
        //.map{file -> tuple(file.simpleName, file)}
    // read a CSV with id,file
    cutadapt_input.view()
    // cutadapt step1
    
    //fastq -> fastq
    cutadapt_input
        .map { id, file -> tuple(id, file, "-g GCCAACCTGT", 1) }
        .set { cutadapt_step1 }
    
    cutadapt_1(cutadapt_step1)


    // // cutadapt step2
    // // fastq -> fastq
    cutadapt_1.out.sequence
        .map { id, file -> tuple(id, file, "-a ATACCACGAC", 2) }
        .set { cutadapt_step2 }

    cutadapt_2(cutadapt_step2)
    // // cutadapt step3 -> logs
    // //fastq -> fastq
    cutadapt_2.out.sequence
        .map { id, file -> tuple(id, file, "-m 15", 3) }
        .set { cutadapt_step3 }

    cutadapt_3(cutadapt_step3)
    // cutadapt_step2
    //     .map{ id, file -> tuple(id, file, "-a XXX", 3) }
    //     .cutadapt_3()
    //     .set { cutadapt_step3 }



    // bowtie2 -> logs
    //fastq -> bam
    cutadapt_3.out.sequence
        .map { id, file -> tuple(id, file) }
        .set { bowtie_input }

    //params.reference_genome.view()
    bowtie2(bowtie_input, params.reference_genome, params.organism)
    bowtie2.out.bam.view()
    bowtie2.out.log.view()
    // TAmapper
    //txt(bam) -> *.txt
    //export txt

    
}