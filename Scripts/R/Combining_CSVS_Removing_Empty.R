
# Read in the standard library script

source(file = "~/GitHub/AKT_Research/Scripts/R/Library_Script.R")





Combining_CSV <- function(input_directory, protein){
  
  formatted_output_string <- sprintf("~/GitHub/AKT_Research/CSV_Files/Combined_CSVs/Combined_%s_Potential.csv", protein)
  
  file_list <- list.files(path = input_directory,
                          pattern = "\\.*csv",
                          full.names = TRUE)
  list_of_tibbles <- map(file_list, read_csv, show_col_types = FALSE)
  filtered_tibbles <- keep(list_of_tibbles, ~nrow(.x) > 1)
  Combined_tibbles <- bind_rows(filtered_tibbles)
  
  write_csv(Combined_tibbles, file = formatted_output_string)
  
}


Combining_CSV(input_directory = "~/GitHub/AKT_Research/CSV_Files/AKT/Combined_CSVs", protein = "AKT")













