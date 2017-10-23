#' Amniote life history dataset
#'
#' @export
#' @param read (logical) read in csv files. Default: \code{TRUE}
#' @param ... Curl options passed on to [crul::HttpClient()]
#' @return paths to the files (character) if \code{read=FALSE} or
#' a list of data.frame's if \code{read=TRUE}
#' @details
#' When using this data, cite the paper:
#'
#' Myhrvold, N. P., Baldridge, E., Chan, B., Sivam, D., Freeman, D. L. and
#' Ernest, S. K. M. (2015), An amniote life-history database to perform
#' comparative analyses with birds, mammals, and reptiles. Ecology, 96: 3109.
#' https://doi.org/10.1890/15-0846R.1
#'
#' As well as the Dryad data package:
#'
#' L. Freeman, Daniel; P. Myhrvold, Nathan; Chan, Benjamin; Sivam, Dhileep;
#' Ernest, S. K. Morgan; Baldridge, Elita (2016): Full Archive. figshare.
#' https://doi.org/10.6084/m9.figshare.3563457.v1
#'
#' @references https://doi.org/10.1890/15-0846R.1
#' https://doi.org/10.6084/m9.figshare.3563457.v1
#' @examples \dontrun{
#' res <- tr_ernest()
#' res$data
#' res$references
#' res$sparse
#' res$range_count
#' }
tr_ernest <- function(read = TRUE, ...) {
  path <- file.path(traits_cache$cache_path_get(), "ernest")
  files <- file.path(path, ernest_paths)
  dir.create(dirname(files[1]), showWarnings = FALSE, recursive = TRUE)

  if (
    file.path(traits_cache$cache_path_get(), "ernest.zip") %in% traits_cache$list() &&
    all(files %in% traits_cache$list())
  ) {
    message("files in cache already, at: ", path)
  } else {
    cli <- crul::HttpClient$new(url = ernest_base)
    res <- cli$get(disk = paste0(path, ".zip"), ...)
    res$raise_for_status()
    utils::unzip(res$content, exdir = path,
                 junkpaths = TRUE)
    utils::unzip(file.path(path, "ECOL_96_269.zip"), exdir = path,
                 junkpaths = TRUE)
    message("download complete - file at: ", path)
  }

  if (read) {
    list(
      data = dtread(files[1]),
      references = dtread(files[2]),
      sparse = dtread(files[3]),
      range_count = dtread(files[4])
    )
  } else {
    return(files)
  }
}

ernest_base <- "https://ndownloader.figshare.com/articles/3563457/versions/1"
ernest_paths <- c('Amniote_Database_Aug_2015.csv',
                  'Amniote_Database_References_Aug_2015.csv',
                  'Amniote_Range_Count_Aug_2015.csv',
                  'Amniote_Sparse_Table_Aug_2015.csv')
