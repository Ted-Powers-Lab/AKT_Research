


source(file = "~/GitHub/AKT_Research/Scripts/R/Library_Script.R")



read_assign_TSV <- function(input_directory){
  # Column names to be added to the tsv file. Based on the Interpro Output header
  new_column_names <- c("tar", "seq_md5", "seq_length", "Analysis",
                        "sig_acc", "sig_desc", "start", "stop",
                        "e_value", "status", "date", "ipr_acc", "ipr_desc")
  
  
  file_list_of_tibbles <- list.files(path = input_directory,
                                     pattern = "\\.*tsv",
                                     full.names = TRUE)
  print(file_list_of_tibbles)
  list_of_tibbles <- map(file_list_of_tibbles, read_tsv, show_col_types = FALSE)
  renamed_list_setnames <- map(list_of_tibbles, ~ setNames(.x, new_column_names))
  filtered_tibbles <- keep(renamed_list_setnames, ~nrow(.x) > 1)
  
  Combined_data <- bind_rows(filtered_tibbles)
  Combined_data <- select(Combined_data, -c(14, 15))
  return(Combined_data)
  
}

find_potentials <- function(df, information_df, domain_order){
  
  # Check to make sure the domain order list is in alphabetical order
  temp <- sort(unlist(domain_order))
  domain_string <- paste(temp, collapse = ", ")
  
  # Getting rid of information that may not be relevant for future analysis
  df <- group_by(df, tar) %>%
    select(-seq_md5, -date, -status, -ipr_acc, -ipr_desc)
  
  # Set up dataframe that will combine all of the found domains into a dataframe
  # Need to set this up in such a way that it organizes via alphabetical
  Domains <- df %>% group_by(tar)%>%
    summarise(All_Domains = paste0(sort(sig_desc), collapse = ", "))%>%
    arrange(All_Domains)%>%
    ungroup()
  
  
  df <- left_join(df, Domains, by = "tar")
  df <- df[order(df$All_Domains),]
  view(df)
  Result <- df
  Result <- df %>% filter(All_Domains == domain_string)
  Result <- left_join(Result, information_df[c("tar", "acc", "Organism Name", "Organism Taxonomic ID")], by = "tar")
  Result <- Result %>% arrange(All_Domains)
  Result <- Result %>% distinct()
  Result <- Result %>% select(-start, -stop, -sig_desc, -sig_acc) %>% distinct(tar, .keep_all = TRUE)
  Result <- Result %>% rename("Taxid" = "Organism Taxonomic ID")
  
  
  
  return(Result)
  
}

Domains <- c("Protein kinase C terminal domain", "PH domain", "Protein kinase domain")

# Read in the relevant information for each of the tsv files I will need
# Should be a few here
taxonomyInfo <- read_csv(file = "~/GitHub/AKT_Research/CSV_Files/Combined_CSVs/Complete_Taxonomy_Information.csv")
superGroupInfo <- read_csv(file = "~/GitHub/AKT_Research/CSV_Files/Master_Table.csv")
superGroupInfo <- superGroupInfo %>% rename("Taxid" = "Organism_Taxonomic_ID")
information1 <- read_csv(file = "~/GitHub/AKT_Research/CSV_Files/Combined_CSVs/Combined_A_Potential.csv")

# Call in the function calls and get the initial dataframes loaded in and assembled
testdf <- read_assign_TSV(input_directory = "~/GitHub/AKT_Research/CSV_Files/Combined_TSVs/AKT")
finaldf <- find_potentials(testdf, information1, Domains)

finaldf <- left_join(finaldf, taxonomyInfo, by = "Taxid")
finaldf <- finaldf %>% select(-`Species name`)
finaldf <- left_join(finaldf, superGroupInfo[c("Taxid", "Super.Group")], by = "Taxid")


# Version of the plot that shows the number of potential proteins found
# Organized by Organism Name
finaldf %>% ggplot(aes(x = `Organism Name`, fill = `Super.Group`)) +
  geom_bar()+
  xlab("Organism Name")+
  ylab("Total Count of AKT Like Proteins Found")+
  theme_minimal()


# Version of the plot that shows the number of potential proteins found
# Organized by Super Group
finaldf %>% ggplot(aes(x = `Super.Group`, fill = `Super.Group`))+
  geom_bar()+
  xlab("Super Group")+
  ylab("Number of potentials found")+
  theme_minimal()















