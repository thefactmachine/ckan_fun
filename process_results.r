# clear the decks
rm(list=ls()) 
options(stringsAsFactors=FALSE)
library(jsonlite)
library(dplyr)
library(xlsx)


# returns lst_ckan_results  (length ix 23348)
load(file = "results.rda")

# work out which entires contained the "result" 
vct_bln_results <- sapply(lst_ckan_results, function(x) { "result" %in% names(x) &&  is.recursive(x) })

# length here is 23,347
lst_ckan_results_valid <- lst_ckan_results[vct_bln_results]


# ==================================================
# contact point.................

vct_contact_point <- vapply(seq_along(lst_ckan_results_valid), 
              function(x) {ifelse("contact_point" %in% names(lst_ckan_results_valid[[x]]$result), 
                            lst_ckan_results_valid[[x]]$result$contact_point , 
                            "not defined")
  },  character(1))

length(vct_contact_point) == length(lst_ckan_results_valid)

# ==================================================
# created...............

vct_created <- vapply(seq_along(lst_ckan_results_valid), 
                           function(x) { 
                            ifelse("organization" %in% names(lst_ckan_results_valid[[x]]$result) && 
                                   "created" %in% names(lst_ckan_results_valid[[x]]$result$organization) &&  
                                   !is.null(lst_ckan_results_valid[[x]]$result$organization$created), 
                                 lst_ckan_results_valid[[x]]$result$organization$created, "no creation date") }, character(1))
# table(vct_created)
length(vct_created) == length(lst_ckan_results_valid)
# ==================================================

# created....org name
vct_org_name <- vapply(seq_along(lst_ckan_results_valid), 
                      function(x) { 
                        ifelse("organization" %in% names(lst_ckan_results_valid[[x]]$result) && 
                                 "name" %in% names(lst_ckan_results_valid[[x]]$result$organization) &&  
                                 !is.null(lst_ckan_results_valid[[x]]$result$organization$name), 
                                  lst_ckan_results_valid[[x]]$result$organization$name, "no org name") }, character(1))

# table(vct_org_name)
length(vct_org_name) == length(lst_ckan_results_valid)
# ==================================================

#  test$result$resources$format
vct_format <- vapply(seq_along(lst_ckan_results_valid), 
                       function(x) { 
                         ifelse("resources" %in% names(lst_ckan_results_valid[[x]]$result) && 
                                  "format" %in% names(lst_ckan_results_valid[[x]]$result$resources) &&  
                                  !is.null(lst_ckan_results_valid[[x]]$result$resources$format), 
                                lst_ckan_results_valid[[x]]$result$resources$format, "no format") }, character(1))
#table(vct_format)
length(vct_format) == length(lst_ckan_results_valid)

# ==================================================
#  test$result$resources$url
vct_url <- vapply(seq_along(lst_ckan_results_valid), 
                     function(x) { 
                       ifelse("resources" %in% names(lst_ckan_results_valid[[x]]$result) && 
                                "url" %in% names(lst_ckan_results_valid[[x]]$result$resources) &&  
                                !is.null(lst_ckan_results_valid[[x]]$result$resources$url), 
                              lst_ckan_results_valid[[x]]$result$resources$url, "no url") }, character(1))
#table(vct_format)
length(vct_url) == length(lst_ckan_results_valid)

# ==================================================
#  test$result$title
vct_title <- vapply(seq_along(lst_ckan_results_valid), 
                  function(x) { 
                    ifelse("title" %in% names(lst_ckan_results_valid[[x]]$result) && 
                          !is.null(lst_ckan_results_valid[[x]]$result$title), 
                           lst_ckan_results_valid[[x]]$result$title, "no title") }, character(1))

length(vct_title) == length(lst_ckan_results_valid)

# ==================================================

# this returns NA's if badly formed data
vct_date_created <- as.Date(vct_created, "%Y-%m-%d")

# ==================================================

vct_ckan_ref <- names(lst_ckan_results_valid)
vct_id <- 1:length(lst_ckan_results_valid)

# ==================================================
# ==================================================


# we now have
#  vct_contact_point  ok
#  vct_date_created ok
#  vct_org_name ok
#  vct_format ok
#  vct_url ok
#  vct_title ok
#  vct_ckan_ref ok
#   vct_id ok

df_result <- data.frame(num = vct_id,  
                        contact = vct_contact_point,
                        organisation = vct_org_name,
                        format = vct_format,
                        create_date = vct_date_created,
                        title = vct_title,
                        url = vct_url,
                        ckan_ref = vct_ckan_ref
                         )

# save the sucker for future processing.
save(df_result, file = "df_results.rda")


c_date_char <- Sys.Date() %>% as.character() %>% gsub("-","", . )
c_file_name_stem <- "data_gov_au_ckan_extract_"
c_file_name <- paste0(c_file_name_stem, c_date_char, ".xlsx")


write.xlsx2(x = df_result, file = c_file_name,
           sheetName = "ckan_data", row.names = FALSE, showNA = TRUE)

