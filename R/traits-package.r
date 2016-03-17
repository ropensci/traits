#' traits - Species trait data from around the web
#'
#' Currrently included in \code{traits} with the associated function prefix:
#' \itemize{
#'  \item BETYdb \url{http://www.betydb.org} - \code{betydb_}
#'  \item National Center for Biotechnology Information - NCBI
#'  \url{http://www.ncbi.nlm.nih.gov/} - \code{ncbi_}
#'  \item Global Invasive Species Database - GISD \url{http://www.issg.org/database/welcome/}
#'  - \code{g_}
#'  \item Encyclopedia of Life Invasive Species - \code{eol_}
#'  \item Encyclopedia of Life Traitbank - \code{traitbank_}
#'  \item Coral Traits Database \url{http://coraltraits.org/} - \code{coral_}
#'  \item Flora Europaea \url{http://rbg-web2.rbge.org.uk/FE/fe.html} - \code{fe_}
#'  \item Birdlife International \url{http://rbg-web2.rbge.org.uk/FE/fe.html} - \code{birdlife_}
#'  \item LEDA Traitbase http://www.leda-traitbase.org/LEDAportal/index.jsp - \code{leda_}
#'  \item More to come ...
#' }
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
#' @importFrom httr GET POST content stop_for_status warn_for_status authenticate
#' @importFrom jsonlite fromJSON
#' @importFrom methods is
#' @importFrom stats setNames na.omit
#' @importFrom utils read.csv URLencode
#' @importFrom xml2 read_xml xml_find_all xml_text
#' @importFrom rvest html_table
#' @importFrom taxize get_uid classification get_tsn itis_native iucn_id
#' @importFrom data.table rbindlist fread
#' @importFrom dplyr tbl_df
#' @importFrom readr read_delim
#' @name traits-package
#' @aliases traits
#' @docType package
#' @author Ignasi Bartomeus \email{nacho.bartomeus@@gmail.com}
#' @author Zachary Foster \email{zacharyfoster1989@@gmail.com}
#' @author David LeBauer \email{dlebauer@@gmail.com}
#' @author David Harris \email{davharris@@ucdavis.edu}
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @keywords package
NULL

#' PLANTATT plant traits dataset
#' @name plantatt
#' @docType data
#' @keywords data
NULL
