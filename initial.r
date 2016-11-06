# clear the decks
rm(list=ls()) 
options(stringsAsFactors=FALSE)
library(jsonlite)
library(dplyr)
# library(httr)


# This codes gets "inputs/index_offerings.json"
# parses this json file to get the urls .....
# and then downloads data from the urls (2 x 13 = 26 urls)
# and then stores two lists as an RDA file.

# read the json file amd parse it into an R list

lst_ckan <- jsonlite::fromJSON("http://data.gov.au/api/3/action/package_list")
source("fn_read_url.r")
# there are 23,348 of these
vct_url_suffix <- lst_ckan$result

vct_results <- lst_ckan$result
length(vct_results) == 23348
str_html_stem <- "http://data.gov.au/api/3/action/package_show?id="
vct_urls <- paste0(str_html_stem, vct_results)


# for (i in 1:length(vct_urls))  

lst_ckan_results <- list()
for (i in 1:10)  {
  lst_ckan_results[[vct_urls[i]]] <- fn_read_url(vct_urls[i])
  print(i)
}



