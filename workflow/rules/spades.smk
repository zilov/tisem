rule assembly:
    input:
        fr = TARGET_FR,
        rr = TARGET_RR
    conda:
        envs.spades
    threads: workflow.cores
    output:
        assembly = f"{OUTDIR}/assembly/{PREFIX}_target.fasta",
    params:
        prefix = PREFIX,
        outdir = directory(f"{OUTDIR}/assembly/")
    shell:"""
        spades.py -1 {input.fr} -2 {input.rr} -t {threads} -o {params.outdir} && mv {params.outdir}/scaffolds.fasta {output.assembly}
    """