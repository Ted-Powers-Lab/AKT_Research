


library(tidyverse)

# Taxid Column Properly Named
taxon_original <- read_tsv(file = "C:/Users/kajoh/OneDrive/Documents/GitHub/AKT_Research/Taxonomic_Info.tsv")

# Taxid Not Properly Named
accn_information_ncbi <- read_tsv(file = "C:/Users/kajoh/OneDrive/Documents/GitHub/AKT_Research/Eukaryotes_accn.tsv")
accn_information_ncbi <- accn_information_ncbi %>% rename(Taxid = `Organism Taxonomic ID`, accn = `Assembly Accession`) %>% select(Taxid, accn)

metazoa_references_list <- list.files(path = "C:/Users/kajoh/OneDrive/Desktop/Taxonomy",
                                      pattern = "\\.tsv$",
                                      recursive = TRUE,
                                      full.names = TRUE)


metazoa_df <- map_df(metazoa_references_list, ~read_tsv(.x, show_col_types = FALSE), .id = "source_file")
metazoa_df <- metazoa_df %>% select(-source_file)



taxon_update <- rbind(taxon_original, metazoa_df)
taxon_update <- left_join(taxon_update, accn_information_ncbi, by = "Taxid")








write_csv(taxon_update, file = "C:/Users/kajoh/OneDrive/Documents/GitHub/AKT_Research/updated_taxon_accession_information.csv")
