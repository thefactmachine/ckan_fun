---
title: "README"
author: "Mark Hatcher"
date: "07/11/2016"
output: html_document
---

# Processing CKAN from data.gov.au

## Instructions


Run *"capture_url_information.r"*  This pulls data from the CKAN api.  
Depending on your web connection, it make take an hour or so to run.
This creates a local file called "results.rda"  
On my machine this file is 17.5 MB. It has not been included in this repo.
The file results.rda is an R list. Each element of the list is a JSON file.

Then run *"process_results.r"* This pulls in the results.rda file and extracts
various pieces of the JSON file. The results are saved in a R file called: 
"df_results.rda"  This file has been included in the repo.  This program
also creates an Excel file called:   

*"data_gov_au_ckan_extract_DATE.xlsx"*  

This file contains an easy to read listing of key CKAN columns.