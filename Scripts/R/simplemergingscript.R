source(file = "~/GitHub/AKT_Research/Scripts/R/Library_Script.R")

hmmerdata <- read.csv(file = "~/GitHub/AKT_Research/CSV_Files/mergeddata.csv")

accndata <- read_tsv(file = "~/GitHub/AKT_Research/CSV_Files/Complete_NCBI_Genome_Accessions.tsv")
accndata <- accndata %>% rename(accn = "Assembly Accession")%>%rename(Taxid = "Organism Taxonomic ID")

taxondata <- read_tsv(file = "~/GitHub/AKT_Research/CSV_Files/Taxonomic_Info.tsv")

# Joining the accn data with taxonomy id information
finaldata <- left_join(hmmerdata, accndata[c("accn","Taxid")], by = "accn")
finaldata <- left_join(finaldata, taxondata[c("Taxid","Species name", "Phylum name", "Group name", "Kingdom name")], by = "Taxid")
