source(file="~/GitHub/AKT_Research/Scripts/R/Library_Script.R")
referenceglobal <- read_csv(file = "~/GitHub/AKT_Research/CSV_Files/Combined_CSVs/Reference_Global.csv")
referenceglobal <- referenceglobal %>% select(-1) %>% relocate('hit_id')


# Need to get the csv with all of the pkinase hits with accession numbers
# This is to tie the specific proteins to a specific accession
# Therefore, allowing the addition of phylogenetic information

#additionalinfo <- read_csv(file = "")


tree <- read.tree(file = "~/GitHub/AKT_Research/Trees/300distancetree.tree")


# 300 distance
rawtreeplot <- ggtree(tree, layout = "circular") %<+% referenceglobal
treeplot <- rawtreeplot + geom_tiplab(aes(label = `hit_description`), size = 1.75)
treeplot

# 200 distance

tree2 <- read.tree(file = "~/GitHub/AKT_Research/Trees/200distancetree.tree")
rawtree2plot <- ggtree(tree2, layout = "circular") %<+% referenceglobal
treeplot2 <- rawtreeplot + geom_tiplab(aes(label = `hit_description`), size = 1.75)
treeplot2




#100 is too hard to read overall
tree3 <- read.tree(file = "~/GitHub/AKT_Research/Trees/100distancetree.tree")
rawtreeplot3 <- ggtree(tree3, layout = "circular") %<+% referenceglobal
treeplot3 <- rawtreeplot3 + geom_tiplab(aes(label = `hit_description`), size = 1.75)
treeplot3
