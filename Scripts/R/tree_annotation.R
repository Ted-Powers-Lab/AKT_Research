source(file = "~/GitHub/AKT_Research/Scripts/R/Library_Script.R")



# Read in the plain tree file
plain_tree <- read.newick(file = "~/GitHub/AKT_Research/Trees/200filterdistancetree.tree")


plain_tree_tibble <- as_tibble(plain_tree)
annotation_data <- read.csv(file = "~/GitHub/AKT_Research/CSV_Files/finalmappingdata.csv")
annotation_data <- annotation_data %>% select(-1) %>% rename(label = "hit_id")


annotated_tree <- full_join(plain_tree, annotation_data, by = "label")


write.beast.newick(annotated_tree, file = "~/GitHub/AKT_Research/Trees/test.nwk")

