

source(file = "~/GitHub/AKT_Research/Scripts/R/Library_Script.R")


reference_global <- read_csv(file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/CSV_Files/Combined_CSVs/Reference_Global.csv")
reference_global <- reference_global %>% select(-1)
reference_global <- reference_global %>% rename('bitscore_global' = 'hit_bitscore')

#main_global
main_global <- read_csv(file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/CSV_Files/Combined_CSVs/Main_Global.csv")
main_global <- main_global %>% select(-1) %>% rename('bitscore_global' = 'hit_bitscore')







reference_local <- read_csv(file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/CSV_Files/Combined_CSVs/Reference_Local.csv")
reference_local <- reference_local %>% select(-1)
reference_local <- reference_local %>% rename('bitscore_local' = 'hit_bitscore')

main_local <- read_csv(file = "C:/Users/kajoh/Documents/GitHub/AKT_Research/CSV_Files/Combined_CSVs/Main_Local.csv")
main_local <- main_local %>% select(-1) %>% rename('bitscore_local' = 'hit_bitscore')





combined_reference <- left_join(reference_global,reference_local[c('hit_id','bitscore_local')], by = 'hit_id')
combined_reference <- combined_reference %>% mutate('source' = "reference")

combined_main <- left_join(main_global, main_local[c('hit_id', 'bitscore_local')], by = 'hit_id')
combined_main <- combined_main %>% mutate('source' = 'main')

total <- full_join(combined_reference, combined_main)

resultPlot <- total %>% ggplot(aes(x = bitscore_global, y = bitscore_local, color = source))+
  geom_point(position = 'jitter', size = 1.5)+
  geom_smooth(method = "loess",
              formula = y ~ x)+
  theme_bw()

resultPlot
ggsave("C:/Users/kajoh/Documents/GitHub/AKT_Research/Global_Local_Graph.png", plot = resultPlot, device = "png", width = 3840/200, height = 2160/200, units = "in", dpi = 200)


