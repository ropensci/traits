#' traits - Species trait data from around the web
#'
#' Currently included in `traits` with the associated function name or
#' function prefix:
#'
#' - BETYdb http://www.betydb.org - `betydb_`
#' - National Center for Biotechnology Information - NCBI
#'  http://www.ncbi.nlm.nih.gov/ - `ncbi_`
#' - Encyclopedia of Life Traitbank - `traitbank_`
#' - Birdlife International https://www.birdlife.org/ -
#'  `birdlife_`
#' - LEDA Traitbase http://www.leda-traitbase.org/LEDAportal/index.jsp -
#'  `leda_`
#' - Zanne et al. plant dataset - [tr_zanne()]
#' - Amniote life history dataset - [tr_ernest()]
#'
#' See also [traits-defunct]
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
#' @author Scott Chamberlain
#' @author Ignasi Bartomeus
#' @author Zachary Foster
#' @author David LeBauer
#' @author David Harris
#' @author Rupert Collins
#' @keywords package
#' @keywords internal
"_PACKAGE"

#' PLANTATT plant traits dataset
#' @name plantatt
#' @docType data
#' @keywords data
NULL
