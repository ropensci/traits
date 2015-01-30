#' Search for traits from BettyDB
#'
#' @importFrom dplyr tbl_df
#' @name betydb
#'
#' @param genus (character) A genus name. Optional
#' @param species (character) A specific epithet. Optional
#' @param fmt (character) Format to return data in, one of json, xml, csv. Only json
#' currently supported.
#' @param key (character) An API key. Use this or user/pwd combo. Optional
#' @param user,pwd (character) A user name and password. Use a user/pwd combo or an API key.
#' Optional
#' @param ... Curl options passed on to \code{\link[httr]{GET}}. Optional
#' @references API documentation \url{https://www.authorea.com/users/5574/articles/7062}
#' @details Authentication defers to use API key first since it's simpler, but if you don't have
#' an API key, you can supply a username and password.
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples \dontrun{
#' out <- bety_traits(genus = 'Miscanthus', species = "giganteus")
#' head(out)
#' }

#' @export
#' @rdname betydb
bety_traits <- function(genus = NULL, species = NULL, fmt = "json", key=NULL, user=NULL, pwd=NULL, ...){
  args <- traitsc(list(genus = genus, species = species))
  fmt <- match.arg(fmt, c("json","xml","csv"))
  betydb_GET(url=paste0(betyurl(), "traits.", fmt), args, key, user, pwd, ...)
}

betydb_GET <- function(url, args = list(), key, user, pwd, ...){
  auth <- bety_auth(user, pwd, key)
  res <- if(is.null(auth$key)){
    GET(url, query = args, authenticate(auth$user, auth$pwd))
  } else {
    GET(url, query = c(key=auth$key, args))
  }
  stop_for_status(res)
  txt <- content(res, "text")
  tbl_df(jsonlite::fromJSON(txt, TRUE))
}

bety_auth <- function(x,y,z){
  if(is.null(z) && is.null(x)){
    z <- getOption("betydb_key", NULL)
  }
  if(!is.null(z)) {
    list(key=z)
  } else {
    if(is.null(x)) x <- getOption("betydb_user", "")
    if(x == "") stop(warn, call. = FALSE)
    if(is.null(y)) y <- getOption("betydb_pwd", "")
    if(y == "") stop(warn, call. = FALSE)
    list(user=x, pwd=y, key=NULL)
  }
}

warn <- "Supply either api key, or user name/password combo"
betyurl <- function() 'https://www.betydb.org/'
