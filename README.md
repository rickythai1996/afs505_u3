# afs505_u3
AFS Final Project Package Instruction

Description: This README file will give you instruction to execute the FASTA file.

1) Log in to Kamiak with WSU student's ID and password

2) Create a next flow configuration file named "nextflow.config"
   Insdie the "nexflow.config" file we write the script:
   #!/usr/bin/env nextflow
   profiles {
     slurm {
       process {
         executor = "slurm"
         queue = "ficklin_class"
         clusterOptions =  "--account=ficklin_class"
         time = "24h"
         blast {
       cpus = 5
          }
        }
      }
    }

3) Create a next flow file named "project.nf"
   Inside the "project.nf" file we write the nextflow script:
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

4) Create a slurm file named "project2.srun":
   Inside the "project.nf" file we write the script"
   #!/usr/bin/bash
   #SBATCH --partition=ficklin_class
   #SBATCH --account=ficklin_class
   #SBATCH --job-name=swissprot_blastp
   #SBATCH --output=swissprot.pep.out
   #SBATCH --error=swissprot.err
   #SBATCH --time=0-24:00:00
   #SBATCH --nodes=1
   #SBATCH --cpus-per-task=5

   module add blast
   module add java nextflow

   nextflow run project.nf -profile slurm

5) Add next flow module by typing command: module add nextflow/20.01.0

6) run the slurm script by typing command: sbatch project2.Instruction

7) After 6 hours of waiting, copy the blast file, named "File" to the local home directory. Open the file with Atom. Save the file as text file: "File.txt"

8) Open Microsoft Access Database. Go to External Data. Go to New Data Source. Import text file, "File.txt". Choose tab as the delimiter that separate each field. Save the table name as File in the Database. 

9) Check if the gene name is correctly locate in [Field1]

10) Create A Query that combine the output with two columns, gene name and number of matches, sort descendingly:
   SQL Command:
   SELECT Left([Field1],Len([Field1])-2) AS Expr1, Count(Left([Field1],Len([Field1])-2)) AS Expr2
   FROM File
   GROUP BY Left([Field1],Len([Field1])-2)
   ORDER BY Count(Left([Field1],Len([Field1])-2)) DESC;

11) Export the Query to deliminated text file, named File Query
