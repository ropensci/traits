#' Search for gene sequences available for taxa from NCBI.
#'
#' @export
#' @template ncbi
#' @importFrom taxize get_uid classification
#' @importFrom XML xpathApply xpathSApply xmlGetAttr
#' @param id (\code{character}) Taxonomic id to search for. Not compatible with argument \code{taxa}.
#' @param limit (\code{numeric}) Number of sequences to search for and return. Max of 10,000.
#'    If you search for 6000 records, and only 5000 are found, you will of course
#'    only get 5000 back.
#' @param entrez_query (\code{character}; length 1) An Entrez-format query to filter results with.
#'   This is useful to search for sequences with specific characteristics. The format is the same
#'   as the one used to seach genbank.
#'   (\url{http://www.ncbi.nlm.nih.gov/books/NBK3837/#EntrezHelp.Entrez_Searching_Options})
#' @param hypothetical (\code{logical}; length 1) If \code{FALSE}, an attempt will be made to not
#'   return hypothetical or predicted sequences judging from accession number prefixs (XM and XR).
#'   This can result in less than the \code{limit} being returned even if there are more sequences
#'   available, since this filtering is done after searching NCBI.
#' @return \code{data.frame} of results if a single input is given. A list of \code{data.frame}s if
#'   multiple inputs are given.
#' @seealso \code{\link[taxize]{ncbi_getbyid}}, \code{\link[taxize]{ncbi_getbyname}}
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}, Zachary Foster
#'   \email{zacharyfoster1989@@gmail.com}
#' @examples \donttest{
#' # A single species
#' out <- ncbi_searcher(taxa="Umbra limi", seqrange = "1:2000")
#' # Get the same species information using a taxonomy id
#' out <- ncbi_searcher(id = "75935", seqrange = "1:2000")
#' # If the taxon name is unique, using the taxon name and id are equivalent
#' all(ncbi_searcher(id = "75935") ==  ncbi_searcher(taxa="Umbra limi"))
#' # If the taxon name is not unique, use taxon id
#' #  "266948" is the uid for the butterfly genus, but there is also a genus of orchids with the
#' #  same name
#' nrow(ncbi_searcher(id = "266948")) ==  nrow(ncbi_searcher(taxa="Satyrium"))
#' # get list of genes available, removing non-unique
#' unique(out$gene_desc)
#' # does the string 'RAG1' exist in any of the gene names
#' out[grep("RAG1", out$gene_desc, ignore.case=TRUE),]
#'
#' # A single species without records in NCBI
#' out <- ncbi_searcher(taxa="Sequoia wellingtonia", seqrange="1:2000", getrelated=TRUE)
#'
#' # Many species, can run in parallel or not using plyr
#' species <- c("Salvelinus alpinus","Ictalurus nebulosus","Carassius auratus")
#' out2 <- ncbi_searcher(taxa=species, seqrange = "1:2000")
#' lapply(out2, head)
#' library("plyr")
#' out2df <- ldply(out2) # make data.frame of all
#' unique(out2df$gene_desc) # get list of genes available, removing non-unique
#' out2df[grep("12S", out2df$gene_desc, ignore.case=TRUE), ]
#'
#' # Using the getrelated and entrez_query options
#' ncbi_searcher(taxa = "Olpidiopsidales", limit = 5, getrelated = TRUE,
#'             entrez_query = "18S[title] AND 28S[title]")
#' }
ncbi_searcher <- function(taxa = NULL, id = NULL, seqrange="1:3000", getrelated=FALSE, limit = 500,
                          entrez_query = NULL, hypothetical = FALSE, verbose=TRUE) {

  # Argument validation ----------------------------------------------------------------------------
  if (sum(c(is.null(taxa), is.null(id))) != 1) {
    stop("Either taxa or id must be specified, but not both")
  }

  # Convert 'taxa' to 'id' if 'taxa' is supplied ---------------------------------------------------
  if (is.null(id)) {
    id <- get_uid(taxa, verbose = verbose)
    names(id) <- taxa
  } else {
    id <- as.character(id)
    class(id) <- "uid"
    names(id) <- id
  }

  # look up sequences for taxa ids -----------------------------------------------------------------
  if (length(id) == 1) {
    ncbi_searcher_foo(id, getrelated = getrelated, verbose = verbose,
                      seqrange = seqrange, entrez_query = entrez_query,
                      limit = limit, hypothetical = hypothetical)
  } else {
    lapply(id, ncbi_searcher_foo, getrelated = getrelated, verbose = verbose,
           seqrange = seqrange, entrez_query = entrez_query, limit = limit,
           hypothetical = hypothetical)
  }
}

# Constants --------------------------------------------------------------------------------------
url_esearch <- "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi"
url_esummary <- "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi"

# Function to process queries one at a time ------------------------------------------------------
ncbi_searcher_foo <- function(xx, getrelated, verbose, seqrange, entrez_query, limit, hypothetical, ...) {
  # Search for sequence IDs for the given taxon  - - - - - - - - - - - - - - - - - - - - - - - - -
  mssg(verbose, paste("Working on ", names(xx), "...", sep = ""))
  mssg(verbose, "...retrieving sequence IDs...")
  seq_ids <- search_for_sequences(xx, seqrange, entrez_query, limit, ...)
  # Search for sequences of the taxons parent if necessary and possible  - - - - - - - - - - - - -
  if (is.null(seq_ids) && getrelated) {
    mssg(verbose, paste("no sequences for ", names(xx), " - getting other related taxa", sep = ""))
    parent_id <- get_parent(xx, verbose)
    if (is.na(parent_id)) {
      mssg(verbose, paste0("no related taxa found"))
    } else {
      mssg(verbose, paste0("...retrieving sequence IDs for ", names(xx), "..."))
      seq_ids <- search_for_sequences(parent_id, seqrange, entrez_query, limit, ...)
    }
  }
  # Retrieve sequence information  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if (is.null(seq_ids)) {
    mssg(verbose, "no sequences found")
    df <- data.frame(character(0), numeric(0), character(0), character(0), numeric(0), stringsAsFactors = FALSE)
  } else {
    mssg(verbose, "...retrieving available genes and their lengths...")
    df <- download_summary(seq_ids, hypothetical = hypothetical, ...)
    mssg(verbose, "...done.")
  }
  # Format output  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  setNames(df, c("taxon", "length", "gene_desc", "acc_no", "gi_no"))
}

# Function to search for sequences with esearch --------------------------------------------------
search_for_sequences <- function(id, seqrange, entrez_query, limit, ...) {
  if (is.na(id)) return(NULL)
  # Construct search query  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  query_term <- paste0("xXarbitraryXx[porgn:__txid", id, "] AND ", seqrange, " [SLEN]")
  if (!is.null(entrez_query)) query_term <- paste(query_term, entrez_query, sep = " AND ")
  query <- list(db = "nuccore", retmax = limit, term = query_term)
  # Submit query to NCBI - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  query_init <- GET(url_esearch, query = query, ...)
  stop_for_status(query_init)
  # Parse result - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  esearch_result <- xpathApply(content(query_init, as = "parsed"), "//eSearchResult")[[1]]
  if (as.numeric(xmlValue(xpathApply(esearch_result, "//Count")[[1]])) == 0) {
    return(NULL)
  } else {
    return(xpathSApply(esearch_result, "//IdList//Id", xmlValue)) # a list of sequence ids
  }
}

# Function to download and parse sequence summary information using esummary ---------------------
download_summary <- function(seq_id, hypothetical, ...) {
  actualnum <- length(seq_id)
  if (actualnum > 10000) {
    q <- list(db = "nucleotide")
    getstart <- seq(from = 1, to = actualnum, by = 10000)
    getnum <- c(rep(10000, length(getstart) - 1), actualnum - sum(rep(10000, length(getstart) - 1)))
    iterlist = list()
    for (i in seq_along(getstart)) {
      q$id = paste(seq_id[getstart[i]:(getstart[i] + (getnum[i] - 1))], collapse = " ")
      q$retstart <- getstart[i]
      q$retmax <- getnum[i]
      query_res <- POST(url_esummary, body = q)
      stop_for_status(query_res)
      iterlist[[i]] <- parseres(query_res, hypothetical)
    }
    data.frame(rbindlist(iterlist), stringsAsFactors = FALSE)
  } else {
    q <- list(db = "nucleotide", id = paste(seq_id, collapse = " "))
    query_res <- POST(url_esummary, body = q, ...)
    stop_for_status(query_res)
    parseres(query_res, hypothetical)
  }
}

# Function to get a taxon's parent ---------------------------------------------------------------
get_parent <- function(id, verbose) {
  if (!is.na(id)) {
    ancestry <- classification(id = id, db = "ncbi")[[1]]
    if (nrow(ancestry) > 1) {
      parent_name <- ancestry$name[nrow(ancestry) - 1]
      return(get_uid(parent_name, verbose = verbose))
    }
  }
  if (!is.null(names(id)) && grepl(" ", names(id))) { #if a name is given and looks like a species
    parent_name <- strsplit(names(id), " ")[[1]][[1]]
    return(get_uid(parent_name, verbose = verbose))
  }
  return(NA)
}

# Function to parse results from http query ------------------------------------------------------
parseres <- function(x, hypothetical){
  outsum <- xpathApply(content(x, as = "parsed"), "//eSummaryResult")[[1]]
  names <- sapply(getNodeSet(outsum[[1]], "//Item"), xmlGetAttr, name = "Name") # gets names of values in summary
  predicted <- as.character(sapply(getNodeSet(outsum, "//Item"), xmlValue)[grepl("Caption", names)]) #  get access numbers
  has_access_prefix <- grepl("_", predicted)
  access_prefix <- unlist(Map(function(x, y) ifelse(x, strsplit(y, "_")[[1]][[1]], NA),
                              has_access_prefix, predicted))
  predicted[has_access_prefix] <- vapply(strsplit(predicted[has_access_prefix], "_"), `[[`, character(1), 2)

  length_ <- as.numeric(sapply(getNodeSet(outsum, "//Item"), xmlValue)[grepl("Length", names)]) # gets seq lengths
  gis <- as.numeric(sapply(getNodeSet(outsum, "//Item"), xmlValue)[grepl("Gi", names)]) # gets GI numbers
  spnames <- sapply(getNodeSet(outsum, "//Item"), xmlValue)[grepl("Title", names)] # gets seq lengths # get spp names
  spused <- sapply(spnames, function(x) paste(strsplit(x, " ")[[1]][1:2], sep = "", collapse = " "), USE.NAMES = FALSE)
  genesavail <- sapply(spnames, function(x) paste(strsplit(x, " ")[[1]][-c(1:2)], sep = "", collapse = " "), USE.NAMES = FALSE)
  df <- data.frame(spused = spused, length = length_, genesavail = genesavail, access_num = predicted, ids = gis, stringsAsFactors = FALSE)
  if (!hypothetical) df <- df[!(access_prefix %in% c("XM","XR")), ]
  return(df)
}