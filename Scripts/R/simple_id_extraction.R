library(tidyverse)


df <- read_csv(file = "C:/Users/kajoh/OneDrive/Desktop/SGK_S6K_Proteins.csv")
df <- df %>% select(name)

write_csv(df, file = "C:/Users/kajoh/OneDrive/Desktop/SGK_S6K_Proteins_names.csv")

df2 <- read_csv(file = "C:/Users/kajoh/OneDrive/Desktop/sgkpotentials_subset.csv")
df2 <- df2 %>% select(name)

write_csv(df2, file = "C:/Users/kajoh/OneDrive/Desktop/sgk_small_subset_names.csv")
