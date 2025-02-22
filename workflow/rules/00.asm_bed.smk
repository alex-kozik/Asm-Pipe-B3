rule asm_bed:
    input:
        lambda wildcards: config["assemblies"][wildcards.asmname]
    output:
        asm_bed = "results/00.asm_bed/{asmname}/{asmname}.Asm_Len.BED", 
        chr_bed = "results/00.asm_bed/{asmname}/{asmname}.Chr_Len.BED",
        asm_1Mb = "results/00.asm_bed/{asmname}/{asmname}.Asm_Len.1Mb.Range",
        chr_1Mb = "results/00.asm_bed/{asmname}/{asmname}.Chr_Len.1Mb.Range",

    log:
        "results/logs/00.asm_bed/{asmname}.log"
    benchmark:
        "results/benchmarks/00.asm_bed/{asmname}.txt"
    conda:
        "../envs/bioawk.yaml"
    shell:
        """
        (
        bioawk -c fastx '{{ print $name, 0, length($seq) }}' {input} > {output.asm_bed} 
        head -9 {output.asm_bed} > {output.chr_bed} 
        python2 /path_to_data/x-bin-x/scripts/make_subrange_from_bed.py 1000000 < {output.asm_bed} > {output.asm_1Mb} 
        python2 /path_to_data/x-bin-x/scripts/make_subrange_from_bed.py 1000000 < {output.chr_bed} > {output.chr_1Mb}
        ) &> {log} 
        """
