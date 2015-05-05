name = "Carpobrotus edulis"
x = name
y = id
col_search2 <- function (name = NULL, id = NULL, start = NULL, checklist = NULL) 
{
  url <- "http://www.catalogueoflife.org/col/webservice"
  func <- function(x, y) {
    if (is.null(checklist)) {
      NULL
    }
    else {
      cc <- match.arg(checklist, choices = c(2012, 2011, 
                                             2010, 2009, 2008, 2007))
      if (cc %in% c(2012, 2011, 2010)) {
        url <- gsub("col", paste("annual-checklist/", 
                                 cc, sep = ""), url)
      }
      else {
        url <- "http://webservice.catalogueoflife.org/annual-checklist/year/search.php"
        url <- gsub("year", cc, url)
      }
    }
    #edit args
    #args <- compact(list(name = x, id = y, start = start))
    args <- compact(list(name = x, id = y, start = start, response="full"))
    out <- getForm(url, .params = args)
    tt <- xmlParse(out)
    #add distribution
    toget <- c("id", "name", "rank", "name_status", "distribution")
    nodes <- getNodeSet(tt, "//result", fun = xmlToList)
    ldply(nodes, parsecoldata)
  }
  safe_func <- plyr::failwith(NULL, func)
  if (is.null(id)) {
    temp <- lapply(name, safe_func, y = NULL)
    names(temp) <- name
  }
  else {
    temp <- lapply(id, safe_func, x = NULL)
    names(temp) <- id
  }
  return(temp)
}

parsecoldata <- function(x){
  vals <- x[c('id','name','rank','name_status','source_database', "distribution")]
  vals[sapply(vals, is.null)] <- NA
  names(vals) <- c('id','name','rank','name_status','source_database', 'distribution')
  bb <- data.frame(vals, stringsAsFactors=FALSE)
  names(bb)[4:5] <- c('status','source')
  acc <- x$accepted_name
  if(is.null(acc)){
    accdf <- data.frame(acc_id=NA, acc_name=NA, acc_rank=NA, acc_status=NA, acc_source=NA, stringsAsFactors = FALSE)
  } else
  {
    accdf <- data.frame(acc[c('id','name','rank','name_status','source_database')], stringsAsFactors=FALSE)
    names(accdf) <- c('acc_id','acc_name','acc_rank','acc_status','acc_source')
  }
  cbind(bb, accdf)
}

library(taxize)
library(RCurl)
library(XML)
library(plyr)
col_search2("Carpobrotus edulis")

