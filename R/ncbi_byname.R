#' Retrieve gene sequences from NCBI by taxon name and gene names.
#'
#' @export
#' @template ncbi
#' @param gene (character) Gene or genes (in a vector) to search for. See examples.
#' @details Removes predicted sequences so you don't have to remove them.
#'   	Predicted sequences are those with accession numbers that have "XM_" or
#' 		"XR_" prefixes. This function retrieves one sequences for each species,
#'   	picking the longest available for the given gene.
#' @return Data.frame of results.
#' @seealso \code{\link[taxize]{ncbi_search}}, \code{\link[taxize]{ncbi_getbyid}}
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples \donttest{
#' # A single species
#' ncbi_byname(taxa="Acipenser brevirostrum")
#'
#' # Many species
#' species <- c("Colletes similis","Halictus ligatus","Perdita trisignata")
#' ncbi_byname(taxa=species, gene = c("coi", "co1"), seqrange = "1:2000")
#' }
ncbi_byname <- function(taxa, gene="COI", seqrange="1:3000", getrelated=FALSE, verbose=TRUE)
{
  foo <- function(xx){
    mssg(verbose, paste("Working on ", xx, "...", sep=""))
    mssg(verbose, "...retrieving sequence IDs...")

    if (length(gene) > 1) {
      genes_ <- paste(gene, sep = "", collapse = " OR ")
    } else {
      genes_ <- paste(gene, sep = "", collapse = " ")
    }
    genes_ <- paste("(", genes_, ")")

    query <- list(db = "nuccore", term = paste(xx, "[Organism] AND", genes_, "AND",
                                               seqrange, "[SLEN]", collapse = " "), RetMax = 500)

    out <-
      xpathApply(content(GET("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi",
                             query = query), "parsed"), "//eSearchResult")[[1]]
    if (as.numeric(xmlValue(xpathApply(out, "//Count")[[1]])) == 0) {
      message(paste("no sequences of ", gene, " for ", xx, " - getting other sp.", sep = ""))
      if (getrelated == FALSE) {
        mssg(verbose, paste("no sequences of ", gene, " for ", xx, sep = ""))
        res <- data.frame(list(xx, "NA", "NA", "NA", "NA", "NA", "NA"))
        names(res) <- NULL
      } else {
        mssg(verbose, "...retrieving sequence IDs for related species...")
        newname <- strsplit(xx, " ")[[1]][[1]]
        query <- list(db = "nuccore", term = paste(newname, "[Organism] AND", genes_, "AND", seqrange, "[SLEN]", collapse=" "), RetMax=500)
        out <-
          xpathApply(content(GET("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi", query=query), "parsed"), "//eSearchResult")[[1]]
        if( as.numeric(xmlValue(xpathApply(out, "//Count")[[1]]))==0 ){
          mssg(verbose, paste("no sequences of ", gene, " for ", xx, " or ", newname, sep=""))
          res <- data.frame(list(xx, "NA", "NA", "NA", "NA", "NA", "NA"))
          names(res) <- NULL
        } else
        {
          ## For each species = get GI number with longest sequence
          mssg(verbose, "...retrieving sequence ID with longest sequence length...")
          querysum <- list(db = "nucleotide", id = paste(make_ids(out), collapse=" ")) # construct query for species
          res <- parse_ncbi(xx,
            xpathApply(content(GET("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi",
                                   query=querysum), "parsed"), "//eSummaryResult")[[1]], verbose)
        }
      }
    } else {
      ## For each species = get GI number with longest sequence
      mssg(verbose, "...retrieving sequence ID with longest sequence length...")
      querysum <- list(db = "nucleotide", id = paste(make_ids(out), collapse = " ")) # construct query for species
      res <- parse_ncbi(xx, xpathApply(content( # API call
        GET("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi",
            query = querysum), "parsed"), "//eSummaryResult")[[1]], verbose)
    }

    mssg(verbose, "...done.")
    setNames(res, c("taxon", "gene_desc", "gi_no", "acc_no", "length", "sequence", "spused"))
  }

  foo_safe <- tryfail(NULL, foo)
  if(length(taxa)==1){ foo_safe(taxa) } else { lapply(taxa, foo_safe) }
}

parse_ncbi <- function(xx, z, verbose){
  names <- sapply(getNodeSet(z[[1]], "//Item"), xmlGetAttr, name="Name") # gets names of values in summary
  prd <- as.character(sapply(getNodeSet(z, "//Item"), xmlValue)[grepl("Caption", names)]) #  get access numbers
  prd <- sapply(prd, function(x) strsplit(x, "_")[[1]][[1]], USE.NAMES=FALSE)
  l_ <- as.numeric(sapply(getNodeSet(z, "//Item"), xmlValue)[grepl("Length", names)]) # gets seq lengths
  gis <- as.numeric(sapply(getNodeSet(z, "//Item"), xmlValue)[grepl("Gi", names)]) # gets GI numbers
  sns <- sapply(getNodeSet(z, "//Item"), xmlValue)[grepl("Title", names)] # gets seq lengths # get spp names
  df <- data.frame(gis=gis, length=l_, spnames=sns, predicted=prd, stringsAsFactors = FALSE)
  df <- df[!df$predicted %in% c("XM","XR"),] # remove predicted sequences
  gisuse <- df[which.max(x=df$length),] # picks longest sequnence length
  if(nrow(gisuse) > 1){ gisuse <- gisuse[sample(nrow(gisuse), 1), ] } else { gisuse <- gisuse }

  ## Get sequence from previous
  mssg(verbose, "...retrieving sequence...")
  queryseq <- list(db = "sequences", id = gisuse[,1], rettype = "fasta", retmode = "text")
  outseq <- content(GET("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi", query = queryseq), as="text")
  seq <- gsub("\n", "", strsplit(sub("\n", "<<<", outseq), "<<<")[[1]][[2]])
  accessnum <- strsplit(outseq, "\\|")[[1]][4]
  outt <- list(xx, as.character(gisuse[,3]), gisuse[,1], accessnum, gisuse[,2], seq)

  spused <- paste(strsplit(outt[[2]], " ")[[1]][1:2], sep="", collapse=" ")
  outoutout <- data.frame(outt, spused=spused, stringsAsFactors = FALSE)
  names(outoutout) <- NULL
  outoutout
}

make_ids <- function(x) as.numeric(sapply(xpathApply(x, "//IdList//Id"), xmlValue))
