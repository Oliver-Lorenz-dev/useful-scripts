#!/bin/bash

# load modules

module load nextflow/21.04.1-5556
module load ISG/singularity/3.6.4

for file in /lustre/scratch118/infgen/pathdev/ol6/dt-179-testing/*.bam; do
FILENAME=`basename ${file%%.*}`
bsub -e log.e -o log.o -R "select[mem>8000] rusage[mem=8000]" -M8000 \
    nextflow run pipelines/snp_genotyping_vector.nf -c pipelines/snp_genotyping_vector.config \
        --input_bams "/lustre/scratch118/infgen/pathdev/ol6/dt-179-testing/${FILENAME}.bam" \
        --input_bam_indexes "/lustre/scratch118/infgen/pathdev/ol6/dt-179-testing/${FILENAME}.bam.bai" \
        --output_dir "./${FILENAME}" \
        --reference '/lustre/scratch118/infgen/pathogen/pathpipe/malariaGEN/vectors/references/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4.fa' \
        --reference_index '/lustre/scratch118/infgen/pathogen/pathpipe/malariaGEN/vectors/references/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4.fa.fai' \
        --reference_dict '/lustre/scratch118/infgen/pathogen/pathpipe/malariaGEN/vectors/references/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4/Anopheles-gambiae-PEST_CHROMOSOMES_AgamP4.dict' \
        --alleles_vcf '/lustre/scratch118/infgen/pathdev/ol6/dt-179-testing/ag.allsites.nonN.vcf.gz' \
        --alleles_vcf_index '/lustre/scratch118/infgen/pathdev/ol6/dt-179-testing/ag.allsites.nonN.vcf.gz.tbi' \
        -profile sanger_lsf -with-trace
	sleep 300
done
