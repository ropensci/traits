#' Search for traits from EOL's Traitbank.
#'
#' @export
#'
#' @param trait A page id. I know, not ideal. Would be better if this was a trait
#' id or trait name.
#' @param cache_ttl Cache code
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @references \url{http://eol.org/info/516}
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @details See \url{http://eol.org/data_glossary} for human readable definitions for
#' the attribute terms that EOL uses. Go to \url{http://eol.org/data_search} for the
#' web interface to Traitbank.
#' @examples \donttest{
#' res <- traitbank(trait = 328574)
#' res$context
#' names( res$graph )
#' head( res$graph )
#' }
traitbank <- function(trait, cache_ttl = NULL, ...) {
  args <- traitsc(list(cache_ttl = cache_ttl))
  if (length(args) == 0) args <- NULL
  res <- traitbank_GET(paste0(tburl(), trait), args, ...)
  df <- res$`@graph`
  meas <- unlist(sapply(df$`dwc:measurementValue`, function(x) {
    if (length(x) == 0) {
      NA
    } else {
      if (length(x) > 1) x[[1]][[1]] else x
    }
  }))
  meas_id <- sapply(df$`dwc:measurementValue`, function(x) if (length(x) > 1) x$`@id` else NA)
  df$`dwc:measurementValue` <- NULL
  df$`dwc:measurementValue.id` <- NULL
  df <- data.frame(df, `dwc:measurementValue` = meas,
                   `dwc:measurementValue.id` = meas_id, stringsAsFactors = FALSE)
  df <- setNames(df, tolower(names(df)))
  structure(list(context = res$`@context`, graph = dplyr::tbl_df(df)), class = "traitbank")
}

traitbank_GET <- function(url, args = list(), ...){
  res <- GET(url, query = args, ...)
  stop_for_status(res)
  txt <- content(res, "text")
  jsonlite::fromJSON(txt, TRUE, flatten = TRUE)
}

tburl <- function() 'http://eol.org/api/traits/'
