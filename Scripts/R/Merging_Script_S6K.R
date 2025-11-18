
source(file = "~/GitHub/Fungal_MTORC1/R_Scripts/Library_Script.R")



Combine_Files <- function(input_path){
  
  file_list <- list.files(path = input_path,
                          patter = "\\.*csv",
                          full.names = TRUE)
  
  list_of_tibbles <- map(file_list, read_csv, show_col_types = FALSE)
  filtered_tibbles <- keep(list_of_tibbles, ~nrow(.x) > 1)
  
  Combined_data <- bind_rows(filtered_tibbles)
  
  return(Combined_data)
  
}

Genome_Info <- read_tsv(file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/Complete_NCBI_Table_Information_No_Filter.tsv")
Genome_Info <- Genome_Info %>% rename("acc" = "Assembly Accession")
Taxonomy_Info <- read_tsv(file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/Taxonomic_Info.tsv")
Taxonomy_Info <- Taxonomy_Info %>% rename("Organism Taxonomic ID" = "Taxid")

Combined_S6K_Potentials <- Combine_Files(input_path = "C:/Users/kajoh/Documents/GitHub/AKT_Research/CSV_Files/S6K")
Combined_S6K_Potentials <- left_join(Combined_S6K_Potentials, Genome_Info[c("Organism Name", "Organism Taxonomic ID", "acc")], by = "acc")
Combined_S6K_Potentials <- Combined_S6K_Potentials %>% group_by(`Organism Name`)%>%
  filter(full_score == max(full_score, na.rm=TRUE))
NA_Removed_Combined_S6K_Potentials <- na.omit(Combined_S6K_Potentials)

