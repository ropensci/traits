#' Check if a species is native somewhere
#'
#' @export
#'
#' @param sp character; a vector of length one with a single scientific species
#' names in the form of \code{c("Genus species")}.
#' @param region character; a vector of length one with a single region. Only "europe"
#' and "america" implemented "europe" checks Flora Europaea and only contain plants.
#' "america" checks ITIS and contain both plant and animals.
#' @param where character; a vector of length one with a single place. For America has to
#' match one of those: "Continental US", "Alaska", "Canada", "Caribbean Territories",
#' "Central Pacific Territories", "Hawaii", "Mexico". For Europe has to match one of
#' those: "Albania", "Austria", "Azores", "Belgium", "Islas_Baleares", "Britain",
#' "Bulgaria", "Corse", "Kriti", "Czechoslovakia", "Denmark", "Faroer", "Finland",
#' "France", "Germany", "Greece", "Ireland", "Switzerland", "Netherlands", "Spain",
#' "Hungary", "Iceland", "Italy", "Jugoslavia", "Portugal", "Norway", "Poland", "Romania",
#' "USSR", "Sardegna", "Svalbard", "Sicilia", "Sweden", "Turkey", "USSR_Northern_Division",
#' "USSR_Baltic_Division", "USSR_Central_Division", "USSR_South_western", "USSR_Krym",
#' "USSRSouth_eastern_Division"
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @return A data.frame, with species name and result of origin check
#'
#' @description This function check the status (native or exotic) of a species in a
#' given place
#'
#' For that end, calls \code{\link[taxize]{itis_native}} and \code{\link{fe_native}}.
#' See help documentation of those functions for details.
#'
#' So many more things can be done, like checking species first with \pkg{taxize}, adding
#' more native lists to check...
#'
#' @author Ignasi Bartomeus \email{nacho.bartomeus@@gmail.com}
#' @examples \dontrun{
#' sp <- c("Lavandula stoechas", "Carpobrotus edulis", "Rhododendron ponticum",
#'        "Alkanna lutea", "Anchusa arvensis")
#' is_native(sp[1], where = "Islas_Baleares", region = "europe")
#' lapply(sp, is_native, where = "Continental US", region = "america")
#' lapply(sp, is_native, where = "Islas_Baleares", region = "europe")
#'
#' # combine output for many taxa
#' res <- lapply(sp, is_native, where = "Continental US", region = "america")
#' library("dplyr")
#' rbind_all(res)
#' }
is_native <- function(sp, where, region = c("america", "europe"), ...) {
  .Deprecated(msg = "is_native is deprecated - see is_native() function in originr")

  if (!region %in% c("america", "europe")) {
    stop("region must be one of america or europe", call. = FALSE)
  }
  if (length(sp) > 1) {
    stop("sp should be a single species", call. = FALSE)
  }
  if (region == "america") {
    if (!where %in% c("Continental US", "Alaska", "Canada",
                      "Caribbean Territories", "Central Pacific Territories",
                      "Hawaii", "Mexico")) {
      stop("where must be one America region, see help for accepted names", call. = FALSE)
    }
    tsn_ <- get_tsn(searchterm = sp, ...)[1]
    if (is.na(tsn_)) {
      Out <- "species not in itis"
    } else {
      origin <- itis_native(tsn = tsn_, ...)
      Out <- as.character(origin[which(origin$jurisdictionvalue == where), "origin"])
    }
  }
  if (region == "europe") {
    if (!where %in% c("Albania", "Austria", "Azores", "Belgium", "Islas_Baleares",
                      "Britain", "Bulgaria", "Corse", "Kriti",
                      "Czechoslovakia", "Denmark", "Faroer",
                      "Finland", "France", "Germany", "Greece",
                      "Ireland", "Switzerland", "Netherlands", "Spain",
                      "Hungary", "Iceland", "Italy", "Jugoslavia",
                      "Portugal", "Norway", "Poland", "Romania",
                      "USSR", "Sardegna", "Svalbard", "Sicilia",
                      "Sweden", "Turkey", "USSR_Northern_Division",
                      "USSR_Baltic_Division", "USSR_Central_Division",
                      "USSR_South_western", "USSR_Krym",
                      "USSRSouth_eastern_Division")) {
      stop("where must be one eu country, see help for accepted names", call. = FALSE)
    }
    origin <- fe_native(sp)
    if (length(origin) < 5) {
      Out <- "Species not in flora europaea"
    } else {
      Out <- "Species not present in your selected region"
      if (where %in% origin$native) {
        Out <- "Native"
      }
      if (where %in% origin$exotic) {
        Out <- "Introduced"
      }
      if (where %in% c(origin$status_doubtful, origin$occurrence_doubtful, origin$extinct)) {
        Out <- "status or occurrence doubtful or species extinct"
      }
    }
  }
  data.frame(name = sp, origin = Out, stringsAsFactors = FALSE)
}
