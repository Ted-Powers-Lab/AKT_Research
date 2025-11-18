
source(file = "~/GitHub/Fungal_MTORC1/R_Scripts/Library_Script.R")



# Do some quick reading in the files, adding some additional information, and then writing them back as the same
Stramenopiles <- read_csv(file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/CSV_Files/S6K/Combined_Stramenopiles_S6K.csv")
Stramenopiles <- Stramenopiles %>% mutate(SuperGroup == "Stramenopiles")
write_csv(Stramenopiles, file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/CSV_Files/S6K/Combined_Stramenopiles_S6K.csv")

Alveolata <- read_csv(file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/CSV_Files/S6K/Combined_Alveolata_S6K.csv")
Alveolata <- Alveolata %>% mutate(SuperGroup == "Avleolata")
write_csv(Alveolata, file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/CSV_Files/S6K/Combined_Alveolata_S6K.csv")

Rhizaria <- read_csv(file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/CSV_Files/S6K/Combined_Rhizaria_S6K.csv")
Rhizaria <- Rhizaria %>% mutate(SuperGroup == "Rhizaria")
write_csv(Rhizaria, file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/CSV_Files/S6K/Combined_Rhizaria_S6K.csv")

Chlorophyta <- read_csv(file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/CSV_Files/S6K/Combined_Chlorophyta_S6K.csv")
Chlorophyta <- Chlorophyta %>% mutate(SuperGroup == "Chlorophyta")
write_csv(Chlorophyta, file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/CSV_Files/S6K/Combined_Chlorophyta_S6K.csv")

Streptophyta <- read_csv(file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/CSV_Files/S6K/Combined_Streptophyta_S6K.csv")
Streptophyta <- Streptophyta %>% mutate(SuperGroup == "Streptophyta")
write_csv(Streptophyta, file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/CSV_Files/S6K/Combined_Streptophyta_S6K.csv")

Rhodophyta <- read_csv(file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/CSV_Files/S6K/Combined_Rhodophyta_S6K.csv")
Rhodophyta <- Rhodophyta %>% mutate(SuperGroup == "Rhodophyta")
write_csv(Rhodophyta, file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/CSV_Files/S6K/Combined_Rhodophyta_S6K.csv")

Discoba <- read_csv(file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/CSV_Files/S6K/Combined_Discoba_S6K.csv")
Discoba <- Discoba %>% mutate(SuperGroup == "Discoba")
write_csv(Discoba, file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/CSV_Files/S6K/Combined_Discoba_S6K.csv")

Metamonada <- read_csv(file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/CSV_Files/S6K/Combined_Metamonada_S6K.csv")
Metamonada <- Metamonada %>% mutate(SuperGroup == "Metamonada")
write_csv(Metamonada, file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/CSV_Files/S6K/Combined_Metamonada_S6K.csv")