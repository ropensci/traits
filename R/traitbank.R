#' Search for traits from EOL's Traitbank.
#'
#' @export
#'
#' @param pageid A page id. I know, not ideal. Would be better if this was a trait
#' id or trait name. This is the page ID for a taxon, not a trait. Apparently, traits
#' don't have pages. Note: this parameter used to be \code{trait}, but badly
#' mis-represented what the input actually represents.
#' @param cache_ttl Cache code
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @references http://eol.org/info/516
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @details See http://eol.org/data_glossary for human readable definitions for
#' the attribute terms that EOL uses. Go to http://eol.org/data_search for the
#' web interface to Traitbank.
#' @examples \dontrun{
#' # Get data for Balaenoptera musculus (http://eol.org/pages/328574/)
#' res <- traitbank(328574)
#' res$context
#' names( res$graph )
#' head( res$graph )
#'
#' # Get data for Closterocerus formosus (http://eol.org/pages/846827/)
#' traitbank(846827)
#' }
traitbank <- function(pageid, cache_ttl = NULL, ...) {
  args <- traitsc(list(cache_ttl = cache_ttl))
  if (length(args) == 0) args <- NULL
  res <- traitbank_GET(paste0(tburl(), pageid), args, ...)
  if (all(c("item", "@context") %in% names(res)) && "traits" %in% names(res$item)) {
    df <- res$item$traits
    df <- stats::setNames(df, tolower(names(df)))
    ct <- res$`@context`
  } else {
    temp <- lapply(res, names)
    temp <- paste(shQuote(paste(rep(names(temp), times = lengths(temp)), unlist(temp),
      sep = ":")), collapse = ", ")
    message("API of eol's traitbank appears to have changed. Object structure\n",
      "\t* expected (among other elements): 'item$traits' and '@context'",
      "\t* received:", temp)
    df <- ct <- NULL
  }
  structure(list(context = ct, graph = tibble::as_tibble(df)),
            class = "traitbank")
}

traitbank_GET <- function(url, args = list(), ...){
  res <- GET(url, query = args, ...)
  stop_for_status(res)
  txt <- content(res, "text", encoding = "UTF-8")
  jsonlite::fromJSON(txt, TRUE, flatten = TRUE)
}

tburl <- function() 'http://eol.org/api/traits/'
