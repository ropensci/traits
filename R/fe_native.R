#' Check species status (native, exotic, ...) for one species from Flora Europaea webpage
#'
#' @importFrom XML xmlValue getNodeSet htmlTreeParse
#' @export
#'
#' @param sp character; a vector of length one with a single scientific species names in the form of
#'    c("Genus species").
#' @return A list of vectors containing the countries where the species is native, exotic, ...
#'
#' @description This function check the status (native or exotic) of a species in each of the eu countries.
#'
#' For that end, it checks Flora Europaea (http://rbg-web2.rbge.org.uk/FE/fe.html) and scrps the data from there.
#'
#' Note that the webpage contains more information.
#'
#' As expected, the function is as good as the database is. I think for native species is robust but
#' new exotic species are not added as to my knowledge the database is not updated anymore.
#' The database is not able to recognize species
#' synonyms.
#'
#' See http://rbg-web2.rbge.org.uk/FE/data/countries for explanation of the database codes.
#'
#' @author Ignasi Bartomeus \email{nacho.bartomeus@@gmail.com}
#' @examples \donttest{
#' sp <- c("Lavandula stoechas", "Carpobrotus edulis", "Rhododendron ponticum",
#'        "Alkanna lutea", "Anchusa arvensis")
#' fe_native(sp[1])
#' sapply(sp, fe_native, simplify = FALSE)
#' }
#'

fe_native <- function(sp){
  #add country short-names translation cheat sheet as dataframe
  country <- data.frame(short = c("Al", "Au", "Az", "Be", "Bl", "Br", "Bu", "Co", "Cr", "Cz",
                                  "Da", "Fa", "Fe", "Ga", "Ge", "Gr", "Hb",
                                  "He", "Ho", "Hs", "Hu", "Is", "It", "Ju",
                                  "Lu", "No", "Po", "Rm", "Rs", "Sa","Sb",
                                  "Si", "Su", "Tu", "N", "B", "C",
                                  "W", "K", "E"),
                        long = c("Albania", "Austria", "Azores", "Belgium", "Islas_Baleares",
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
                                 "USSRSouth_eastern_Division"))
  require(plyr)
  require(XML)
  require(RCurl)
  #reformat sp list
  genus <- strsplit(sp, " ")[[1]][1]
  species <- strsplit(sp, " ")[[1]][2]
  #create urls to parse
  urls <- paste("http://rbg-web2.rbge.org.uk/cgi-bin/nph-readbtree.pl/feout?FAMILY_XREF=&GENUS_XREF=",
                  genus, "&SPECIES_XREF=", species, "&TAXON_NAME_XREF=&RANK=",
                  sep = "")
  print(paste("Checking species", sp))
  #Parse url and extract table
  #readHTMLTable(urls) #Not working, don't know why.
  doc <- htmlTreeParse(urls, useInternalNodes = TRUE)
  tables <- getNodeSet(doc, "//table")
  if(length(tables) < 3){
    print("Species not found")
  } else {
    #t <- readHTMLTable(tables[[3]]) #Not working either
    #try alternative
    text <- xmlValue(tables[[3]], trim = FALSE) # I am assuming 3 is always right, so far it is.
    m_nat <- regexpr("Distribution: [A-Za-z ()?*%,]*", text, perl = TRUE)
    distr_nat <- regmatches(text, m_nat)
    distr_status <- regmatches(distr_nat,
                                 gregexpr("[*][A-Z][a-z]", distr_nat, perl = TRUE)) # * Status doubtful; possibly native
    distr_occ <- regmatches(distr_nat,
                               gregexpr("[?][A-Z][a-z]", distr_nat, perl = TRUE)) # ? Occurrence doubtful
    distr_ext <- regmatches(distr_nat,
                               gregexpr("[%][A-Z][a-z]", distr_nat, perl = TRUE)) # % Extinct
    #also deal with Rs(N) extract e.g. Rs(N,B,C,W,K,E)
    distr_nat <- gsub(",", " ", distr_nat)
    distr_nat <- gsub("(", " ", distr_nat, fixed = TRUE)
    distr_nat <- gsub(")", "", distr_nat, fixed = TRUE)
    distr_nat <- gsub("Distribution: ", "", distr_nat)
    if(distr_nat != ""){
      native <- strsplit(distr_nat, " ")[[1]]
      delete <- which(!native %in% country$short)
      if(length(delete) > 0) native <- native[-delete]
      nat <- sapply(native, function(x){country[which(x == country$short), "long"]})
    } else { nat = NA }
    if(length(distr_status[[1]]) > 0){
      status <- gsub("*", "", distr_status[[1]], fixed = TRUE)
      stat <- sapply(status, function(x){country[which(x == country$short), "long"]})
    } else { stat = NA }
    if(length(distr_occ[[1]]) > 0){
      occ <- gsub("?", "", distr_occ[[1]], fixed = TRUE)
      oc <- sapply(occ, function(x){country[which(x == country$short), "long"]})
    } else { oc = NA }
    if(length(distr_ext[[1]]) > 0){
      ext <- gsub("%", "", distr_ext[[1]], fixed = TRUE)
      ex <- sapply(ext, function(x){country[which(x == country$short), "long"]})
    } else { ex = NA }
    #extract exotics
    m_ex <- regexpr("[[][A-Za-z ()?*%,]*", text, perl = TRUE)
    distr_exot <- regmatches(text, m_ex)
    if(length(distr_exot) > 0){
      #NEED TO ADD * ? % for exotics? I don't think those cases exist. Maybe ?
      exotic <- strsplit(gsub("[", "", distr_exot, fixed = TRUE), " ")[[1]]
      exo <- sapply(exotic, function(x){country[which(x == country$short), "long"]})
    } else { exo = NA }
    Out <- list(native = as.character(nat), exotic = as.character(exo), status_doubtful = as.character(stat),
                occurrence_doubtful = as.character(oc), extinct = as.character(ex))
    Out
  }
}
