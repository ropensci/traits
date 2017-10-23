#' Get bird habitat information from BirdLife/IUCN
#'
#' @export
#' @param id A single IUCN species ID
#' @return a \code{data.frame} with level 1 and level 2 habitat classes, as
#' well as importance ratings and occurrence type (e.g. breeding or
#' non-breeding). The habitat classification scheme is described
#' at \url{http://bit.ly/1e6gKBr}
#' @author David J. Harris \email{harry491@@gmail.com}
#' @family birdlife
#' @examples \dontrun{
#' # Setophaga chrysoparia
#' birdlife_habitat(22721692)
#' # Passer domesticus
#' birdlife_habitat(103818789)
#' }
birdlife_habitat <- function(id) {
  stopifnot(length(id) == 1)
  url <- bl_url(id)
  tables <- make_tables(url)
  # Find the table that has "Habitat" as a column name
  habitat_table_number <- which(
    vapply(tables, function(table) any(grepl("Habitat", colnames(table))),
           logical(1))
  )
  out <- cbind(id, tables[[habitat_table_number]])
  out[-NROW(out), ] # Drop last row (altitude)
}

#' Get bird threat information from BirdLife/IUCN
#'
#' @export
#' @inheritParams birdlife_habitat
#' @return a \code{data.frame} with the species ID and two levels of threat
#' descriptions, plus stresses, timing, scope, severity, and impact associated
#' with each stressor.
#' @author David J. Harris \email{harry491@@gmail.com}
#' @family birdlife
#' @examples \dontrun{
#' # Setophaga chrysoparia
#' birdlife_threats(22721692)
#' # Aburria aburri
#' birdlife_threats(22678440)
#' }
birdlife_threats <- function(id) {
  stopifnot(length(id) == 1)
  url <- bl_url(id)
  tables <- make_tables(url)
  is_threats <- sapply(
    tables,
    function(x){
      all(c("Scope", "Severity", "Impact", "Timing") %in% unlist(x))
    }
  )
  if (sum(is_threats) > 1) {
    stop("Malformed input. Multiple threat tables in ID ", id)
  }
  if (sum(is_threats) == 1) {
    threats = tables[is_threats][[1]]

    rownums = seq_len(nrow(threats))

    out = data.frame(
      id = id,
      threat1  = threats[rownums %% 5 == 1, 1],
      threat2  = threats[rownums %% 5 == 1, 2],
      stresses = threats[rownums %% 5 == 0, 1],
      timing   = threats[rownums %% 5 == 2, 1],
      scope    = threats[rownums %% 5 == 2, 2],
      severity = threats[rownums %% 5 == 2, 3],
      impact   = threats[rownums %% 5 == 2, 4]
    )
  } else {
    out = NULL
  }
  out
}

make_tables <- function(x) {
  html <- xml2::read_html(x)
  tables <- xml2::xml_find_all(html, "//table")
  rvest::html_table(tables, fill = TRUE)
}

bl_base <- "http://datazone.birdlife.org/species/factsheet"
bl_url <- function(x) sprintf("%s/%s/details", bl_base, x)
