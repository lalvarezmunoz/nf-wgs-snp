/*
#fix chromosome names between VCF and SnpEff database (ERROR_CHROMOSOME_NOT_FOUND)
#check chromosome names in SnpEff database
docker run -v /mnt/c/git/wgs/:/wgs/ quay.io/biocontainers/snpeff:5.2--hdfd78af_0 /bin/bash -c "snpEff -v -dataDir /wgs/references Acinetobacter_baumannii_gca_000963815 /wgs/sample_freebayes_q20.recode.vcf -stats results > /wgs/results.vcf"
#check chromosome names in input VCF
cat sample_freebayes_q20.recode.vcf | grep -v "^#" | cut -f 1 | uniq

cat sample_freebayes_q20.recode.vcf | sed "s/^NZ_CP008706.1/Chromosome/" > sample_freebayes_q20.recode2.vcf

*/

/*Acinetobacter_baumannii_gca_000963815
    Chromosome      NZ_CP008706.1
    p1AB5075        NZ_CP008707.1
    p2AB5075        NZ_CP008708.1
    p3AB5075        NZ_CP008709.1
*/

/*
cat sample.vcf | sed "s/^NZ_CP008706.1/Chromosome/" | \
                    sed "s/^NZ_CP008707.1/p1AB5075/" | \
                    sed "s/^NZ_CP008708.1/p2AB5075/" | \
                    sed "s/^NZ_CP008709.1/p3AB5075/" > sample2.vcf
*/

/*Gluconobacter_oxydans_621H_gca_000011685
    Chromosome  CP000009.1
    pGOX1       CP000004.1
    pGOX2       CP000005.1
    pGOX3       CP000006.1
    pGOX4       CP000007.1
    pGOX5       CP000008.1
*/

/*
    """
    cat ${vcffile} | sed "s/^CP000009.1/Chromosome/" | \
                 sed "s/^CP000004.1/pGOX1/" | \
                 sed "s/^CP000005.1/pGOX2/" | \
                 sed "s/^CP000006.1/pGOX3/" | \
                 sed "s/^CP000007.1/pGOX4/" | \
                 sed "s/^CP000008.1/pGOX5/" > ${prefix}_fixed.vcf
    """
*/

/*Agrobacterium_fabrum_str_c58_gca_000092025
    circular    AE007869.2
    linear      AE007870.2
    At       AE007872.2
    Ti       AE007871.2
*/

/*
    """
    cat ${vcffile} | sed "s/^AE007869.2/circular/" | \
                 sed "s/^AE007870.2/linear/" | \
                 sed "s/^AE007872.2/At/" | \
                 sed "s/^AE007871.2/Ti/" > ${prefix}_fixed.vcf
    """
*/

/*Vibrio_cholerae_o1_biovar_el_tor_str_n16961_gca_000006745
    I   NC_002505.1 
    II  NC_002506.1
*/

/*
    """
    cat ${vcffile} | sed "s/^NC_002505.1/I/" | \
                 sed "s/^NC_002506.1/II/" > ${prefix}_fixed.vcf
    """
*/

process fix_names {
    //directives

    input:
        tuple val(prefix), path(vcffile)

    output:
        tuple val(prefix), path("${prefix}_fixed.vcf"), emit: vcf

    script:
    """
    cat ${vcffile} | sed "s/^NC_002505.1/I/" | \
                 sed "s/^NC_002506.1/II/" > ${prefix}_fixed.vcf
    """
}
