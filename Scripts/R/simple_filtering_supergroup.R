



source(file = "~/GitHub/AKT_Research/Scripts/R/Library_Script.R")


data_to_be_manipulated <- read.csv(file = "~/GitHub/AKT_Research/CSV_Files/finalmappingdata.csv")
data_to_be_manipulated <- data_to_be_manipulated %>% select(-1) %>% filter(Super.Group == "Alveolata" | Super.Group == "Stramenopiles" | Super.Group == "Rhizaria")



#Alveolata Information
alveolata_data <- data_to_be_manipulated %>% filter(Super.Group == "Alveolata")

#Stramenopile Information
stramenopile_data <- data_to_be_manipulated %>% filter(Super.Group == "Stramenopiles")

#Rhizaria Information
rhizaria_data <- data_to_be_manipulated %>% filter(Super.Group == "Rhizaria")


write.csv(alveolata_data, file = "C:/Users/kajoh/OneDrive/Documents/GitHub/AKT_Research/CSV_Files/SAR_Data/alveolata_data.csv")
write.csv(stramenopile_data, file = "C:/Users/kajoh/OneDrive/Documents/GitHub/AKT_Research/CSV_Files/SAR_Data/stramenopile_data.csv")
write.csv(rhizaria_data, file = "C:/Users/kajoh/OneDrive/Documents/GitHub/AKT_Research/CSV_Files/SAR_Data/rhizaria_data.csv")


