#' Search for coral data on coraltraits.org
#'
#' @name coral
#' @param taxon A taxon id
#' @param trait A trait id
#' @param location A location id
#' @param methodology A methodology id
#' @param resource A resource id
#' @param taxonomy logical; Include contextual data. Default: FALSE
#' @param contextual logical; Include contextual data. Default: TRUE
#' @param global logical; Include contextual data. Default: FALSE
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @references \url{http://coraltraits.org/}
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples \donttest{
#' # Get the species and their Ids
#' head( coral_species() )
#'
#' # Get data by taxon
#' coral_taxa(80)
#'
#' # Get data by trait
#' coral_traits(105)
#'
#' # Get data by methodology
#' coral_methodologies(2)
#'
#' # Get data by location
#' coral_locations(132)
#'
#' # Get data by resource
#' coral_resources(10)
#'
#' # curl options
#' library("httr")
#' coral_taxa(80, config=verbose())
#' }

#' @export
#' @rdname coral
coral_taxa <- function(taxon, taxonomy = FALSE, contextual = TRUE, global = FALSE, ...) {
  args <- list(taxonomy = lsw(taxonomy), contextual = lsw(contextual), global = lsw(global))
  coral_GET(coral_url("species", taxon), args, ...)
}

#' @export
#' @rdname coral
coral_traits <- function(trait, taxonomy = FALSE, contextual = TRUE, global = FALSE, ...) {
  args <- list(taxonomy = lsw(taxonomy), contextual = lsw(contextual), global = lsw(global))
  coral_GET(coral_url("traits", trait), args, ...)
}

#' @export
#' @rdname coral
coral_locations <- function(location, taxonomy = FALSE, contextual = TRUE, global = FALSE, ...) {
  args <- list(taxonomy = lsw(taxonomy), contextual = lsw(contextual), global = lsw(global))
  coral_GET(coral_url("locations", location), args, ...)
}

#' @export
#' @rdname coral
coral_methodologies <- function(methodology, taxonomy = FALSE, contextual = TRUE, global = FALSE, ...) {
  args <- list(taxonomy = lsw(taxonomy), contextual = lsw(contextual), global = lsw(global))
  coral_GET(coral_url("methodologies", methodology), args, ...)
}

#' @export
#' @rdname coral
coral_resources <- function(resource, taxonomy = FALSE, contextual = TRUE, global = FALSE, ...) {
  args <- list(taxonomy = lsw(taxonomy), contextual = lsw(contextual), global = lsw(global))
  coral_GET(coral_url("resources", resource), args, ...)
}

#' @export
#' @rdname coral
coral_species <- function(...) {
  res <- GET("https://coraltraits.org/species?all=true", ...)
  stop_for_status(res)
  html <- content(res)
  ids <- gsub("\n+|\t+|\\s+", "", xpathSApply(html, '//li[@class="list-group-item"]//div[@style="color: lightgrey;"]', xmlValue))
  nms <- xpathSApply(html, '//li[@class="list-group-item"]//div[@class="col-sm-5"]//a', xmlValue)
  dplyr::tbl_df(data.frame(name = nms, id = ids, stringsAsFactors = FALSE))
}

coral_GET <- function(url, args, ...) {
  res <- GET(url, query = args, ...)
  stop_for_status(res)
  txt <- content(res, "text")
  dplyr::tbl_df(read.csv(text = txt, header = TRUE, stringsAsFactors = FALSE))
}

coralbase <- function() 'http://coraltraits.org'
coral_url <- function(var, id) paste0(file.path(coralbase(), var, id), ".csv")
lsw <- function(x) if (x) "on" else "off"
