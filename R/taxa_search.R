#' Search for traits by taxa names
#'
#' @export
#' @param x (character) Taxonomic name(s) to search for
#' @param db (character) One of betydb, traitbank, ncbi, coral.
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @return A \code{data.frame}
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples \dontrun{
#' taxa_search("Poa annua", db = "traitbank")
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
      id <- get_tb(x)
      traitbank(pageid = id, ...)
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

get_tb <- function(x, ...) {
  tmp <- taxize::eol_search(terms = x)
  if (NROW(tmp) > 1) {
    selector(tmp, x, get_from = "pageid")
  } else {
    tmp$pageid
  }
}

get_blife <- function(z) {
  taxize::iucn_id(z)
}

selector <- function(z, name, get_from) {
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
