
#source = (file ~ "C:/Users/sarah/Desktop/Test_Folder/Combined_tsv_outputs")
library(tidyverse)

tsv_in_R <- function(input_directory){
  
  #create a new vector of column names
  new_column_names <- c("tar", "seq_md5", "seq_length", "Analysis",
                         "sig_acc", "sig_desc", "start", "stop",
                         "e_value", "status", "date", "ipr_acc", "ipr_desc")
  
  # list all tsv files from input directory and keep their path
  list_of_tsv_files <- list.files(path = input_directory, pattern = "*.tsv", full.names = TRUE)
  
  # take the list of tsv FILES and: read them while ignoring column names
  # iterate through each file in the list and read each csv (x represents the current element)
  # ~ represents an anonymous function: that reads the tsvs
  
  list_of_tsvs <- map(list_of_tsv_files, ~read_tsv(.x, col_names = FALSE, show_col_types = FALSE))
  
  #add names to tsv each tsv file
  tsv_with_names <- map(list_of_tsvs, ~setNames(.x, new_column_names))
  
  # merge the rows of the tsvs in the list
  merged_tsv <- bind_rows(tsv_with_names)
  
  #remove columns 14 and 15
  merged_tsv <- select(merged_tsv, -c(14, 15))
  

  return(merged_tsv)
  }

result <- tsv_in_R(input_directory = "C:/Users/sarah/Desktop/Test_Folder/Combined_tsv_outputs")

write_tsv(result, "master_tsv.tsv")

