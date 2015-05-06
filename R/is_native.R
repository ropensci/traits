
is_native <- function(sp, where, region = c("america", "europe")){
  require(taxize)
  if(region == "america"){
    if(!where %in% c("Continental US", "Alaska", "Canada",
                     "Caribbean Territories", "Central Pacific Territories",
                     "Hawaii", "Mexico")){
      stop ("where must be one America region, see help for accepted names")
    }
    tsn_ <- get_tsn(searchterm = sp)[1]
    if(is.na(tsn_)){
      Out <- "species not in itis"
    } else {
      origin <- itis_native(tsn=tsn_)
      Out <- as.character(origin[which(origin$jurisdictionvalue == where), "origin"])
    }
  }
  if(region == "europe"){
    if(!where %in% c("Albania", "Austria", "Azores", "Belgium", "Islas_Baleares",
                     "Britain", "Bulgaria", "Corse", "Kriti",
                     "Czechoslovakia", "Denmark", "Faroer",
                     "Finland", "France", "Germany", "Greece",
                     "Ireland", "Switzerland", "Netherlands", "Spain",
                     "Hungary", "Iceland", "Italy", "Jugoslavia",
                     "Portugal", "Norway", "Poland", "Romania",
                     "USSR", "Sardegna", "Svalbard", "Sicilia",
                     "Sweden", "Turkey", "USSR_Northern_Division",
                     "USSR_Baltic_Division", "USSR_Central_Division",
                     "USSR_South_western", "USSR_Krym",
                     "USSRSouth_eastern_Division")){
      stop ("where must be one eu country, see help for accepted names")
    }
    origin <- fe_native(sp)
    if(where %in% origin$native){
      Out <- "Native"
    }
    if(where %in% origin$exotic) {
      Out <- "Introduced"
    }
    if(where %in% c(origin$status_doubtful, origin$occurrence_doubtful, origin$extinct)){
      Out <- "status or occurrence doubtful or species extinct"
    }
    if(is.null(Out)){
      Out <- "species not in Flora Europaea"
    }
  }
  Out
}

is_native(sp, where = "Islas_Baleares", region = "europe")

sp <- c("Lavandula stoechas", "Carpobrotus edulis", "Rhododendron ponticum",
        "Alkanna lutea", "Anchusa arvensis")

sapply(sp, is_native, where = "Islas_Baleares", region = "europe")

sp <- c("Lavandula stoechas", "Carpobrotus edulis", "Rhododendron ponticum",
        "Alkanna lutea", "Anchusa arvensis")

sapply(sp, is_native, where = "Continental US", region = "america")


#note: so many more things can be done, like checkingspecies first with taxize,

#To resume:

#itis_native give info for Alaska Canada, Caribbean Territories, Central Pacific Territories,
#Continental US, Hawaii, Mexico. Aparently for most taxa.

#USDA plants has info for US plants at the state level. Data need to be stored somewhere

#col_search can be modified to give info on some plants, but hard to parse the data,
 #plus plants are random subsample, as far as i can tell. Only those from WOrls plants database.

#Kew flora europaea is srapable and contain distribution and "nativity" for plants in EU

#Fauna europaea has no scrapable interface. Links there to Marine, etc... services.


