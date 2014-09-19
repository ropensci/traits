library(XML)
library(RCurl)
ids = as.character(read.csv("data//2014BirdsInsu_Cont.csv")[,1])

# Distribution
# Population / trend
# Habitats & altitude

get_habitat = function(id){
  url = paste0(
    "http://www.birdlife.org/datazone/species/factsheet/", 
    id, 
    "/additional"
  )
  
  tables = readHTMLTable(url)
  
  # Find the table that has "Habitat" as a column name
  habitat_table_number = which(
    sapply(tables, function(table){any(grepl("Habitat", colnames(table)))})
  )
  cbind(id, tables[[habitat_table_number]])
}

habitat_data = do.call(rbind, lapply(ids, get_habitat))

write.csv(habitat_data, "data/habitat_data.csv")


get_trend = function(id){
  url = paste0(
    "http://www.birdlife.org/datazone/species/factsheet/", 
    id, 
    "/additional"
  )
  
  tables = readHTMLTable(url)
  
  # Find the table that has "Year of estimate" as a column name
  trend_table_number = which(
    sapply(tables, function(table){any(grepl("Year of estimate", colnames(table)))})
  )
  if(length(trend_table_number) > 0){
    return(cbind(id, tables[[trend_table_number]]))
  }else{
    return(NULL)
  }
  
}

trend_data = do.call(rbind, lapply(ids, get_trend))

write.csv(trend_data, "data/trend_data.csv")