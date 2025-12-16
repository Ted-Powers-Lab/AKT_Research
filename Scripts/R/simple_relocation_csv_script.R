source(file="~/GitHub/AKT_Research/Scripts/R/Library_Script.R")



# Read in the primary information csv
# Relocate the ID section to the very front
# Save as a new file to be used with Phylip.io for visualization


accninfo <- read_tsv(file ="~/GitHub/AKT_Research/CSV_Files/Complete_NCBI_Genome_Accessions.tsv")
accninfo <- accninfo %>% select(`Assembly Accession`, `Organism Name`)



referenceglobal <- read_csv(file = "~/GitHub/AKT_Research/CSV_Files/Combined_CSVs/Reference_Global.csv")
referenceglobal <- referenceglobal %>% select(-1) %>% relocate('hit_id')


write.csv(referenceglobal, file = "~/GitHub/AKT_Research/CSV_Files/Combined_CSVs/phylip_mapping.csv")