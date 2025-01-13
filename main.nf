#!/usr/bin/env nextflow
nextflow.enable.dsl=2

include {genome_downloader} from "./modules/genome_downloader.nf"
include {bwa_index; bwa_mem} from "./modules/bwa_mem.nf"
include {flagstat} from "./modules/flagstat.nf"
include {sortbam} from "./modules/sortbam.nf"
include {markduplicates} from "./modules/markduplicates.nf"
include {indexbam} from "./modules/indexbam.nf"
include {freebayes} from "./modules/freebayes.nf"
include {filtervcf} from "./modules/filtervcf.nf"
include {fix_names} from "./modules/fix_names.nf"
include {convert_accession_snpeff} from "./modules/convert_accession_snpeff.nf"
include {snpeff_accession; vcf_annotation} from "./modules/vcf_annotation.nf"
include {analysis_logs} from "./modules/analysis_logs.nf"
include {analysis_vcfs} from "./modules/analysis_vcfs.nf"
include {report} from "./modules/report.nf"

workflow snpeff_wf {
    take:
        accession_number
        vcf_file

    main:
        // fix chromosome names for compatibility with snpeff database
        fix_names(accession_number, vcf_file)

        // convert accession number into SnpEff database accession number
        convert_accession_snpeff(accession_number)

        // find snpeff_id in SnpEff database based on snpeff accession number
        snpeff_accession(convert_accession_snpeff.out)
        snpeff_accession.out.view()

        // annotation of vcf file with SnpEff
        vcf_annotation(fix_names.out.vcf, snpeff_accession.out)
        vcf_annotation.out.vcf.view()
    
    emit:
        annotated_vcf = vcf_annotation.out.vcf
        annotated_simple_vcf = vcf_annotation.out.vcf_summary

}


workflow {

    // manifest reader, csv reader
    Channel
        .fromPath(params.input)
        .splitCsv(header: true)
        .map {row -> tuple(row.id, file(row.R1), file(row.R2))}
        .set {raw_reads}

    // genome_downloader
    genome_downloader(params.accession_number)

    // Create index based on reference FASTA
    bwa_index(params.accession_number, genome_downloader.out.fna)

    // bwa_mem
    // combine the reads with the bwa indexed channel
    raw_reads
        .combine(bwa_index.out.index)
        .set{bwa_align_input}
    // Align
    bwa_mem(bwa_align_input)
    
    // flagstats
    flagstat(bwa_mem.out.bam)

    // sort bam files
    sortbam(bwa_mem.out.bam)

    // mark duplicates with picard
    markduplicates(sortbam.out.bam)

    // index alignment
    indexbam(markduplicates.out.bam)

    // variant calling with freebayes
    freebayes(indexbam.out.indexedbam, genome_downloader.out.fna)

    // filter by quality
    filtervcf(freebayes.out.vcf)
 //   filtervcf.out.vcf.view()

    if (params.snpeff) {
        // run snpeff worflow
        snpeff_wf(params.accession_number, filtervcf.out.vcf)
 //       snpeff_wf.out.annotated_vcf.view()
    }

    // collect all outputs from flagstat and create dataframe
    logs_ch = flagstat.out.log.collect()
    analysis_logs(logs_ch)
 //   analysis_logs.out.results_logs.view()

    // collect all outputs from vcf and create dataframe
    if (params.snpeff) {
        vcfs_ch = snpeff_wf.out.annotated_simple_vcf.collect()
    } else {
        vcfs_ch = filtervcf.out.vcf_summary.collect()
    }
    analysis_vcfs(params.snpeff, vcfs_ch)
 //   analysis_vcfs.out.results_vcfs.view()
    
    // create final report file
    Channel
        .fromPath("./modules/summary.Rmd")
        .set {template_ch}
    report(template_ch, analysis_logs.out.results_logs, analysis_vcfs.out.results_vcfs)
    report.out.summary.view()
}