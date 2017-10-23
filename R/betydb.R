#' Search for traits from BETYdb
#'
#' @name betydb
#'
#' @param genus (character) A genus name. Optional
#' @param species (character) A specific epithet. Optional
#' @param id (integer) One or more ids for a species, site, variable, etc.
#' @param betyurl (string) url to target instance of betydb. Default is \code{options("betydb_url")} if set, otherwise "https:/www.betydb.org/"
#' @param fmt (character) Format to return data in, one of json, xml, csv. Only json
#' currently supported.
#' @param api_version (character) Which version of the BETY API should we query? One of "v0" or "beta". Default is \code{options("betydb_api_version")} if set, otherwise  "v0".
#' @param key (character) An API key. Use this or user/pwd combo. Save in your
#' \code{.Rprofile} file as \code{options(betydb_key = "your40digitkey")}. Optional
#' @param user,pwd (character) A user name and password. Use a user/pwd combo or an API key.
#' Save in your \code{.Rprofile} file as \code{options(betydb_user = "yournamehere")} and \code{options(betydb_pwd = "yourpasswordhere")}. Optional
#' @param ... Curl options passed on to \code{\link[httr]{GET}}. Optional
#' @references API documentation \url{https://pecan.gitbooks.io/betydb-data-access/content/API.html} and
#' https://www.betydb.org/api/docs
#' @details
#' BETYdb includes a primary home page (betydb.org) focused on bioenergy crops as well as a network of harmonized
#' databases that support and share data among more focused research programs.
#'
#' For a list of publicly accessible instances of BETYdb and the urls that can be queried,
#' see \url{https://pecan.gitbooks.io/betydb-documentation/content/distributed_betydb.html}
#'
#' This package queries plant traits, phenotypes, biomass yields, and ecosystem functions.
#' It does not currently interface with the workflow and provenance data that support PEcAn Project (pecanproject.org) and TERRA REF (terraref.org) software.
#'
#' API documentation: \url{https://pecan.gitbooks.io/betydb-data-access/content/API.html}
#' API endpoints are here: \url{https://www.betydb.org/api/docs}
#' This package currently uses the original 'v0' API by default.
#' To use a newer version, set `api_version`.
#' Newer versions of the API will support database inserts.
#'
#' @section Authentication:
#' Defers to use API key first since it's simpler, but if you don't have
#' an API key, you can supply a username and password.
#'
#' @section Functions:
#' Singular functions like \code{betydb_trait} accept an id and additional parameters,
#' and return a list of variable outputs depending on the inputs.
#'
#' However, plural functions like \code{betydb_traits} accept query parameters, but not
#' ids, and always return a single data.frame.
#'
#' \code{betydb_search("Search terms", ...)} is a convenience wrapper that passes all further arguments to \code{\link{betydb_query}(table = "search", search = "Search terms", ...)}. See there for details on possible arguments.
#'
#' @seealso \code{\link{betydb_query}}
#'
#' @examples \dontrun{
#' # General Search
#' out <- betydb_search(query = "Switchgrass Yield")
#' library("dplyr")
#' out %>%
#'  group_by(id) %>%
#'  summarise(mean_result = mean(as.numeric(mean), na.rm = TRUE)) %>%
#'  arrange(desc(mean_result))
#' # Get by ID
#' ## Traits
#' betydb_trait(id = 10)
#' ## Species
#' betydb_specie(id = 1)
#' ## Citations
#' betydb_citation(id = 1)
#' ## Site information
#' betydb_site(id = 795)
#' }
NULL

makeurl <- function(table, id = NULL, fmt = "json", api_version = NULL, betyurl = NULL){
  if (is.null(betyurl)) {
    betyurl <- getOption("betydb_url", default = "https://www.betydb.org/")
  }
  if (is.null(api_version)) {
    api_version <- getOption("betydb_api_version", default = "v0")
  }
  api_string <- if (api_version == "v0") { "" } else { paste0("api/", api_version, "/")}
  fmt <- match.arg(fmt, c("json","xml","csv"))
  betyurl = sub("/*$", "/", betyurl)
  if (!is.null(id)){
    return(paste0(betyurl, api_string, table, "/", id, ".", fmt))
  }
  paste0(betyurl, api_string, paste0(table, "."), fmt)
}

# Look up property name (usually singular)
# from a table name (usually plural)
# FIXME: not a very future-proof approach.
# Would be nice if we could query the API itself for these.
makepropname <- function(name, api_version){
  if (is.null(api_version)) {
    api_version <- getOption("betydb_api_version", default = "v0")
  }
  switch(
    name,
    search = "traits_and_yields_view",
    species = if (api_version == "v0"){ "specie" }else{ "species" },
    entities = "entity",
    sub("s$", "", name)
  )
}

#' Query a BETY table
#'
#' @export
#' @param ... (named character) Columns to query, as key="value" pairs. Note that betydb_query passes these along to BETY with no check whether the requested keys exist in the specified table.
#' @param table (character) The name of the database table to query, or "search" (the default) for the traits and yields view
#' @param query (character) A string containing one or more words to be queried across all columns of the "search" table.
#' @param include_unchecked (logical) Include results that have not been quality checked? Applies only to tables with a "checked" column: "search", "traits", "yields". Default is to exclude unchecked values.
#' @param key (character) An API key. Use this or user/pwd combo.
#' Save in your \code{.Rprofile} file as \code{options(betydb_key = "your40digitkey")}. Optional
#' @param api_version (character) Which version of the BETY API should we query? One of "v0" or "beta".
#' Default is \code{options("betydb_api_version")} if set, otherwise  "v0".
#' @param betyurl (string) url to target instance of betydb.
#' Default is \code{options("betydb_url")} if set, otherwise "https:/www.betydb.org/"
#' @param user,pwd (character) A user name and password. Use a user/pwd combo or an API key.
#' Save in your \code{.Rprofile} file as \code{options(betydb_user = "yournamehere")} and \code{options(betydb_pwd = "yourpasswordhere")}. Optional
#'
#' @return A data.frame with attributes containing request metadata, or NULL if the query produced no results
#'
#' @details
#' Use betydb_query to retrieve records from a table that match on all the column filters specified in '...'.
#' If no filters are specified, retrieves the whole table. In API versions that support it (i.e. not in v0), filter strings beginning with "~" are treated as regular expressions.
#'
#' @examples \dontrun{
#' # literal vs regular expression vs anchored regular expression:
#' betydb_query(units = "Mg", table = "variables")
#' # NULL
#' betydb_query(units = "Mg/ha", table = "variables") %>% select(name) %>% c()
#' # $name
#' # [1] "a_biomass"                  "root_live_biomass"
#' # [3] "leaf_dead_biomass_in_Mg_ha" "SDM"
#'
#' betydb_query(genus = "Miscanthus", table = "species") %>% nrow()
#' # [1] 10
#' (betydb_query(genus = "~misc", table = "species", api_version = "beta")
#'  %>% select(genus)
#'  %>% unique() %>% c())
#' # $genus
#' # [1] "Platymiscium" "Miscanthus"   "Dermiscellum"
#'
#' (betydb_query(genus = "~^misc", table = "species", api_version = "beta")
#'  %>% select(genus)
#'  %>% unique() %>% c())
#' # $genus
#' # [1] "Miscanthus"
#' }
#'
betydb_query <- function(..., table = "search", key = NULL, api_version = NULL, betyurl = NULL, user = NULL, pwd = NULL){

  url <- makeurl(table = table, fmt = "json", api_version = api_version, betyurl = betyurl)
  propname <- makepropname(table, api_version)
  betydb_GET(url, args = list(...), key = key, user = NULL, pwd = NULL, which = propname)
}

#' @export
#' @rdname betydb_query
betydb_search <- function(query = "Maple SLA", ..., include_unchecked = NULL){
  betydb_query(search = query, table = "search", include_unchecked = include_unchecked, ...)
}

betydb_GET <- function(url, args = list(), key = NULL, user = NULL, pwd = NULL, which, ...){

  api_version <- options()$betydb_api_version
  # api_version <- ifelse(grepl('/beta/api', url), 'beta', 'v0')
  if(!exists('per_call_limit')) {
    per_call_limit <- 5000
  }

  if(is.null(api_version)){
    api_version <- options()$betydb_api_version
  }
  if(api_version == 'v0'){
    txt <- betydb_http(url, args, key, user, pwd, ...)
    lst <- jsonlite::fromJSON(txt, simplifyVector = TRUE, flatten = TRUE)
  } else if (api_version == 'beta'){

    if(is.null(args$limit)) {
      args$limit <- 200
    } else if (args$limit == 'none'){
      args$limit <- 10^9
    } else if(!is.na(as.numeric(args$limit))){
      args$limit <- as.numeric(args$limit)
    } else {
      stop('invalid value given for limit', ifelse(is.null(args$limit), "NULL", args$limit),
           "\nlimit must be a positive integer or 'none'")
    }

    if(args$limit <= per_call_limit){
      txt <- betydb_http(url, args, key, user, pwd, ...)
      lst <- jsonlite::fromJSON(txt, simplifyVector = TRUE, flatten = TRUE)
    } else if (args$limit > per_call_limit){ # divide large requests (aka page)
      # clear limit arg and return total records
      oldlimit <- args$limit
      args$limit <- NULL
      txt <- betydb_http(url, args, key, user, pwd, ...)
      lst <- jsonlite::fromJSON(txt, simplifyVector = TRUE, flatten = TRUE)
      if(lst$metadata$count == 0){
        lst$warnings <- append(lst$warnings, paste("0 records available for query with url\n",
                             lst$metadata$URI))
        nrecords <- 0
      } else if (lst$metadata$count > 0){
        if(is.null(lst$warnings)){
          lst$warnings <- ''
          nrecords <- lst$metadata$count
        } else {
          nrecords <- as.numeric(gsub("The ", "", strsplit(lst$warnings, '-')[[1]][1]))
          lst$warnings <- gsub("The [1-9][0-9]*-row result set exceeds the default 200 row limit.  Showing the first 200 results only.  Set an explicit limit to show more results.",
                               "", lst$warnings)
        }

      }

      # configure paging args
      newlimit <- ifelse(oldlimit == 1e+09, nrecords, min(oldlimit, nrecords))
      if(nrecords > oldlimit){
        lst$warnings <- paste(lst$warnings,
          paste("returning ", oldlimit, "records out of", nrecords, "total"))
      }

      lst_notdata <- lst[-which(names(lst) == "data")]
      lst_notdata[['metadata']][['total']] <- nrecords
      lst_notdata[['metadata']][['count']] <- newlimit

      ## tests set per_call_limit globally to save time
      remainder <- newlimit %% per_call_limit
      iterations <- (newlimit - remainder) / per_call_limit
      args$limit <- per_call_limit
      lst_data <- list()

      # paging loop
      if(iterations > 2) { # Progress Bar
        pb   <- txtProgressBar(1, iterations, style=3)
      }
      if(iterations > 0){
        for(i in 1:iterations){
          if(i > 1){
            args$offset <- (i - 1) * per_call_limit
          }

          txt <- betydb_http(url, args, key, user, pwd, ...)
          lst <- jsonlite::fromJSON(txt, simplifyVector = TRUE, flatten = TRUE)
          lst_data[[i]] <- lst$data
          if(i > 2) {
            setTxtProgressBar(pb, i)
          }

        }
      }
      if(remainder > 0){
        if(iterations > 0){
          args$offset <- iterations * per_call_limit
        }

        args$limit <- remainder ## limit currently isn't working
        txt <- betydb_http(url, args, key, user, pwd, ...)
        lst <- jsonlite::fromJSON(txt, simplifyVector = TRUE, flatten = TRUE)
        lst_data[[iterations + 1]] <- lst$data
      }

      lst <- append(list(data = dplyr::bind_rows(lst_data)),
                    lst_notdata)

    } else {
      lst <- list(warnings = paste('\n limit argument', args$limit, "not recognized; please use integer value to specify maximum number of records to return, 'none' to specify no limit and return all records, or NULL (default) to return the first 200 records"), metadata = list(url = url, args = args))
    } # end api beta paging conditionals
  }

  if ("warnings" %in% names(lst)) {
    message(lst$warnings)
  }
  if ("errors" %in% names(lst)) {
    # TODO: Can we ever get here?
    # if lst$error always comes with a 4xx status, will be caught inside betydb_http().
    stop(lst$errors)
  }
  if ("metadata" %in% names(lst)) { # true iff API > v0
    md <- lst$metadata
    lst <- lst$data
  }
  if (length(lst) == 0) { # no results
      return(NULL)
  }
  if (length(lst) == 1 && names(lst) == which) { # detail view; return a list not a df
    res <- Filter(function(x) !is.null(x), lst[[1]])
    names(res) <- tolower(names(res))
  } else {
    res <- stats::setNames(tibble::as_tibble(lst), gsub(sprintf("%s\\.", which), "", tolower(names(lst))))
  }
  if (exists("md") && !is.null(md)) { attr(res, "metadata") <- md }
  res
}

betydb_http <- function(url, args = list(), key = NULL, user = NULL, pwd = NULL, ...){
  auth <- betydb_auth(user, pwd, key)

  if (!grepl("/api/", url, fixed = TRUE)) {
    # no API string means we're using the v0 API and must insert cross-table joins to allow searching.
    # TODO: Remove this block when expiring v0 support.
    includes <- list(`include[]=` = ifelse(any(grepl('species', names(args))), "specie", ''),
         `include[]=` = ifelse(any(grepl('variables', names(args))), 'variable', ''),
         `include[]=` = ifelse(any(grepl('authors', names(args))), 'author', ''))
    includes[which(includes == "")] <- NULL
    args <- append(args, includes)
  }
  res <- if (is.null(auth$key)) {
    GET(url, query = args, authenticate(auth$user, auth$pwd), ...)
  } else {
    GET(url, query = c(key = auth$key, args), ...)
  }
  stop_for_status(res)
  ans <- content(res, "text", encoding = "UTF-8")
  return(ans)
}

#################### by ID

#' Get details about a single item from a table
#' @export
#' @rdname betydb
#' @param table (character) Name of the database table with which this ID is associated.
betydb_record <- function(id, table, api_version = NULL, betyurl = NULL, fmt = NULL, key = NULL, user = NULL, pwd = NULL, ...){
  args = list(...)
  betydb_GET(makeurl(table, id, fmt, api_version, betyurl), args, which = makepropname(table, api_version))
}

#' @export
#' @rdname betydb
betydb_trait <- function(id, genus = NULL, species = NULL, api_version = NULL, betyurl = NULL, fmt = "json", key = NULL, user = NULL, pwd = NULL, ...){
  args <- traitsc(list(species.genus = genus, species.species = species))
  betydb_GET(makeurl("variables", id, fmt, api_version, betyurl), args, key, user, pwd, "variable", ...)
}

#' @export
#' @rdname betydb
betydb_specie <- function(id, genus = NULL, species = NULL, api_version = NULL, betyurl = NULL, fmt = "json", key = NULL, user = NULL, pwd = NULL, ...){
  args <- traitsc(list(genus = genus, species = species))
  betydb_GET(makeurl("species", id, fmt, api_version, betyurl), args, key, user, pwd, "specie", ...)
}

#' @export
#' @rdname betydb
betydb_citation <- function(id, genus = NULL, species = NULL, api_version = NULL, betyurl = NULL, fmt = "json", key = NULL, user = NULL, pwd = NULL, ...){
  args <- traitsc(list(genus = genus, species = species))
  betydb_GET(makeurl("citations", id, fmt, api_version, betyurl), args, key, user, pwd, "citation", ...)
}

#' @export
#' @rdname betydb
betydb_site <- function(id, api_version = NULL, betyurl = NULL, fmt = "json", key = NULL, user = NULL, pwd = NULL, ...){
  betydb_GET(makeurl("sites", id, fmt, api_version, betyurl), args = NULL, key, user, pwd, "site", ...)
}

#' @export
#' @rdname betydb
betydb_experiment <- function(id, api_version = NULL, betyurl = NULL, fmt = "json", key = NULL, user = NULL, pwd = NULL, ...){
  betydb_GET(makeurl("experiments", id, fmt, api_version, betyurl), args = NULL, key, user, pwd, "experiment", ...)
}

betydb_auth <- function(user,pwd,key){
  if (is.null(key) && is.null(user)) {
    key <- getOption("betydb_key", NULL)
  }
  if (!is.null(key)) {
    auth <- list(key = key)
  } else {
    if (is.null(user)) user <- getOption("betydb_user", NULL)
    if (is.null(pwd)) pwd <- getOption("betydb_pwd", NULL)
    if (xor(is.null(user), is.null(pwd))) stop(warn, call. = FALSE)
    auth <- list(user = user, pwd = pwd, key = NULL)
  }

  if (is.null(c(auth$key, auth$user, auth$pwd))) {
    # If no auth of any kind provided, use the ropensci-traits API key.
    # TODO: Are there implementations that accept password but not key? If so:
    # auth <- list(user <- 'ropensci-traits', pwd <- 'ropensci', key = NULL)
    auth$key = "eI6TMmBl3IAb7v4ToWYzR0nZYY07shLiCikvT6Lv"
  }
  auth
}

warn <- "Supply either api key, or user name/password combo"


# functions that dont work ------------------------------
## betydb_traits
# betydb_traits <- function(genus = NULL, species = NULL, trait = NULL, author = NULL, fmt = "json", key = NULL, user = NULL, pwd = NULL, ...){
#   args <- traitsc(list(species.genus = genus, species.species = species, variables.name = trait))
#   url <- makeurl("traits", fmt)
#   betydb_GET(url = url, args, key, user, pwd, "trait", ...)
# }

## betydb_yield
# betydb_yield <- function(id, genus = NULL, species = NULL, fmt = "json", key = NULL, user = NULL, pwd = NULL, ...){
#   args <- traitsc(list(genus = genus, species = species))
#   betydb_GET2(makeurl("yields", id, fmt), args, key, user, pwd, "yield", ...)
# }
