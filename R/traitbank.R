#' Search for traits from EOL's Traitbank.
#'
#' @name traitbank
#' @param trait A trait id
#' @param cache_ttl Cache code
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @references \url{http://eol.org/info/516}
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples \donttest{
#' traitbank(trait = 328574)
#' }

#' @export
#' @rdname traitbank
traitbank <- function(trait, cache_ttl = NULL, ...)
{
  args <- traitsc(list(cache_ttl=cache_ttl))
  traitbank_GET(paste0(tburl(), trait), args, ...)
}

traitbank_GET <- function(url, args = list(), ...){
  res <- GET(url, query = args, ...)
  stop_for_status(res)
  txt <- content(res, "text")
  jsonlite::fromJSON(txt, FALSE)
}

tburl <- function() 'http://eol.org/api/traits/'
