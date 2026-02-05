# SSN annotation for the Reference set of proteins
library(tidyverse)


ssn_annotation_data <- read_tsv(file = "~/GitHub/AKT_Research/CSV_Files/ssn/referencesetblast.tsv", col_names = FALSE)
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


# Read in the csv file for the accession information that will be needed
reference_hmmer_info <- read_csv(file = "C:/Users/kajoh/OneDrive/Desktop/ReferenceAGC.csv")
reference_hmmer_info <- reference_hmmer_info %>% select(hit_id, hit_description, accn) %>% rename(sseqid = hit_id)

additional_info <- read_csv(file = "C:/Users/kajoh/OneDrive/Documents/GitHub/AKT_Research/CSV_Files/finalmappingdata.csv")
additional_info <- additional_info %>% select(accn, Taxid, `Species name`, `Phylum name`, `Group name`, `Kingdom name`, `M.Strategy`, `Super.Group`, `TORC2_Presence`, `TORC1_Presence`)
additional_info <- additional_info %>% distinct(accn, .keep_all = TRUE)



ssn_annotation_data <- left_join(ssn_annotation_data, reference_hmmer_info, by = "sseqid")
ssn_annotation_data_hmmer_added <- left_join(ssn_annotation_data, additional_info, by = "accn")



write_csv(ssn_annotation_data_hmmer_added, file = "~/GitHub/AKT_Research/CSV_Files/ssn/reference_set_annotation.csv")
