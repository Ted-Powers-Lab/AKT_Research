library(tidyverse)


csv_filter <- function(input_dir){
  
  # make a list of the csv files from the input directory
  combined_csvs_list <- list.files(path = input_dir, pattern = "\\.csv$", full.names = TRUE)
  
  
  # iterate through each csv file in the list
  # read csvs for each csv file in the list
  # filter the score column and keep only rows where score is greater than 100
  potential_AKTs <- map(combined_csvs_list, ~read_csv(.x) %>% filter(full_score>100))
  
  # assign the file name to each element in potential_AKTs
  names(potential_AKTs) <- basename(combined_csvs_list)
  
  return(potential_AKTs)
  }


# input the folder you wish to run the R script on
args <- commandArgs(trailingOnly = TRUE)
input_dir = NULL
print("At this point we are here")
if (length(args)>0){
  input_dir <- args[1]
  print("Assinged value to input diretory")
} 


results <- csv_filter(input_dir)


# make an output directory for the filtered results
output_folder_path <- file.path(input_dir, "Results")
if (!dir.exists(output_folder_path)) {
  dir.create(output_folder_path)
}






# write out the filtered csv files and save it to output folder
# loop through the the potential_AKT list and its corresponding file names
walk2(results, names(results), ~ {
  new_name <- paste0("filtered_", .y) # rename the file to filtered
  write_csv(.x, file.path(output_folder_path, new_name)) # rewrite csv and give it a new filename
})










