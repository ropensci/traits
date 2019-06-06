## only run if betydb.org is up
check_betydb <- function(url){
  if (httr::status_code(httr::GET("https://www.betydb.org")) != 200) {
    skip("Betydb is offline.")
  }
}

## only run if eol.org is up
# check_traitbank <- function(url){
#   if (httr::status_code(httr::GET("http://eol.org/api")) != 200) {
#     skip("eol's traitbank is offline.")
#   }
# }

#' Clean up any option changes to exactly match a previous state,
#' *unsetting* any options not present in the old list. 
#' @param old_opts a named list, probably created by a previous \code{old_opts <- options()}
#' @return Invisibly, a list of the options changed and their values before resetting
reset_opts <- function(old_opts){
	cur_opts <- options()
	unchanged_opts <- sapply(names(old_opts), function(x){ old_opts[x] %in% cur_opts[x] })
	newly_set <- setdiff(names(cur_opts), names(old_opts))
	nulls <- vector(mode = "list", length = length(newly_set))
	names(nulls) <- newly_set
	
	reset_vals <- options(old_opts[!unchanged_opts])
	removed_vals <- options(nulls)

	invisible(c(reset_vals, removed_vals))
}
