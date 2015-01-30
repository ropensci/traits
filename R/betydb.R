#' Search for traits from BettyDB
#'
#' @importFrom dplyr tbl_df
#' @name bety
#'
#' @param genus (character) A genus name. Optional
#' @param species (character) A specific epithet. Optional
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
#' Singular functions like \code{bety_trait} accept an id and additional parameters,
#' and return a list of variable outputs depending on the inputs.
#'
#' However, plural functions like \code{bety_traits} accept query parameters, but not
#' ids, and always return a single data.frame.
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples \dontrun{
#' # Search with parameters
#' ## Traits
#' (out <- bety_traits(genus = 'Miscanthus', species = "giganteus"))
#' library("dplyr")
#' out %>%
#'  group_by(specie_id) %>%
#'  summarise(mean_result = mean(as.numeric(mean), na.rm = TRUE)) %>%
#'  arrange(desc(mean_result))
#'
#' ## Species
#' bety_species(genus = 'Miscanthus')
#'
#' ## Yields
#' bety_yields(genus = 'Miscanthus')
#'
#' ## Citations
#' bety_citations(genus = 'Miscanthus')
#'
#' # Get by ID
#' ## Traits
#' bety_trait(id = 10)
#' ## Species
#' bety_specie(id = 1)
#' ## Citations
#' bety_citation(id = 1)
#' }

#' @export
#' @rdname bety
bety_traits <- function(genus = NULL, species = NULL, fmt = "json", key=NULL, user=NULL, pwd=NULL, ...){
  args <- traitsc(list(genus = genus, species = species))
  betydb_GET(url=makeurl("traits", fmt), args, key, user, pwd, "trait", ...)
}

#' @export
#' @rdname bety
bety_species <- function(genus = NULL, species = NULL, fmt = "json", key=NULL, user=NULL, pwd=NULL, ...){
  args <- traitsc(list(genus = genus, species = species))
  betydb_GET(url=makeurl("species", fmt), args, key, user, pwd, "specie", ...)
}

#' @export
#' @rdname bety
bety_yields <- function(genus = NULL, species = NULL, fmt = "json", key=NULL, user=NULL, pwd=NULL, ...){
  args <- traitsc(list(genus = genus, species = species))
  betydb_GET(url=makeurl("yields", fmt), args, key, user, pwd, "yield", ...)
}

#' @export
#' @rdname bety
bety_citations <- function(genus = NULL, species = NULL, fmt = "json", key=NULL, user=NULL, pwd=NULL, ...){
  args <- traitsc(list(genus = genus, species = species))
  betydb_GET(url=makeurl("citations", fmt), args, key, user, pwd, "citation", ...)
}

#' @export
#' @rdname bety
bety_variables <- function(genus = NULL, species = NULL, fmt = "json", key=NULL, user=NULL, pwd=NULL, ...){
  args <- traitsc(list(genus = genus, species = species))
  betydb_GET(url=makeurl("variables", fmt), args, key, user, pwd, "variable", ...)
}

#################### by ID
#' @export
#' @rdname bety
bety_trait <- function(id, genus = NULL, species = NULL, fmt = "json", key=NULL, user=NULL, pwd=NULL, ...){
  args <- traitsc(list(genus = genus, species = species))
  betydb_GET2(makeidurl("variables", id, fmt), args, key, user, pwd, "variable", ...)
}

#' @export
#' @rdname bety
bety_specie <- function(id, genus = NULL, species = NULL, fmt = "json", key=NULL, user=NULL, pwd=NULL, ...){
  args <- traitsc(list(genus = genus, species = species))
  betydb_GET2(makeidurl("species", id, fmt), args, key, user, pwd, "specie", ...)
}

# by ID
#' @export
#' @rdname bety
bety_yield <- function(id, genus = NULL, species = NULL, fmt = "json", key=NULL, user=NULL, pwd=NULL, ...){
  args <- traitsc(list(genus = genus, species = species))
  betydb_GET2(makeidurl("yields", id, fmt), args, key, user, pwd, "yield", ...)
}

#' @export
#' @rdname bety
bety_citation <- function(id, genus = NULL, species = NULL, fmt = "json", key=NULL, user=NULL, pwd=NULL, ...){
  args <- traitsc(list(genus = genus, species = species))
  betydb_GET2(makeidurl("citations", id, fmt), args, key, user, pwd, "citation", ...)
}

betydb_http <- function(url, args = list(), key, user, pwd, ...){
  auth <- bety_auth(user, pwd, key)
  res <- if(is.null(auth$key)){
    GET(url, query = args, authenticate(auth$user, auth$pwd), ...)
  } else {
    GET(url, query = c(key=auth$key, args), ...)
  }
  stop_for_status(res)
  content(res, "text")
}

betydb_GET <- function(url, args = list(), key, user, pwd, which, ...){
  txt <- betydb_http(url, args, key, user, pwd, ...)
  lst <- jsonlite::fromJSON(txt, TRUE, flatten = TRUE)
  setNames(tbl_df(lst), gsub(sprintf("%s\\.", which), "", names(lst)))
}

betydb_GET2 <- function(url, args = list(), key, user, pwd, which, ...){
  txt <- betydb_http(url, args, key, user, pwd, ...)
  lst <- jsonlite::fromJSON(txt, FALSE)
  lst[[1]]
}

bety_auth <- function(x,y,z){
  if(is.null(z) && is.null(x)){
    z <- getOption("betydb_key", NULL)
  }
  if(!is.null(z)) {
    list(key=z)
  } else {
    if(is.null(x)) x <- getOption("betydb_user", "")
    if(x == "") stop(warn, call. = FALSE)
    if(is.null(y)) y <- getOption("betydb_pwd", "")
    if(y == "") stop(warn, call. = FALSE)
    list(user=x, pwd=y, key=NULL)
  }
}

makeurl <- function(x, fmt){
  fmt <- match.arg(fmt, c("json","xml","csv"))
  paste0(betyurl(), paste0(x, "."), fmt)
}

makeidurl <- function(x, id, fmt){
  fmt <- match.arg(fmt, c("json","xml","csv"))
  sprintf("%s%s/%s.%s", betyurl(), x, id, fmt)
}

warn <- "Supply either api key, or user name/password combo"
betyurl <- function() 'https://www.betydb.org/'
