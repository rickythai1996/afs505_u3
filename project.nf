#!/usr/bin/env nextflow

params.query = "/data/ficklin_class/AFS505/course_material/data/all.pep"


Channel
    .fromPath("/data/ficklin_class/AFS505/course_material/data/all.pep")
    .splitFasta(by: 5000, file:true)
    .set { fasta_split }

process blast {
    input:
    path 'query' from fasta_split


    output:
    file 'results' into fasta_result

    
    "blastp -db /data/ficklin_class/AFS505/course_material/data/swissprot -query $query -outfmt 6 -evalue 1e-6 -num_threads ${task.cpus} > results"
    
}



fasta_result
    .collectFile(name: "File")
