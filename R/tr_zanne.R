#' Zanne et al. plant dataset
#'
#' @export
#' @param read (logical) read in csv files. Default: \code{TRUE}
#' @param ... Curl options passed on to [crul::HttpClient()]
#' @return paths to the files (character) if \code{read=FALSE} or
#' a list of data.frame's if \code{read=TRUE}
#' @details This data is a dataset stored on Dryad (doi: 10.5061/dryad.63q27).
#' When using this data, cite the paper:
#'
#' Zanne AE, Tank DC, Cornwell WK, Eastman JM, Smith SA, FitzJohn RG,
#' McGlinn DJ, O'Meara BC, Moles AT, Reich PB, Royer DL, Soltis DE, Stevens PF,
#' Westoby M, Wright IJ, Aarssen L, Bertin RI, Calaminus A, Govaerts R,
#' Hemmings F, Leishman MR, Oleksyn J, Soltis PS, Swenson NG, Warman L,
#' Beaulieu JM, Ordonez A (2014) Three keys to the radiation of angiosperms
#' into freezing environments. Nature 506(7486): 89-92.
#' http://dx.doi.org/10.1038/nature12872
#'
#' As well as the Dryad data package:
#'
#' Zanne AE, Tank DC, Cornwell WK, Eastman JM, Smith SA, FitzJohn RG,
#' McGlinn DJ, O'Meara BC, Moles AT, Reich PB, Royer DL, Soltis DE, Stevens PF,
#' Westoby M, Wright IJ, Aarssen L, Bertin RI, Calaminus A, Govaerts R,
#' Hemmings F, Leishman MR, Oleksyn J, Soltis PS, Swenson NG, Warman L,
#' Beaulieu JM, Ordonez A (2013) Data from: Three keys to the radiation of
#' angiosperms into freezing environments. Dryad Digital Repository.
#' http://dx.doi.org/10.5061/dryad.63q27.2
#'
#' @references http://datadryad.org/resource/doi:10.5061/dryad.63q27
#' @examples \dontrun{
#' res <- tr_zanne()
#' res$tax_lookup
#' res$woodiness
#' res$freezing
#' res$leaf_phenology
#' }
tr_zanne <- function(read = TRUE, ...) {
  urls <- unname(vapply(zanne_urls, function(z) paste0(zanne_base, z), ""))
  files <- file.path(traits_cache$cache_path_get(), zanne_paths)
  dir.create(dirname(files[1]), showWarnings = FALSE, recursive = TRUE)
  paths <- unlist(unname(Map(function(a, b) {
    if (b %in% traits_cache$list()) {
      message("file in cache already, at: ", b)
    } else {
      cli <- crul::HttpClient$new(url = a)
      res <- cli$get(disk = b, ...)
      res$raise_for_status()
      message("download complete - file at: ", b)
    }
    return(b)
  }, urls, files)))
  if (read) {
    list(
      tax_lookup = readr::read_csv(paths[1]),
      woodiness = readr::read_csv(paths[2]),
      freezing = {
        pp <- file.path(dirname(paths[4]), "freezing")
        utils::unzip(paths[4], exdir = pp, junkpaths = TRUE)
        readr::read_csv(file.path(pp, 'MinimumFreezingExposure.csv'))
      },
      leaf_phenology = readr::read_csv(paths[5])
    )
  } else {
    return(paths)
  }
}

zanne_base <- "http://datadryad.org/bitstream/handle/10255/dryad."
zanne_urls <- list(
  tax_lookup = "59001/Spermatophyta_Genera.csv?sequence=2",
  woodiness = "59002/GlobalWoodinessDatabase.csv?sequence=1",
  phylogenies = "59003/PhylogeneticResources.zip?sequence=1",
  freezing = "59004/climate.zip?sequence=3",
  leaf_phenology = "59005/GlobalLeafPhenologyDatabase.csv?sequence=1"
)
zanne_paths <- c('Spermatophyta_Genera.csv', 'GlobalWoodinessDatabase.csv',
                 'PhylogeneticResources.zip', 'climate.zip',
                 'GlobalLeafPhenologyDatabase.csv')
