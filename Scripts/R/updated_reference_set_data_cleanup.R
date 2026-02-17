library(tidyverse)



blast_data <- read_tsv(file = "C:/Users/kajoh/OneDrive/Documents/GitHub/AKT_Research/CSV_Files/ssn/updated_reference_all.tsv", col_names = FALSE)
blast_data <- blast_data %>% rename(qseqid =X1,
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




# Hmmer data that contains the hit description and the accession number, as well as a hit_id key identifier
hmmerdata <- read.csv(file = "C:/Users/kajoh/OneDrive/Documents/GitHub/AKT_Research/CSV_Files/ssn/update_reference_combined.csv")
hmmerdata <- hmmerdata %>% select(hit_id, hit_description, accn) %>% rename(sseqid = hit_id) %>% distinct(sseqid, .keep_all = TRUE)

# Taxonomy information (No data regarding TOR Complexes)
accninfo <- read_tsv(file = "C:/Users/kajoh/OneDrive/Documents/GitHub/AKT_Research/CSV_Files/Eukaryotes_accession_information.tsv")
accninfo <- accninfo %>% select(`Assembly Accession`, `Organism Taxonomic ID`) %>% rename(accn = "Assembly Accession", Taxid = "Organism Taxonomic ID")



taxonomyinfo <- read.csv(file = "C:/Users/kajoh/OneDrive/Documents/GitHub/AKT_Research/updated_taxon_accession_information.csv")
taxonomyinfo <- taxonomyinfo %>% select(-Authority, -Query, -Rank, -Has.type.material,-Scientific.name.is.formal, -Curator.common.name,
                                        -Domain.Realm.taxid, -Kingdom.taxid, -Phylum.taxid, -Class.taxid, -Order.taxid, -Family.taxid, -Genus.taxid, -accn)%>%
  distinct(Taxid, .keep_all = TRUE)

tordata <- read.csv(file = "~/GitHub/AKT_Research/CSV_Files/Publication_Ready_Table.csv")
tordata <- tordata %>% select(-X, -Organism.Name, -Class.name, -Phylum.name, -Order.name, -Family.name, -Genus.name, -Source, -Accn) %>% rename(Taxid = "Organism_Taxonomic_ID")

#Need to create a new column that indicates if TORC1 and TORC2 exist
tordata <- tordata %>% mutate(TORC2_Presence = case_when(
  RICTOR == "H" ~ "TORC2 Expected",
  RICTOR == "M" ~ "TORC2 Expected",
  RICTOR == "L" ~ "TORC2 Expected",
  .default = "No TORC2"
)) %>% mutate(TORC1_Presence = case_when(
  RAPTOR == "H" ~ "TORC1 Expected", 
  RAPTOR == "M" ~ "TORC1 Expected",
  RAPTOR == "L" ~ "TORC1 Expected",
  .default = "No TORC1"
))







# Join the data together
updatedinfo <- left_join(blast_data, hmmerdata, by = "sseqid")
# Remove the cases where there are multiples



updatedinfo <- left_join(updatedinfo, accninfo, by = "accn")
updatedinfo <- left_join(updatedinfo, taxonomyinfo, by = "Taxid")
updatedinfo <- left_join(updatedinfo, tordata, by = "Taxid")


# Now to do some manual changes regarding the metazoans:

updatedinfo <- updatedinfo %>% mutate(Super.Group = case_when(
  `Kingdom.name` == "Metazoa" ~ "Opisthokonta",
  `Kingdom.name` == "Fungi" ~ "Opisthokonta",
  `Phylum.name` == "Evosea" ~ "Amoebozoa",
  .default = Super.Group
)) %>% mutate(M.Strategy = case_when(
  `Kingdom.name` == "Viridiplantae" & is.na(M.Strategy) ~ "Autotrophic",
  `Kingdom.name` == "Metazoa" & is.na(M.Strategy) ~ "Heterotroph",
  `Phylum.name` == "Streptophyta" & is.na(M.Strategy) ~ "Autotrophic",
  `Group.name` == "Ciliophora" & is.na(M.Strategy) ~ "Heterotroph",
  `Group.name` == "ciliates" & is.na(M.Strategy) ~ "Heterotroph",
  `Kingdom.name` == "Fungi" & is.na(M.Strategy) ~ "Heterotroph",
  `Phylum.name` == "Evosea" & is.na(M.Strategy) ~ "Heterotroph",
  .default = M.Strategy)) %>%
  mutate(TORC2_Presence = case_when(
    `Kingdom.name` == "Metazoa" & is.na(TORC2_Presence) ~ "TORC2 Expected",
    `Kingdom.name` == "Fungi" & is.na(TORC2_Presence) ~ "TORC2 Expected",
    `Group.name` == "Ciliophora" & is.na(TORC2_Presence) ~ "TORC2 Expected",
    `Group.name` == "ciliates" & is.na(TORC2_Presence) ~ "TORC2 Expected",
    `Phylum.name` == "Evosea" & is.na(TORC2_Presence) ~ "TORC2 Expected",
    .default = TORC2_Presence
  )) %>%
  mutate(TORC1_Presence = case_when(
    `Kingdom.name` == "Metazoa" & is.na(TORC1_Presence) ~ "TORC1 Expected",
    `Kingdom.name` == "Fungi" & is.na(TORC1_Presence) ~ "TORC1 Expected",
    `Phylum.name` == "Evosea" & is.na(TORC1_Presence) ~ "TORC1 Expected",
    .default = TORC1_Presence
  ))






write_csv(updatedinfo, file = "C:/Users/kajoh/OneDrive/Documents/GitHub/AKT_Research/CSV_Files/ssn/updated_reference_annotation_v2.csv")















