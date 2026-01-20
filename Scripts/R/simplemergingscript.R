source(file = "~/GitHub/AKT_Research/Scripts/R/Library_Script.R")

hmmerdata <- read.csv(file = "~/GitHub/AKT_Research/CSV_Files/mergeddata.csv")

accndata <- read_tsv(file = "~/GitHub/AKT_Research/CSV_Files/Complete_NCBI_Genome_Accessions.tsv")
accndata <- accndata %>% rename(accn = "Assembly Accession")%>%rename(Taxid = "Organism Taxonomic ID")

taxondata <- read_tsv(file = "~/GitHub/AKT_Research/CSV_Files/Taxonomic_Info.tsv")

metabolicdata <- read_csv(file = "~/GitHub/AKT_Research/CSV_Files/Publication_Ready_Table.csv")
metabolicdata <- metabolicdata %>% rename(Taxid = "Organism_Taxonomic_ID")

# Joining the accn data with taxonomy id information
finaldata <- left_join(hmmerdata, accndata[c("accn","Taxid")], by = "accn")
finaldata <- left_join(finaldata, taxondata[c("Taxid","Species name", "Phylum name", "Group name", "Kingdom name")], by = "Taxid")
finaldata <- finaldata %>% select(-X)%>% relocate("hit_id")


finaldata <- left_join(finaldata, metabolicdata[c("Taxid", "M.Strategy","SIN1", "RICTOR", "RAPTOR", "TOR", "LST8")], by = "Taxid")
#Need to make some modifications to add in values for H.sapiens, D.melanogaster, S.cerevisiae, S.pombe (Give them M.strategy etc etc)








write.csv(finaldata, file = "~/GitHub/AKT_Research/CSV_Files/FinalHmmer2Data.csv")
