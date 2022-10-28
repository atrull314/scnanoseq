process CORRECT_BARCODES {
    tag "$meta.id"
    label 'process_low'

    conda ("conda-forge::editdistance=0.6.0 bioconda::pysam=0.19.1 conda-forge::pygtrie=2.5.0 conda-forge::biopython=1.79")

    input:
    tuple val(meta), path(bam), path(whitelist), path(bc_count_file) 

    output:
    tuple val(meta), path("*.corrected.bam"), emit: corrected_bam
    path "versions.yml"                     , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    
    """
    correct_barcodes.py \\
        ${args} \\
        -i ${bam} \\
        -o ${prefix}.corrected.bam \\
        -w ${whitelist} \\
        -b ${bc_count_file}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        correct_barcodes: v1.0 
    END_VERSIONS
    """
}
