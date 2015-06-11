#' Check if a species is native somewhere
#'
#' @importFrom taxize get_tsn itis_native
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
#' @return A vectors saying if is native or exotic. When species is not found in the
#' database its indicated.
#'
#' @description This function check the status (native or exotic) of a species in a
#' given place
#'
#' For that end, calls itis_native{taxize} and fe_native{traits}. See help
#' documentation of those functions for details.
#'
#' So many more things can be done, like checking species first with taxize, adding
#' more native lists to check...
#'
#' @author Ignasi Bartomeus \email{nacho.bartomeus@@gmail.com}
#' @examples \donttest{
#' sp <- c("Lavandula stoechas", "Carpobrotus edulis", "Rhododendron ponticum",
#'        "Alkanna lutea", "Anchusa arvensis")
#' is_native(sp[1], where = "Islas_Baleares", region = "europe")
#' sapply(sp, is_native, where = "Continental US", region = "america")
#' sapply(sp, is_native, where = "Islas_Baleares", region = "europe")
#' }
is_native <- function(sp, where, region = c("america", "europe"), ...) {
  if (!region %in% c("america", "europe")) {
    stop("region must be one of america or europe")
  }
  if (length(sp) > 1) {
    stop("sp should be a single species")
  }
  if (region == "america") {
    if (!where %in% c("Continental US", "Alaska", "Canada",
                     "Caribbean Territories", "Central Pacific Territories",
                     "Hawaii", "Mexico")) {
      stop("where must be one America region, see help for accepted names")
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
      stop("where must be one eu country, see help for accepted names")
    }
    origin <- fe_native(sp)
    if (length(origin) < 5) {
      Out <- "Species not in flora europaea"
    } else {
      Out <- "Not found"
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
  Out
}
