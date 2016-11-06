fn_read_url <- function(url)  {
  out <- tryCatch(
    {
      # if there is more than one expression then we need the curly braces
      jsonlite::fromJSON(url)
      # The return value of jsonlite::fromJSON(url) is what is returned
      
    },
    error=function(cond) {
      message(paste("URL does not seem to exist:", url))
      message(cond)
      # Choose a return value in case of error
      return("ERROR")
    },
    warning=function(cond) {
      message(paste("URL caused a warning:", url))
      message(cond)
      # Choose a return value in case of warning
      return("WARNING")
    },
    finally={
      message(paste("Processed URL:", url))
    }
  )    
  return(out)
}