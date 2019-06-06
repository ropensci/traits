#' traits - Species trait data from around the web
#'
#' Currently included in \code{traits} with the associated function name or
#' function prefix:
#' \itemize{
#'  \item BETYdb \url{http://www.betydb.org} - \code{betydb_}
#'  \item National Center for Biotechnology Information - NCBI
#'  \url{http://www.ncbi.nlm.nih.gov/} - \code{ncbi_}
#'  \item Encyclopedia of Life Traitbank - \code{traitbank_}
#'  \item Coral Traits Database \url{http://coraltraits.org/} - \code{coral_}
#'  \item Birdlife International \url{https://www.birdlife.org/} -
#'  \code{birdlife_}
#'  \item LEDA Traitbase http://www.leda-traitbase.org/LEDAportal/index.jsp -
#'  \code{leda_}
#'  \item USDA Plants Database - \code{\link{tr_usda}}
#'  \item Zanne et al. plant dataset - \code{\link{tr_zanne}}
#'  \item Amniote life history dataset - \code{\link{tr_ernest}}
#'  \item More to come ...
#' }
#'
#' See also \code{\link{traits-defunct}}
#'
#' @examples \dontrun{
#' library("traits")
#'
#' ## Search the Coral database
#' ## Get the species list and their ids
#' coral_species()
#'
#' ## Get data by taxon
#' coral_taxa(80)
#' }
#'
#' @importFrom httr GET POST content stop_for_status warn_for_status
#' authenticate
#' @importFrom crul HttpClient
#' @importFrom jsonlite fromJSON
#' @importFrom utils read.csv URLencode setTxtProgressBar txtProgressBar
#' @importFrom xml2 read_xml xml_find_all xml_text
#' @importFrom rvest html_table
#' @importFrom taxize get_uid classification get_tsn itis_native iucn_id
#' @importFrom data.table rbindlist fread
#' @importFrom readr read_delim
#' @importFrom tibble as_tibble
#' @name traits-package
#' @aliases traits
#' @docType package
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @author Ignasi Bartomeus
#' @author Zachary Foster
#' @author David LeBauer
#' @author David Harris
#' @author Rupert Collins
#' @keywords package
NULL

#' PLANTATT plant traits dataset
#' @name plantatt
#' @docType data
#' @keywords data
NULL
