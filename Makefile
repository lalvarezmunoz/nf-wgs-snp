clean:
	rm -rf work/*
	echo "cleaning done"

cleanall:
	rm -rf work/*
	rm -rf results/*
	echo "all files removed"

test_gox:
	nextflow run main.nf \
		--input manifest2.csv \
		--reference_genome references/Gox621H \
		--reffasta /mnt/c/git/nf-wgs-snp/references/Gox621H/GCA_000011685.fasta \
		--strain Gluconobacter_oxydans_621h_gca_000011685 \
		-profile prod \
		-resume

test_ab:
	nextflow run main.nf \
		--input manifest.csv \
		--reference_genome references/Ab5075 \
		--reffasta /mnt/c/git/nf-wgs-snp/references/Ab5075/GCA_000963815.fasta \
		--strain Acinetobacter_baumannii_gca_000963815 \
		-profile prod \
		-resume

muestras_curro:
	nextflow run main.nf \
		--input samples_Curro.csv \
		--reffasta /mnt/c/git/nf-wgs-snp/references/Gox621H/GCA_000011685.fasta \
		--strain Gluconobacter_oxydans_621h_gca_000011685 \
		-profile prod