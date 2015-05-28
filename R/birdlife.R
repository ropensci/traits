#' Get bird habitat information from BirdLife/IUCN
#'
#' @importFrom XML readHTMLTable
#' @export
#'
#' @param id IUCN species ID
#'
#' @return a \code{data.frame} with level 1 and level 2 habitat classes, as well as importance
#' ratings and occurrence type (e.g. breeding or non-breeding).  The habitat classification
#' scheme is described at http://www.iucnredlist.org/technical-documents/classification-schemes/habitats-classification-scheme-ver3
birdlife_habitat = function(id){
  url = paste0(
    "http://www.birdlife.org/datazone/species/factsheet/",
    id,
    "/additional"
  )

  tables = XML::readHTMLTable(url)

  # Find the table that has "Habitat" as a column name
  habitat_table_number = which(
    sapply(tables, function(table){any(grepl("Habitat", colnames(table)))})
  )

  out = cbind(id, tables[[habitat_table_number]])
  out[-nrow(out), ] # Drop last row (altitude)
}
