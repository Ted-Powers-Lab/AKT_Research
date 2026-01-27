# Simple script to do some quick modifications to a blast report
# Goal is to combine this with an ssn graph file for annotation within cytoscape
# Needs to have a shared name and a name as replacement column names for the query name and the subject name
# Kyle Johnson 2026




library(tidyverse)

hmmer2info <- read_csv(file = "C:/Users/kajoh/OneDrive/Documents/GitHub/AKT_Research/CSV_Files/FinalHmmer2Data.csv")
hmmer2info <- hmmer2info %>% rename(sseqid = hit_id)

ssn_annotation_data <- read_tsv(file = "C:/Users/kajoh/OneDrive/Desktop/allvall.tsv", col_names = FALSE)
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

ssn_annotation_data_final <- left_join(ssn_annotation_data, hmmer2info[c("sseqid", "accn", "Taxid","Species name", "hit_description")], by = "sseqid")






write_csv(ssn_annotation_data_final, file ="C:/Users/kajoh/OneDrive/Desktop/annotation_data_50_filter.csv")



