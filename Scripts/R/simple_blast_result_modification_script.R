# Simple script to do some quick modifications to a blast report
# Goal is to combine this with an ssn graph file for annotation within cytoscape
# Needs to have a shared name and a name as replacement column names for the query name and the subject name
# Kyle Johnson 2026




library(tidyverse)

# Info retrieved from Uniprot using the ncbi Refseq Accession numbers
uniprot_info <- read_tsv(file = "C:/Users/kajoh/OneDrive/Desktop/idmapping_2026_02_02.tsv")
uniprot_info <- uniprot_info %>% rename(sseqid = From)

# Data compiled in the a prior script (simple_filtering_supergroup.R)
hmmer2info <- read_csv(file = "~/GitHub/AKT_Research/CSV_Files/finalmappingdata.csv")
hmmer2info <- hmmer2info %>% rename(sseqid = hit_id)

# All vs All blastp using the 50 filter data. Fasta files were concatenated and used to create a database (diamond)
# Diamond Blastp was then ran on the datbase with settings set to default
ssn_annotation_data <- read_tsv(file = "~/GitHub/AKT_Research/CSV_Files/ssn/allvall.tsv", col_names = FALSE)
ssn_annotation_data <- ssn_annotation_data %>% rename(qseqid =X1,
                                                      sseqid=X2,
                                                      pident=X3,
                                                      length=X4,
                                                      mismatch=X5,
                                                      gapopen=X6,
                                                      qstart=X7,
                                                      qend=X8,
                                                      sstart=X9,
                                                      send=X10,
                                                      evalue=X11,
                                                      bitscore=X12)




ssn_annotation_data_final <- left_join(ssn_annotation_data, hmmer2info[c("sseqid", "accn", "Taxid","Species name", "hit_description", "Super.Group","TORC2_Presence", "TORC1_Presence")], by = "sseqid")
ssn_annotation_data_final <- left_join(ssn_annotation_data_final, uniprot_info[c("sseqid","Gene Names", "Function [CC]", "Gene Ontology (cellular component)", "Gene Ontology (biological process)", "Gene Ontology (GO)", "Gene Ontology (molecular function)", "Gene Ontology IDs")], by = "sseqid")






write_csv(ssn_annotation_data_final, file ="C:/Users/kajoh/OneDrive/Desktop/annotation_data_50_filter.csv")



