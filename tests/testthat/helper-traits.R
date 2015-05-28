## only run if betydb.org is up
check_betydb <- function(url){
  if (httr::status_code(httr::GET("https://www.betydb.org")) != 200) {
    skip("Betydb is offline.")
  }
}
