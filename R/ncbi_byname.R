#' Retrieve gene sequences from NCBI by taxon name and gene names.
#'
#' @export
#' @template ncbi
#' @param gene (character) Gene or genes (in a vector) to search for.
#' See examples.
#' @param ... Curl options passed on to [crul::verb-GET]
#' @param batch_size An integer specifying the number of names to query per batch.
#' @details Removes predicted sequences so you don't have to remove them.
#' Predicted sequences are those with accession numbers that have "XM_" or
#' "XR_" prefixes. This function retrieves one sequences for each species,
#' picking the longest available for the given gene.
#' @return data.frame
#' @seealso [ncbi_searcher()], [ncbi_byid()]
#' @author Scott Chamberlain
#' @examples \dontrun{
#' # A single species
#' ncbi_byname(taxa="Acipenser brevirostrum")
#'
#' # Many species
#' species <- c("Colletes similis","Halictus ligatus","Perdita californica")
#' ncbi_byname(taxa=species, gene = c("coi", "co1"), seqrange = "1:2000")
#' }
ncbi_byname <- function(taxa, gene="COI", seqrange="1:3000", getrelated=FALSE, verbose=TRUE, batch_size = 100, ...) {
  foo <- function(xx) {
    mssg(verbose, paste("Working on ", xx, "...", sep = ""))
    mssg(verbose, "...retrieving sequence IDs...")

    if (length(gene) > 1) {
      genes_ <- paste(gene, sep = "", collapse = " OR ")
    } else {
      genes_ <- paste(gene, sep = "", collapse = " ")
    }
    genes_ <- paste("(", genes_, ")")

    query <- list(
      db = "nuccore",
      term = paste(xx, "[Organism] AND", genes_, "AND",
                   seqrange, "[SLEN]", collapse = " "),
      RetMax = 500,
      api_key = ncbi_key())

    con <- crul::HttpClient$new("https://eutils.ncbi.nlm.nih.gov",
      opts = list(...))
    w <- con$get("entrez/eutils/esearch.fcgi", query = query)
    w$raise_for_status()
    out <-
      xml2::xml_find_all(xml2::read_xml(w$parse("UTF-8")), "//eSearchResult")[[1]]
    if (as.numeric(xml2::xml_text(xml2::xml_find_all(out, "//Count")[[1]])) == 0) {
      message(paste("no sequences of ", gene, " for ", xx, " - getting other sp.", sep = ""))
      if (!getrelated) {
        mssg(verbose, paste("no sequences of ", gene, " for ", xx, sep = ""))
        res <- data.frame(
          taxon = xx, gene_desc = NA_character_, 
          gi_no = NA_real_, acc_no = NA_character_, length = NA_real_, 
          sequence = NA_character_, spused = NA_character_,
          stringsAsFactors = FALSE)
      } else {
        mssg(verbose, "...retrieving sequence IDs for related species...")
        newname <- strsplit(xx, " ")[[1]][[1]]
        query <- list(db = "nuccore",
          term = paste(newname, "[Organism] AND", genes_, "AND", seqrange, "[SLEN]", collapse = " "), 
          RetMax = 500,
          api_key = ncbi_key())
        bb <- con$get("entrez/eutils/esearch.fcgi", query = query)
        bb$raise_for_status()
        out <-
          xml2::xml_find_all(xml2::read_xml(bb$parse("UTF-8")), "//eSearchResult")[[1]]
        if (as.numeric(xml2::xml_text(xml2::xml_find_all(out, "//Count")[[1]])) == 0) {
          mssg(verbose, paste("no sequences of ", gene, " for ", xx, " or ", newname, sep = ""))
          res <- data.frame(
            taxon = xx, gene_desc = NA_character_, 
            gi_no = NA_real_, acc_no = NA_character_, length = NA_real_, 
            sequence = NA_character_, spused = NA_character_,
            stringsAsFactors = FALSE)
        } else {
          ## For each species = get GI number with longest sequence
          mssg(verbose, "...retrieving sequence ID with longest sequence length...")
          querysum <- list(db = "nucleotide",
            id = paste(make_ids(out), collapse = " "),
            api_key = ncbi_key())
          z <- con$get("entrez/eutils/esummary.fcgi", query = querysum)
          z$raise_for_status()
          res <- parse_ncbi(xx,
                xml2::xml_find_all(
                  xml2::read_xml(z$parse("UTF-8")), "//eSummaryResult"), verbose)
        }
      }
    } else {
      ## For each species = get GI number with longest sequence
      mssg(verbose, "...retrieving sequence ID with longest sequence length...")
      # construct query for species
      ids <- make_ids(out)
      res_list <- lapply(seq(1, length(ids), by = batch_size), function(i) {
        querysum <- list(db = "nucleotide", 
                         id = paste(ids[i:min(i + batch_size - 1, length(ids))], collapse = " "),
                         api_key = ncbi_key())
        z <- con$get("entrez/eutils/esummary.fcgi", query = querysum)
        z$raise_for_status()
        xml2::xml_find_all(xml2::read_xml(z$parse("UTF-8")), "//eSummaryResult")
      })
      
      res <- do.call(rbind, lapply(res_list, function(x) parse_ncbi(xx, x, verbose)))
    }
    
    mssg(verbose, "...done.")
    stats::setNames(res, c("taxon", "gene_desc", "gi_no", "acc_no", "length", "sequence", "spused"))
  }
  
  foo_safe <- tryfail(NULL, foo)
  if (length(taxa) == 1){ 
    return(foo_safe(taxa))
  } else { 
    return(do.call(rbind, lapply(taxa, foo_safe))) 
  }
}

parse_ncbi <- function(xx, z, verbose) {
  
  names <- xml2::xml_attr(xml2::xml_find_all(z, "//Item"), "Name") # gets names of values in summary
  
  if(length(names) == 0) {
    message("No sequences found for ", xx)
    return(data.frame(taxon = xx, gene_desc = NA, 
                      gi_no = NA, acc_no = NA, length = NA, 
                      sequence = NA, spused = NA, 
                      stringsAsFactors = FALSE))
  }
  
  prd <- xml2::xml_text(xml2::xml_find_all(z, '//Item[@Name="Caption"]')) #  get access numbers
  prd <- sapply(prd, function(x) strsplit(x, "_")[[1]][[1]], USE.NAMES=FALSE)
  l_ <- as.numeric(xml2::xml_text(xml2::xml_find_all(z, '//Item[@Name="Length"]'))) # gets seq lengths
  gis <- as.numeric(xml2::xml_text(xml2::xml_find_all(z, '//Item[@Name="Gi"]'))) # gets GI numbers
  sns <- xml2::xml_text(xml2::xml_find_all(z, '//Item[@Name="Title"]')) # gets seq lengths # get spp names
  df <- data.frame(gis=gis, length=l_, spnames=sns, predicted=prd, stringsAsFactors = FALSE)
  df <- df[!df$predicted %in% c("XM","XR"),] # remove predicted sequences
  if (nrow(df) == 0) {
    return(data.frame(taxon = xx, gene_desc = NA, gi_no = NA, acc_no = NA, length = NA, sequence = NA, spused = NA, stringsAsFactors = FALSE))
  }
  gisuse <- df[which.max(x=df$length),] # picks longest sequnence length
  if (NROW(gisuse) > 1) {
    gisuse <- gisuse[sample(NROW(gisuse), 1), ]
  }
  ## Get sequence from previous
  mssg(verbose, "...retrieving sequence...")
  queryseq <- list(db = "sequences", id = gisuse[,1], rettype = "fasta",
    retmode = "text", api_key = ncbi_key())
  con <- crul::HttpClient$new("https://eutils.ncbi.nlm.nih.gov")
  w <- con$get("entrez/eutils/efetch.fcgi", query = traitsc(queryseq))
  w$raise_for_status()
  outseq <- w$parse("UTF-8")
  seq <- gsub("\n", "", strsplit(sub("\n", "<<<", outseq), "<<<")[[1]][[2]])
  accessnum <- strsplit(outseq, "\\|")[[1]][4]
  outt <- list(taxon = xx, gene_desc = as.character(gisuse[,3]), 
               gi_no = gisuse[,1], acc_no = accessnum, 
               length = gisuse[,2], sequence = seq, 
               spused = paste(
                 strsplit(as.character(gisuse[,3]), 
                          " ")[[1]][1:2], 
                 collapse = " "))

  spused <- paste(strsplit(outt[[2]], " ")[[1]][1:2], sep = "", collapse = " ")
  outoutout <- data.frame(outt, stringsAsFactors = FALSE)
  
  return(outoutout)
}

make_ids <- function(x) as.numeric(xml2::xml_text(xml2::xml_find_all(x, "//IdList//Id")))

tryfail <- function(default, code) {
  tryCatch(code, error = function(e) { 
    message(e)
    return(default) 
  })
}