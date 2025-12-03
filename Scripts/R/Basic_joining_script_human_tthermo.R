source(file = "~/GitHub/AKT_Research/Scripts/R/Library_Script.R")



# Load in the Human results
human <- read_csv(file = "C:/Users/kajoh/Desktop/AKT_Alignments/GCF_000001405.40.csv")
human <- human %>% select(-1)
human <- human %>% filter(hit_bitscore > 150)

t_thermophila <- read_csv(file = "C:/Users/kajoh/Desktop/AKT_Alignments/GCA_000189635.1.csv")
t_thermophila <- t_thermophila %>% select(-1)
t_thermophila <- t_thermophila %>% filter(hit_bitscore > 100)



human_thermophila_filtered <- full_join(human, t_thermophila)


write_csv(human_thermophila_filtered, file = "C:/Users/kajoh/Desktop/AKT_Alignments/Human_thermophila_filtered.csv")




