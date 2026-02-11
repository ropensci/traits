#' Search for traits by taxa names
#'
#' @export
#' @param x (character) Taxonomic name(s) to search for
#' @param db (character) only 'ncbi' for now - other options
#' maybe in the future
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @return A \code{data.frame}
#' @author Scott Chamberlain
#' @examples \donttest{
#' taxa_search("Poa annua", db = "ncbi")
#' }
taxa_search <- function(x, db, ...) {
  UseMethod("taxa_search")
}

#' @export
taxa_search.default <- function(x, db, ...) {
  stop("taxa_search has no method for ", class(x), call. = FALSE)
}

#' @export
taxa_search.character <- function(x, db, ...) {
  if (!db %in% c('traitbank', 'ncbi')) {
    stop("'db' must be one of 'traitbank' or 'ncbi'", call. = FALSE)
  }
  switch(db,
    traitbank = {
      stop("traitbank not working for now; see ?traits::traitbank")
      # id <- get_tb(x)
      # traitbank(pageid = id, ...)
    },
    ncbi = {
      ncbi_searcher(taxa = x, ...)
    }
    # birdlife = {
    #   id <- get_blife(x)
    #   birdlife_habitat(id)
    # }
  )
}

# taxa_search.list <- function(x, db, ...) { ... }

# method for data.frame/matrix input, where trait data given back as data.frame,
# one row for each taxon, ideally
# taxa_search.data.frame <- function(x, db, ...) { ... }

get_tb <- function(x, row = NULL, ...) {
  tmp <- taxize::eol_search(terms = x)
  if (NROW(tmp) > 1) {
    selector(tmp, x, get_from = "pageid", row = row)
  } else {
    tmp$pageid
  }
}

get_blife <- function(z) {
  taxize::iucn_id(z)
}

selector <- function(z, name, get_from, row = NULL) {
  if (!is.null(row)) {
    # Use specified row for non-interactive or automated use
    if (!row %in% seq_len(nrow(z))) {
      message("Row ", row, " not valid. Must be between 1 and ", nrow(z), ".")
      return(NA_character_)
    }
    ids <- unlist(z[get_from], use.names = FALSE)
    message("Using row ", row, ", id '", as.character(ids[row]), "'.")
    return(as.character(ids[row]))
  }
  
  if (!interactive()) {
    message("Non-interactive session; multiple matches found. Use the 'row' parameter to specify which match to use, otherwise NA will be returned.")
    return(NA_character_)
  }
  
  message("\n\nMore than one result found for '", name, "'!\n
            Enter rownumber of taxon (other inputs will return 'NA'):\n")
  rownames(z) <- 1:nrow(z)
  print(z)
  take <- scan(n = 1, quiet = TRUE, what = 'raw')

  if (length(take) == 0) {
    message("Exiting, no match")
  }

  if (take %in% seq_len(nrow(z))) {
    take <- as.numeric(take)
    ids <- unlist(z[get_from], use.names = FALSE)
    message("Input accepted, took id '", as.character(ids[take]), "'.\n")
    as.character(ids[take])
  } else {
    message("Exiting, no match")
  }
}
