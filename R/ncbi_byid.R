#' Retrieve gene sequences from NCBI by accession number.
#'
#' @export
#' @param ids (character) GenBank ids to search for. One or more. Required.
#' @param format (character) Return type, e.g., `"fasta"`. NOW IGNORED.
#' @param verbose (logical) If `TRUE` (default), informative messages
#' printed.
#' @return data.frame of the form:
#' 
#' - taxon - taxonomic name (may include some junk, but hard to parse off)
#' - taxonomy - organism lineage
#' - gene_desc - gene description
#' - organelle - if mitochondrial or chloroplast
#' - gi_no - GI number
#' - acc_no - accession number
#' - keyword - if official DNA barcode
#' - specimen_voucher - museum/lab accession number of vouchered material
#' - lat_lon - longitude/latitude of specimen collection event
#' - country - country/location of specimen collection event
#' - paper_title - title of study
#' - journal - journal study published in (if published)
#' - first_author - first author of study
#' - uploaded_date - date sequence was uploaded to GenBank
#' - length - sequence length
#' - sequence - sequence character string
#'
#' @details If bad ids are included with good ones, the bad ones are
#' silently dropped. If all ids are bad you'll get a stop with error message.
#' @seealso [ncbi_searcher()], ncbi_byname()]
#' @author Scott Chamberlain, Rupert Collins
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
    xml2::xml_text(xml2::xml_find_first(y, string))
  }

  x <- paste(ids, collapse = ",")
  mssg(verbose, "Retrieving sequence IDs...")
  args <- list(db = "sequences", id = x, retmode = "xml", api_key = ncbi_key())
  con <- crul::HttpClient$new("https://eutils.ncbi.nlm.nih.gov")
  w <- con$get("entrez/eutils/efetch.fcgi", query = traitsc(args))
  w$raise_for_status()
  mssg(verbose, "Parsing...")
  xml <- xml2::read_xml(w$parse("UTF-8"))
  tmp <- lapply(xml2::xml_children(xml), function(z) {
    gitmp <- xml2::xml_text(xml2::xml_find_all(z, './GBSeq_other-seqids//GBSeqid'))
    gi <- strsplit(gitmp[length(gitmp)], "\\|")[[1]][2]
    acc <- xml_helper(z, './GBSeq_accession-version')
    def <- xml_helper(z, './GBSeq_definition')
    seq <- xml_helper(z, './GBSeq_sequence')
    seqlen <- xml_helper(z, './GBSeq_length')
    tax <- xml_helper(z, "./GBSeq_organism")
    taxonomy <- xml_helper(z, "./GBSeq_taxonomy")
    date <- xml_helper(z, "./GBSeq_create-date")
    keyword <- xml_helper(z, './/GBSeq_keywords/GBKeyword')
    voucher <- xml_helper(z, './/GBQualifier[GBQualifier_name = "specimen_voucher"]/GBQualifier_value')
    organelle <- xml_helper(z, './/GBQualifier[GBQualifier_name = "organelle"]/GBQualifier_value')
    lat.long <- xml_helper(z, './/GBQualifier[GBQualifier_name = "lat_lon"]/GBQualifier_value')
    country <- xml_helper(z, './/GBQualifier[GBQualifier_name = "country"]/GBQualifier_value')
    first.author <- xml_helper(z, './/GBReference[GBReference_reference = "1"]/GBReference_authors/GBAuthor')
    paper.title <- xml_helper(z, './/GBReference[GBReference_reference = "1"]/GBReference_title')
    journal <- xml_helper(z, './/GBReference[GBReference_reference = "1"]/GBReference_journal')
    data.frame(taxon = tax, taxonomy = taxonomy, gene_desc = def, organelle = organelle, gi_no = gi,
    acc_no = acc, keyword = keyword, specimen_voucher = voucher, lat_lon = lat.long, country = country,
    paper_title = paper.title, journal = journal, first_author = first.author, uploaded_date = date,
    length = seqlen, sequence = seq, stringsAsFactors = FALSE)
  })

  mssg(verbose, "...done")
  data.frame(rbindlist(tmp), stringsAsFactors = FALSE)
}
