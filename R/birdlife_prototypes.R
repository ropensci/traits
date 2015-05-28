get_birdlife_habitat = function(id){
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
  out[-nrow(out)] # Drop last row (altitude)
}
