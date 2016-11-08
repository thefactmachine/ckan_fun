# clear the decks
rm(list=ls()) 
options(stringsAsFactors=FALSE)
library(jsonlite)
library(dplyr)
library(xlsx)

# returns lst_ckan_results  (length ix 23348)
load(file = "df_results.rda")

head(df_result)


df_by_agency <- df_result %>% 
                  group_by(organisation) %>% 
                  summarise(total = n()) %>%
                  arrange(desc(total)) %>% 
                  mutate(cum_sum = cumsum(total)) %>%
                  mutate(cum_sum_pc =  cum_sum /sum(total)) %>% as.data.frame()



write.xlsx2(x = df_by_agency, file = "total_by_agency.xlsx",
            sheetName = "total_by_agency", row.names = FALSE, showNA = TRUE)
