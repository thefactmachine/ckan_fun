# clear the decks
rm(list=ls()) 
options(stringsAsFactors=FALSE)
library(jsonlite)
library(dplyr)
# library(httr)


# read the json file amd parse it into an R list
# this is top CKAN url which returns a list of CKAN references to each data set.
# the length of the returned data set is equal to the number data sets.
lst_ckan <- jsonlite::fromJSON("http://data.gov.au/api/3/action/package_list")
# the "result" frame is the only one which is relevant.
vct_results <- lst_ckan$result
# load in a function to return some text for each url supplied.
source("fn_read_url.r")

# main CKAN stem for datq.gov.au
str_html_stem <- "http://data.gov.au/api/3/action/package_show?id="

# we now have a vector or urls
vct_urls <- paste0(str_html_stem, vct_results)

# declare a blank list to hold our results
lst_ckan_results <- list()

# cycle through each url and save the resultant json object in
# a list
for (i in 1:length(vct_urls))  {
  lst_ckan_results[[vct_urls[i]]] <- fn_read_url(vct_urls[i])
  print(i)
}

# ASSERT: number of list elements == number of urls.
length(lst_ckan_results) == length(vct_results)

# save the sucker for future processing.
save(lst_ckan_results, file = "results.rda")