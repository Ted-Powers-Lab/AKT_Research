source(file = "~/GitHub/AKT_Research/Scripts/R/Library_Script.R")

df1 <- read_csv(file = "~/GitHub/AKT_Research/CSV_Files/mergeddata.csv")
df1 <- df1 %>% filter(hit_bitscore > 100)
