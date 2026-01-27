# Created by Kyle Johnson, 2026
# Purpose of this program is to create circular phylogenetic trees for the SAR group
# The trees used by this program are either produced using an MSA to iqtree pipeline
# Or the trees are created from an allvall blast to distance matrix approach
# 

source(file = "~/GitHub/AKT_Research/Scripts/R/Library_Script.R")
#Prep the mapping data
mapping_data <- read.csv(file = "~/GitHub/AKT_Research/CSV_Files/finalmappingdata.csv")
mapping_data <- mapping_data %>% select(-1)


#First step will be to read in the tree file for each of the SARs
#stramenopile_tree_data <- read.tree(file = "~/GitHub/AKT_Research/Trees/stramenopile_agc_tree.tree")
alveolata_tree_data <- read.tree(file = "~/GitHub/AKT_Research/Trees/aligned_cluster_alveolata_tree")
#rhizaria_tree_data <- read.tree(file = "")


  
#Begin with the stramenopile tree data
  #Goal will be to create a ggtree object, add mapping data, and then visualize
# stram_ggtree <- ggtree(stramenopile_tree_data)
# stram_ggtree <- stram_ggtree %<+% mapping_data

  
#Alveolata tree data here, similar process to the previous
alv_ggtree <- ggtree(alveolata_tree_data, layout = "daylight", branch.length = 'none')
alv_ggtree <- alv_ggtree %<+% mapping_data
alv_ggtree

  
  
  
#Rhizaria tree data here, similar process to the previous
# rhiz_ggtree <- ggtree(rhizaria_tree_data)

