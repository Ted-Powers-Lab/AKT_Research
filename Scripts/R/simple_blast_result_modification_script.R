# Simple script to do some quick modifications to a blast report
# Goal is to combine this with an ssn graph file for annotation within cytoscape
# Needs to have a shared name and a name as replacement column names for the query name and the subject name
# Kyle Johnson 2026




library(tidyverse)

ssn_annotation_data <- read_tsv(file = "C:/Users/kajoh/OneDrive/Desktop/200filter_blast_results_additional.tsv", col_names = FALSE)
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
                                                      bitscore=X12,
                                                      staxid=X14)%>%select(-X15,-X13)






write_csv(ssn_annotation_data, file ="C:/Users/kajoh/OneDrive/Desktop/annotation_data_200reference.csv")



