#' Search for traits from BETYdb
#'
#' @name betydb
#'
#' @param query Query terms
#' @param genus (character) A genus name. Optional
#' @param species (character) A specific epithet. Optional
#' @param id (integer) One or more ids for a species, site, variable, etc.
#' @param fmt (character) Format to return data in, one of json, xml, csv. Only json
#' currently supported.
#' @param key (character) An API key. Use this or user/pwd combo. Save in your
#' \code{.Rprofile} file as \code{betydb_key}. Optional
#' @param user,pwd (character) A user name and password. Use a user/pwd combo or an API key.
#' Save in your \code{.Rprofile} file as \code{betydb_user} and \code{betydb_pwd}. Optional
#' @param ... Curl options passed on to \code{\link[httr]{GET}}. Optional
#' @references API documentation \url{https://www.authorea.com/users/5574/articles/7062}
#' @details Details:
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

#' @export
#' @rdname betydb
betydb_search <- function(query = "Maple SLA", fmt = 'json', key = NULL, user = NULL, pwd = NULL, ...){
  base.url <- makeurl("search", fmt)
  result <- betydb_GET(url = base.url, args = list(search = query), key, user, pwd, which = "traits_and_yields_view", ...)
  return(result)
}

makeurl <- function(x, fmt, include = NULL){
  fmt <- match.arg(fmt, c("json","xml","csv"))
  url <- paste0(betyurl(), paste0(x, "."), fmt)
  return(url)
}


betydb_GET <- function(url, args = list(), key, user, pwd, which, ...){
  if (is.null(c(key, user, pwd))) {
    user <- 'ropensci-traits'
    pwd <- 'ropensci'
  }

  txt <- betydb_http(url, args, key, user, pwd, ...)
  if (txt == "[]") {
      result <- NULL
  } else {
      lst <- jsonlite::fromJSON(txt, simplifyVector = TRUE, flatten = TRUE)
      result <- setNames(tbl_df(lst), gsub(sprintf("%s\\.", which), "", tolower(names(lst))))
  }
  return(result)
}

betydb_http <- function(url, args = list(), key, user, pwd, ...){
  auth <- betydb_auth(user, pwd, key)

  includes <- list(`include[]=` = ifelse(any(grepl('species', names(args))), "specie", ''),
       `include[]=` = ifelse(any(grepl('variables', names(args))), 'variable', ''),
       `include[]=` = ifelse(any(grepl('authors', names(args))), 'author', ''))

  includes[which(includes == "")] <- NULL
  args <- append(args, includes)
  res <- if (is.null(auth$key)) {
    res <- GET(url, query = args, authenticate(auth$user, auth$pwd), ...)
  } else {
    GET(url, query = c(key = auth$key, args), ...)
  }
  stop_for_status(res)
  ans <- content(res, "text", encoding = "UTF-8")
  return(ans)
}

#################### by ID
#' @export
#' @rdname betydb
betydb_trait <- function(id, genus = NULL, species = NULL, fmt = "json", key=NULL, user=NULL, pwd=NULL, ...){
  args <- traitsc(list(species.genus = genus, species.species = species))
  betydb_GET2(makeidurl("variables", id, fmt), args, key, user, pwd, "variable", ...)
}

#' @export
#' @rdname betydb
betydb_specie <- function(id, genus = NULL, species = NULL, fmt = "json", key=NULL, user=NULL, pwd=NULL, ...){
  args <- traitsc(list(genus = genus, species = species))
  betydb_GET2(makeidurl("species", id, fmt), args, key, user, pwd, "specie", ...)
}

#' @export
#' @rdname betydb
betydb_citation <- function(id, genus = NULL, species = NULL, fmt = "json", key=NULL, user=NULL, pwd=NULL, ...){
  args <- traitsc(list(genus = genus, species = species))
  betydb_GET2(makeidurl("citations", id, fmt), args, key, user, pwd, "citation", ...)
}

#' @export
#' @rdname betydb
betydb_site <- function(id, fmt = "json", key=NULL, user=NULL, pwd=NULL, ...){
  betydb_GET2(makeidurl("sites", id, fmt), args = NULL, key, user, pwd, "site", ...)
}

## can betydb_GET2 be merged with betydb_GET?
betydb_GET2 <- function(url, args = list(), key, user, pwd, which, ...){
  if (is.null(c(key, user, pwd))) {
    user <- 'ropensci-traits'
    pwd <- 'ropensci'
  }
  txt <- betydb_http(url, args, key, user, pwd, ...)
  lst <- jsonlite::fromJSON(txt, FALSE)
  x <- lst[[1]]
  low_names(df_null(x))
}

betydb_auth <- function(x,y,z){
  if (is.null(z) && is.null(x)) {
    z <- getOption("betydb_key", NULL)
  }
  if (!is.null(z)) {
    list(key = z)
  } else {
    if (is.null(x)) x <- getOption("betydb_user", "")
    if (x == "") stop(warn, call. = FALSE)
    if (is.null(y)) y <- getOption("betydb_pwd", "")
    if (y == "") stop(warn, call. = FALSE)
    list(user = x, pwd = y, key = NULL)
  }
}


makeidurl <- function(x, id, fmt){
  fmt <- match.arg(fmt, c("json","xml","csv"))
  sprintf("%s%s/%s.%s", betyurl(), x, id, fmt)
}

warn <- "Supply either api key, or user name/password combo"
betyurl <- function() 'https://www.betydb.org/'


# functions that dont work ------------------------------
## betydb_traits
# betydb_traits <- function(genus = NULL, species = NULL, trait = NULL, author = NULL, fmt = "json", key=NULL, user=NULL, pwd=NULL, ...){
#   args <- traitsc(list(species.genus = genus, species.species = species, variables.name = trait))
#   url <- makeurl("traits", fmt)
#   betydb_GET(url = url, args, key, user, pwd, "trait", ...)
# }

## betydb_yield
# betydb_yield <- function(id, genus = NULL, species = NULL, fmt = "json", key=NULL, user=NULL, pwd=NULL, ...){
#   args <- traitsc(list(genus = genus, species = species))
#   betydb_GET2(makeidurl("yields", id, fmt), args, key, user, pwd, "yield", ...)
# }
