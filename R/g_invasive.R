#' Check invasive species status for a set of species from GISD database
#'
#' @export
#'
#' @param x character; a vector of scientific species names in the form of
#'    c("Genus species").
#' @param simplify logical; returns a data.frame with the species name and the
#'    values "Invasive", "Not in GISD". I recomend to check first the not
#'    simplified version (default), which contains raw information about the
#'    level of invasiveness.
#' @param verbose logical; If TRUE (default), informative messages printed.
#'
#' @return A data.frame with species names and invasiveness.
#'
#' @description This function check which species (both plants and animals) are
#' considered "invaders" somewhere in the world.
#'
#' For that end, it checks GISD (http://www.issg.org/database/welcome/) and
#' returns a value, either "Not in GISD" or the brief description presented in
#' GISD.
#'
#' Note that the webpage contains more information. Also note that the function
#' won't tell you if it's exotic in your area, a lot of exotic species are not
#' considered invaders (yet).
#'
#' As expected, the function is as good as the database is, which I find quite
#' reliable and well maintained.
#' The database is also able to recognize a lot (but not all) of the species
#' synonyms.
#'
#' Note that \code{eol_invasive} with source of gisd or gisd100 may end up with different results
#' as this function goes directly to the GISD website, whereas eol_invasive only updates their
#' GISD data occassionally. See notes in \code{eol_invasive}.
#'
#' @author Ignasi Bartomeus \email{nacho.bartomeus@@gmail.com}
#' @examples \dontrun{
#' sp <- c("Carpobrotus edulis", "Rosmarinus officinalis")
#' ## first species is invasive, second one is not.
#' g_invasive(sp)
#' g_invasive(sp, simplify = TRUE)
#' }
#'

g_invasive <- function(x, simplify = FALSE, verbose=TRUE) {
  .Deprecated(msg = "g_invasive is deprecated - see gisd() function in originr")

	species <- gsub(" ", "+", x) # reformat sp list
	# create urls to parse
	urls <- paste("http://www.issg.org/database/species/search.asp?sts=sss&st=sss&fr=1&x=13&y=9&sn=",
								species, "&rn=&hci=-1&ei=-1&lang=EN", sep = "")
	# create a data.frame to store the Output
	out <- data.frame(species = x, status = c(1:length(urls)))
	#loop through all species
	for (i in seq_along(urls)) {
		#Parse url and extract table
		doc <- xml2::read_html(urls[i])
		if (length(xml2::xml_find_all(doc, "//span[@class='SearchTitle']")) > 0) {
			out[i, 2] <- "Not in GISD"
		} else{
			if (!simplify) {
			  one <- tryCatch(xml2::xml_text(xml2::xml_find_all(doc, "//span[@class='ListNote']"))[[1]],
                        error = function(e) e)
			  two <- paste(xml2::xml_text(xml2::xml_find_all(doc, "//span[@class='Info']")), collapse = "; ")
			  out[i, 2] <- paste(if (is(one, "simpleError")) NULL else one, two, sep = "; ")
			} else {
        out[i, 2] <- "Invasive"
			}
		}
		mssg(verbose, paste("Checking species", i))
	}
	mssg(verbose, "Done")
	return(out)
}
