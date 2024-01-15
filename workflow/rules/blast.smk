rule target_makeblastdb:
    input:
        target = TARGET
    conda:
        envs.blast
    threads: workflow.cores
    output:
        db = f"{OUTDIR}/blast/db/{PREFIX}.ndb",
    params:
        prefix = f"{OUTDIR}/blast/db/{PREFIX}",
        outdir = directory(f"{OUTDIR}/blast/db")
    shell:"""
    makeblastdb -out {params.prefix} -in {input.target} -dbtype nucl
    """

rule blast:
    input:
        target = TARGET,
        assembly = rules.assembly.output.assembly,
        db = rules.target_makeblastdb.output.db,
    conda:
        envs.blast
    threads: workflow.cores
    output:
        outfmt = f"{OUTDIR}/blast/{PREFIX}.outfmt6",
    params:
        db_prefix = rules.target_makeblastdb.params.prefix,
        outdir = directory(f"{OUTDIR}/blast")
    shell:"""
    blastn -db {params.db_prefix} -query {input.assembly} -outfmt 6 -num_threads {threads} > {output.outfmt}
    """
