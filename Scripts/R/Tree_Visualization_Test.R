source(file = "~/GitHub/AKT_Research/Scripts/R/Library_Script.R")

reference_local <- read_csv(file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/CSV_Files/Combined_CSVs/Reference_Local.csv")
reference_local <- reference_local %>% select(-1) %>% relocate('hit_id')



test_tree <- read.iqtree(file = "C:/Users/kajoh/Desktop/OpisthokontaPotentialAKTsAlignment.fa.treefile")
tree_df <- as_tibble(test_tree)


Plot <- ggtree(test_tree, layout="circular", ladderize = FALSE) %<+% reference_local
Plot2 <- Plot + geom_tiplab(aes(label = `hit_description`), size = 2)+
  #geom_nodelab(aes(label = node), size = 3)+
  geom_hilight(node=357, fill="steelblue", alpha=.6, extend = 5)+
  geom_hilight(node=319, fill="darkgreen", alpha=.6, extend = 5)+
  geom_hilight(node=448, fill="darkred", alpha=.6, extend = 5)+
  geom_hilight(node=437, fill="purple", alpha=.6, extend = 5)
  
Plot2
ggsave("~/GitHub/AKT_Research/Human_AGC_Families.png",
       plot = Plot2,
       width = 3840/320,
       height = 2160/320,
       units = "in",
       dpi = 320,
       limitsize = FALSE)

