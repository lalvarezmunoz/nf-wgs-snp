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

cat sample.vcf | sed "s/^NZ_CP008706.1/Chromosome/" | \
                    sed "s/^NZ_CP008707.1/p1AB5075/" | \
                    sed "s/^NZ_CP008708.1/p2AB5075/" | \
                    sed "s/^NZ_CP008709.1/p3AB5075/" > sample2.vcf