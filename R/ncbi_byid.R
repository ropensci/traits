#' Retrieve gene sequences from NCBI by accession number.
#'
#' @export
#' @param ids (character) GenBank ids to search for. One or more. Required.
#' @param format (character) Return type, e.g., \code{"fasta"}. NOW IGNORED.
#' @param verbose (logical) If \code{TRUE} (default), informative messages printed.
#' @return Data.frame of the form:
#' \itemize{
#'  \item taxon - taxonomic name (may include some junk, but hard to parse off)
#'  \item gene_desc - gene description
#'  \item gi_no - GI number
#'  \item acc_no - accession number
#'  \item length - sequence length
#'  \item sequence - sequence character string
#' }
#' @details If bad ids are included with good ones, the bad ones are silently dropped.
#' If all ids are bad you'll get a stop with error message.
#' @seealso \code{\link[taxize]{ncbi_search}}, \code{\link[taxize]{ncbi_getbyname}}
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples \dontrun{
#' # A single gene
#' ncbi_byid(ids="360040093")
#'
#' # Many genes (with different accession numbers)
#' ncbi_byid(ids=c("360040093","347448433"))
#' }

ncbi_byid <- function(ids, format=NULL, verbose=TRUE) {
  calls <- names(sapply(match.call(), deparse))[-1]
  calls_vec <- "format" %in% calls
  if (any(calls_vec)) {
    stop("The parameter format will be removed soon, and is currently ignored")
  }

  xml_helper <- function(y, string) {
    xml2::xml_text(xml2::xml_find_one(y, string))
  }

  x <- paste(ids, collapse = ",")
  mssg(verbose, "Retrieving sequence IDs...")
  tt <- GET("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi",
            query = list(db = "sequences", id = x, retmode = "xml"))
  stop_for_status(tt)
  mssg(verbose, "Parsing...")
  xml <- xml2::read_xml(content(tt, "text", encoding = "UTF-8"))
  tmp <- lapply(xml2::xml_children(xml), function(z) {
    gitmp <- xml2::xml_text(xml2::xml_find_all(z, './GBSeq_other-seqids//GBSeqid'))
    gi <- strsplit(gitmp[length(gitmp)], "\\|")[[1]][2]
    acc <- xml_helper(z, './GBSeq_accession-version')
    def <- xml_helper(z, './GBSeq_definition')
    seq <- xml_helper(z, './GBSeq_sequence')
    seqlen <- xml_helper(z, './GBSeq_length')
    tax <- xml_helper(z, "./GBSeq_organism")
    data.frame(taxon = tax, gene_desc = def, gi_no = gi, acc_no = acc,
               length = seqlen, sequence = seq, stringsAsFactors = FALSE)
  })

  mssg(verbose, "...done")
  data.frame(rbindlist(tmp))
}

# not_spp <- c("mitochondrial", "voucher", "^ATCC$", "^DNA$", "sequence",
#              "^satellite$", "^mRNA$", "^unnamed protein product$", "^gene$")

# ids <- paste(ids, collapse = ",")
# queryseq <- list(db = "sequences", id = ids, rettype = format, retmode = "text")
# tt <- GET("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi", query = queryseq)
# stop_for_status(tt)
# outseq <- content(tt, "text", encoding = "UTF-8")
#
# outseq2 <- strsplit(outseq, '>')[[1]][-1]

# foo <- function(x){
#   temp <- paste(">", x, sep = "")
#   seq <- gsub("\n", "", strsplit(sub("\n", "<<<", temp[[1]]), "<<<")[[1]][[2]])
#   idaccess <- strsplit(x, "\\|")[[1]][c(2,4)]
#   desc <- strsplit(strsplit(x, "\\|")[[1]][[5]], "\n")[[1]][[1]]
#   outt <- list(desc, as.character(idaccess[1]), idaccess[2], nchar(seq), seq)
#
#   fifth <- strsplit(temp, "\\|")[[1]][[5]]
#   if (grepl("\\[.+\\]", fifth)) {
#     spused <- gsub("\\[|\\]", "", strextract(fifth, "\\[.+\\]"))
#   } else {
#     spused <-
#       strsplit(gsub("^\\s+|\\s+$", "", fifth, "both"), " ")[[1]][1:3]
#     spused <-
#       grep(paste0(not_spp, collapse = "|"), spused, invert = TRUE, value = TRUE)
#     spused <- paste(spused, sep = "", collapse = " ")
#   }
#
#   setNames(data.frame(spused = spused, outt, stringsAsFactors = FALSE),
#            c("taxon","gene_desc","gi_no","acc_no","length","sequence"))
# }
