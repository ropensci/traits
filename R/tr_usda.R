#' USDA plants data
#'
#' @export
#' @param query (character) query terms in a named list
#' @param limit (integer) number of records to return
#' @param offset (integer) record number to start at
#' @param fields (character) vector of fields to return, case sensitive
#' @param ... Curl options passed on to [crul::HttpClient()]
#' @return list, with metadata fields ("count", "returned", "citation",
#' "terms"), and a data.frame in "data"
#' @details beware: this data is a bit old, from a dump of their data
#' from a while back.
#' @references https://plantsdb.xyz, https://github.com/sckott/usdaplantsapi
#' @examples \dontrun{
#' tr_usda(query = list(genus = "Magnolia"))
#' tr_usda(query = list(genus = "Magnolia", species = "grandiflora"))
#'
#' tr_usda(limit = 30)
#' tr_usda(limit = 3)
#' tr_usda(limit = 3, offset = 3)
#'
#' tr_usda(fields = c('Id', 'Symbol', 'Genus', 'Species'))
#' }
tr_usda <- function(query = list(), limit = 30, offset = 0, fields = NULL, ...) {
  cli <- crul::HttpClient$new(url = usda_base)
  if (!is.null(fields)) fields <- paste0(fields, collapse = ",")
  args <- traitsc(c(query, limit = limit, offset = offset, fields = fields))
  res <- cli$get("search", query = args, ...)
  res$raise_for_status()
  tmp <- jsonlite::fromJSON(res$parse("UTF-8"))
  tmp$data <- tibble::as_tibble(tmp$data)
  return(tmp)
}

usda_base <- "https://plantsdb.xyz"
