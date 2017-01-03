## only run if betydb.org is up
check_betydb <- function(url){
  if (httr::status_code(httr::GET("https://www.betydb.org")) != 200) {
    skip("Betydb is offline.")
  }
}

## only run if eol.org is up
check_traitbank <- function(url){
  if (httr::status_code(httr::GET("http://eol.org/api")) != 200) {
    skip("eol's traitbank is offline.")
  }
}
