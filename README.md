# Target Illumina Assembler - tisem

Snakemake pipeline, which:
* Extracts Illumina reads relative to target sequence with minimap2 (default) or bbduk
* Assembles target sequence de-novo with SPAdes.

# Requerements
* Snakemake - 7.25.0 (tested) or highier

# Usage
To run tisem with minimap2 use following command
 `./tisem -f target_gene.fasta -1 ./forward_1.fq -2 ./reverse_2.fq -o ./outdir`
 To run tisem with bbuk use following command
 `./tisem -m bbduk -f ./target_gene.fasta -1 ./forward_1.fq -2 ./reverse_2.fq -o ./outdir`
Default bbduk parameters: K=19, hdist=0, you could change in in command if you wish, for example:
 `./tisem -m bbduk -f ./target_gene.fasta -1 ./forward_1.fq -2 ./reverse_2.fq -o ./outdir -k 23 -hdist 2`
Other parameters could be changed directly in `/workflow/rules/*.smk` rules files

# Command line arguments
```
options:
  -h, --help            show this help message and exit
  -m {minimap2,bbduk}, --mode {minimap2,bbduk}
                        mode to use
  -f FASTA, --fasta FASTA
                        Path to target fasta file.
  -1 FORWARD, --forward FORWARD
                        Path to the forward reads fastq file.
  -2 REVERSE, --reverse REVERSE
                        Path to the reverse reads fastq file.
  -k K                  K value for bbduk search
  -hdist HDIST          hdist value for bbduk search
  -t THREADS, --threads THREADS
                        number of threads [default == 8]
  -p PREFIX, --prefix PREFIX
                        output files prefix (assembly file prefix by default)
  -o OUTPUT_FOLDER, --output_folder OUTPUT_FOLDER
                        Path to the output folder.
  -d, --debug           debug mode
  ```
