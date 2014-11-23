#' Get family names to make Phylomatic input object, and output input string
#'    to Phylomatic for use in the function phylomatic_tree.
#'
#' @export
#' @importFrom taxize tax_name
#' @importFrom stringr str_replace
#' @param taxa quoted tsn number (taxonomic serial number)
#' @param format output format, isubmit (you can paste in to the Phylomatic
#'     website), or 'rsubmit' to use in fxn phylomatic_tree
#' @param db One of "ncbi", "itis", or "apg"
#' @return e.g., "pinaceae/pinus/pinus_contorta", in Phylomatic submission format.
#' @examples \donttest{
#' mynames <- c("Poa annua", "Salix goodingii", "Helianthus annuus")
#' phylomatic_names(mynames, format='rsubmit')
#' phylomatic_names(mynames, format='isubmit', db="apg")
#' }

phylomatic_names <- function(taxa = NA, format='isubmit', db="ncbi")
{
  foo <- function(nnn){
    # split up strings if a species name
    taxa2 <- strsplit(gsub("_"," ",nnn), "\\s")[[1]]
    taxa_genus <- traits_capwords(taxa2[[1]], onlyfirst=TRUE)

    if(db %in% c("ncbi","itis")){
      family <- tax_name(query=taxa_genus, get="family", db=db)
    } else {
      tplfamily <- taxize::theplantlist[ match(taxa_genus, taxize::theplantlist$genus), "family" ]
      dd <- taxize::apg_families[ match(tplfamily, taxize::apg_families$this), ]
      if(nchar(as.character(dd$that))==0){ family <- dd$this } else { family <- dd$that }
    }
    stringg <- c(family, strsplit(nnn, " ")[[1]])
    stringg <- tolower(as.character(stringg))
    if (format == 'isubmit') {
      paste(stringg[[1]], "/", stringg[2], "/", tolower(str_replace(nnn, " ", "_")), sep='')
    } else
      if (format == 'rsubmit') {
        paste(stringg[[1]], "%2F", stringg[2], "%2F", tolower(str_replace(nnn, " ", "_")), sep='')
      }
  }

  sapply(taxa, foo, USE.NAMES=FALSE)
}
