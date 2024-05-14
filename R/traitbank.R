#' Search for traits from EOL's Traitbank
#'
#' @export
#' @param query (character) a query to the EOL Cypher service that holds
#' Traitbank data. required. no default query given. see examples
#' @param key (character) EOL Cypher query API key. required, either
#' passed in or as an environment variable
#' @param ... Curl options passed on to \code{\link[crul]{verb-GET}}
#' @references https://github.com/EOL/eol_website/blob/master/doc/api.md
#' https://github.com/EOL/eol_website/blob/master/doc/query-examples.md
#' @details \code{traitbank} is an interface to the EOL Cypher query.
#' Note that the previous interface EOL had for Traits has been completely
#' replaced - thus, this function is completely different. You no longer
#' query by EOL page id, but using the query language for a database
#' called Neo4J. See the docs for help. Later we plan to make a more
#' user friendly interface to get Traitbank data that doesn't
#' require knowing the Neo4J query syntax
#' @section Authentication:
#' You'll need an EOL cypher key to use this function. Steps:
#' 1. Sign in to (register if necessary) your EOL account https://eol.org/users/sign_in. 
#' 2. Send an email to the EOL administrator (hammockj AT si.edu) with your username
#' and request that they make you a "power user".
#' 3. Get your key by visiting https://eol.org/services/authenticate
#' 4. Store your key in your .Renviron file or similar under the name "EOL_CYPHER_KEY"
#'     Hint: To do this, you can create or edit this file in your home directory, or 
#' use the shortcut `usethis::edit_r_environ()` and add a line like `EOL_CYPHER_KEY="your_key_here"`
#' 5. (not recommended alternative): you can pass your key to the key parameter, but we do not recommend
#' doing that as you risk accidentally committing your key to the public web.
#' @return a list
#' @examples \dontrun{
#' # traitbank_query function
#' traitbank(query = "MATCH (n:Trait) RETURN n LIMIT 1;")
#'
#' # traitbank function
#' res <- traitbank(query = "MATCH (n:Trait) RETURN n LIMIT 2;")
#' res
#' }
traitbank <- function(query, key = NULL, ...) {
  assert(query, "character")
  assert(key, "character")
  if (is.null(key)) key <- Sys.getenv("EOL_CYPHER_KEY", "")
  if (!nzchar(key)) stop("
  no EOL Cypher key found
    see the traitbank function help under Authentication
      help('traitbank') 
    for instructions on obtaining and storing the EOL Cypher Key")
  x = crul::HttpClient$new(
      url = "https://eol.org",
      headers = list(Authorization = paste0("JWT ", key)),
      opts = list(...)
  )
  res <- x$get("service/cypher", query = list(query = query))
  res$raise_for_status()
  jsonlite::fromJSON(res$parse("UTF-8"), TRUE)
}
