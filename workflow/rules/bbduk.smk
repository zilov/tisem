rule bbduk:
    input:
        fr = FR,
        rr = RR,
        fasta = TARGET
    threads: workflow.cores 
    conda: envs.bbduk
    output:
        target_fr = f"{OUTDIR}/bbduk/{PREFIX}_target_1.fastq",
        target_rr = f"{OUTDIR}/bbduk/{PREFIX}_target_2.fastq",
    params:
        k = K,
        hdist = HDIST,
        outdir = directory(f"{OUTDIR}/bbduk")
    shell: """
    bbduk.sh in1={input.fr} in2={input.rr} outm1={output.target_fr} outm2={output.target_rr} ref={input.fasta} k={params.k} hdist={params.hdist}
    """