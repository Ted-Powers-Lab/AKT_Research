source(file = "~/GitHub/AKT_Research/Scripts/R/Library_Script.R")

hmmerdata <- read_csv(file = "~/GitHub/AKT_Research/CSV_Files/FinalHmmer2Data.csv")
tortable <- read_csv(file = "~/GitHub/AKT_Research/CSV_Files/Publication_Ready_Table.csv")
tortable <- tortable %>% rename(Taxid = "Organism_Taxonomic_ID") %>% select(-1)
tortable <- tortable %>% mutate(TORC2_Presence = case_when(
  RICTOR == "H" ~ "TORC2 Expected",
  RICTOR == "M" ~ "TORC2 Expected",
  RICTOR == "L" ~ "TORC2 Expected",
  TRUE ~ "No TORC2"
))

finaltable <- left_join(hmmerdata, tortable[c("Taxid","Super.Group","M.Strategy","TORC2_Presence")])


# If the taxid number is for s.cerevisiae, s.pombe, h.sapiens, and d.melanogaster, change the Super Group to opisthokonta and M.strategy to Heterotroph
finaltable <- finaltable %>% mutate(M.Strategy = case_when(
  Taxid == 9606 | Taxid == 7227 | Taxid == 559292 | Taxid == 4896 ~ "Heterotroph",
  `Kingdom name` == "Viridiplantae" & M.Strategy == NA ~ "Autotrophic",
  `Phylum name` == "Streptophyta" & M.Strategy == NA ~ "Autotrophic",
  `Group name` == "Ciliophora" & M.Strategy == NA ~ "Heterotroph",
  `Group name` == "ciliates" & M.Strategy == NA ~ "Heterotroph",
  TRUE ~ M.Strategy
)) %>% mutate(Super.Group = case_when(
  Taxid == 9606 | Taxid == 7227 | Taxid == 559292 | Taxid == 4896 ~ "Opisthokonta",
  `Kingdom name` == "Viridiplantae" & Super.Group == NA ~ "Streptophyta",
  `Phylum name` == "Streptophyta" & Super.Group == NA ~ "Streptophyta",
  `Group name` == "Ciliophora" & Super.Group == NA ~ "Alveolata",
  `Group name` == "ciliates" & Super.Group == NA ~ "Alveolata",
  TRUE ~ Super.Group
)) %>% mutate(TORC2_Presence = case_when(
  Taxid == 9606 | Taxid == 7227 | Taxid == 559292 | Taxid == 4896 ~ "TORC2 Expected",
  `Group name` == "Ciliophora" & Super.Group == NA ~ "TORC2 Expected",
  `Group name` == "ciliates" & Super.Group == NA ~ "TORC2 Expected",
  `Kingdom name` == "Viridiplantae" & Super.Group == NA ~ "No TORC2",
  TRUE ~ TORC2_Presence
))




write_csv(finaltable, file = "~/GitHub/AKT_Research/CSV_Files/finalmappingdata.csv")
