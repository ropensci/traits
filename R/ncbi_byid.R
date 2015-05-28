#' Retrieve gene sequences from NCBI by accession number.
#'
#' @import httr
#' @importFrom data.table rbindlist
#' @export
#' @param ids (character) GenBank ids to search for.
#' @param format (character) Return type, e.g., \code{"fasta"}
#' @param verbose (logical) If \code{TRUE} (default), informative messages printed.
#' @details Removes predicted sequences so you don't have to remove them.
#'     Predicted sequences are those with accession numbers that have "XM_" or
#' 		"XR_" prefixes. This function retrieves one sequences for each species,
#'   	picking the longest available for the given gene.
#' @return Data.frame of results.
#' @seealso \code{\link[taxize]{ncbi_search}}, \code{\link[taxize]{ncbi_getbyname}}
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples \donttest{
#' # A single gene
#' ncbi_byid(ids="360040093", format="fasta")
#'
#' # Many genes (with different accession numbers)
#' ncbi_byid(ids=c("360040093","347448433"), format="fasta")
#' }

ncbi_byid <- function(ids, format="fasta", verbose=TRUE)
{
  mssg(verbose, "Retrieving sequence IDs...")

  ids <- paste(ids, collapse=",")
  queryseq <- list(db = "sequences", id = ids, rettype = format, retmode = "text")
  tt <- GET("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi", query = queryseq)
  stop_for_status(tt)
  outseq <- content(tt, as="text")

  outseq2 <- strsplit(outseq, '>')[[1]][-1]

  foo <- function(x){
    temp <- paste(">", x, sep="")
    seq <- gsub("\n", "", strsplit(sub("\n", "<<<", temp[[1]]), "<<<")[[1]][[2]])
    idaccess <- strsplit(x, "\\|")[[1]][c(2,4)]
    desc <- strsplit(strsplit(x, "\\|")[[1]][[5]], "\n")[[1]][[1]]
    outt <- list(desc, as.character(idaccess[1]), idaccess[2], nchar(seq), seq)
    spused <- paste(strsplit(gsub("^\\s+|\\s+$", "", strsplit(temp, "\\|")[[1]][[5]], "both"), " ")[[1]][1:2], sep="", collapse=" ")
    setNames(data.frame(spused=spused, outt, stringsAsFactors = FALSE),
             c("taxon","gene_desc","gi_no","acc_no","length","sequence"))
  }
  mssg(verbose, "...done")
  data.frame(rbindlist(lapply(outseq2, foo)))
}
