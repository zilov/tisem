rule minimap2_run:
    input:
        fr = FR,
        rr = RR,
        fasta = TARGET
    threads: workflow.cores 
    conda: envs.minimap2
    output:
        alignment_bam = f"{OUTDIR}/minimap2/{PREFIX}_sorted.bam",
        alignment_stats = f"{OUTDIR}/minimap2/{PREFIX}_sorted.stats",
    params:
        outdir = directory(f"{OUTDIR}/minimap2")
    shell: """
    minimap2 -ax sr {input.fasta} {input.fr} {input.rr} -t {threads} \
    | samtools view -b -u - \
    | samtools sort -@ {threads} -T tmp > {output.alignment_bam} \
    && samtools flagstat {output.alignment_bam} > {output.alignment_stats}
    """


rule extract_properly_paired_alingment:
    input:
        alignment_bam = rules.minimap2_run.output.alignment_bam
    threads: workflow.cores 
    conda: envs.minimap2
    output:
        properly_aligned_bam = f"{OUTDIR}/minimap2/{PREFIX}_properly_aligned.bam",
    shell: """
    samtools view -b -F 4 -F 0x100 {input.alignment_bam} > {output.properly_aligned_bam}
    """


rule extract_properly_paired_reads:
    input:
        fr = FR,
        rr = RR,
        properly_aligned = rules.extract_properly_paired_alingment.output.properly_aligned_bam,
    threads: workflow.cores 
    conda: envs.minimap2
    output:
        target_fr = f"{OUTDIR}/minimap2/{PREFIX}_target_1.fastq",
        target_rr = f"{OUTDIR}/minimap2/{PREFIX}_target_2.fastq",
    params:
        prefix = PREFIX, 
        outdir = directory(f"{OUTDIR}/alignment")
    shell: """
    samtools view {input.properly_aligned} | awk "{{print \$1}}" | seqtk subseq {input.fr} - > {output.target_fr}
    samtools view {input.properly_aligned} | awk "{{print \$1}}" | seqtk subseq {input.rr} - > {output.target_rr}
    """