source(file = "~/GitHub/AKT_Research/Scripts/R/Library_Script.R")


# Read in the human blast tsv file and add in the appropriate header names
# Relocate the sseqid column to the front for key mapping to the tree

mapping_data_human <- read_tsv(file = "C:/Users/kajoh/OneDrive/Documents/GitHub/AKT_Research/Trees/Human_Control/human_agc_blast.tsv", col_names = FALSE)
mapping_data_human <- mapping_data_human %>% rename(qseqid =X1,
                                    sseqid=X2,
                                    pident=X3,
                                    length=X4,
                                    mismatch=X5,
                                    gapopen=X6,
                                    qstart=X7,
                                    qend=X8,
                                    sstart=X9,
                                    send=X10,
                                    evalue=X11,
                                    bitscore=X12) %>% relocate(sseqid)

human_tree_file = read.tree(file = "C:/Users/kajoh/OneDrive/Documents/GitHub/AKT_Research/Trees/Human_Control/human_agc_tree.nwk")

circle_tree <- ggtree(human_tree_file, layout = "circular", ladderize = FALSE)%<+% mapping_data_human
circle_tree













