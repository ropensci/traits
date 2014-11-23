#' Search for coral data on http://coraltraits.org/.
#'
#' @name coral
#' @param coral xxx
#' @param trait xxx
#' @param taxonomy xxx
#' @param contextual xxx
#' @param global xxx
#' @param coral xxx
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @references See info for each data source at \url{http://coraltraits.org/}
#' @examples \donttest{
#' # Get data by taxon
#' df <- coral_taxa(80)
#' head(df)
#'
#' # Get data by trait
#' df <- coral_traits(105)
#' head(df)
#'
#' # Get data by methodology
#' df <- coral_methodologies(2)
#' head(df)
#'
#' # Get data by location
#' df <- coral_locations(132)
#' head(df)
#'
#' # Get data by resource
#' df <- coral_resources(10)
#' head(df)
#' }

#' @export
#' @rdname coral
coral_taxa <- function(taxon, taxonomy = "off", contextual = "on", global = "off", ...)
{
  args <- list(taxonomy=taxonomy, contextual=contextual, global=global)
  coral_GET(coral_url("corals", taxon), args, ...)
}

#' @export
#' @rdname coral
coral_traits <- function(trait, taxonomy = "off", contextual = "on", global = "off", ...)
{
  args <- list(taxonomy=taxonomy, contextual=contextual, global=global)
  coral_GET(coral_url("traits", trait), args, ...)
}

#' @export
#' @rdname coral
coral_locations <- function(location, taxonomy = "off", contextual = "on", global = "off", ...)
{
  args <- list(taxonomy=taxonomy, contextual=contextual, global=global)
  coral_GET(coral_url("locations", location), args, ...)
}

#' @export
#' @rdname coral
coral_methodologies <- function(methodology, taxonomy = "off", contextual = "on", global = "off", ...)
{
  args <- list(taxonomy=taxonomy, contextual=contextual, global=global)
  coral_GET(coral_url("methodologies", methodology), args, ...)
}

#' @export
#' @rdname coral
coral_resources <- function(resource, taxonomy = "off", contextual = "on", global = "off", ...)
{
  args <- list(taxonomy=taxonomy, contextual=contextual, global=global)
  coral_GET(coral_url("resources", resource), args, ...)
}

coral_GET <- function(url, args, ...){
  res <- GET(url, query = args, ...)
  stop_for_status(res)
  txt <- content(res, "text")
  read.csv(text=txt, header = TRUE, stringsAsFactors = FALSE)
}

coralbase <- function() 'http://coraltraits.org'
coral_url <- function(var, id) paste0(file.path(coralbase(), var, id), ".csv")
