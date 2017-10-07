#' Access LEDA trait data
#'
#' @export
#' @param trait (character) Trait to get. See Details.
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @details For parameter \code{trait}, one of age_first_flowering, branching,
#' buds_seasonality, buds_vertical_dist, canopy_height, dispersal_type,
#' leaf_distribution, ldmc_geo, leaf_mass, leaf_size, morphology_disperal,
#' growth_form, life_span, releasing_height, seed_longevity,
#' seed_mass, seed_number, seed_shape, shoot_growth_form, snp, ssd, tv,
#' or clonal_growth_organs
#'
#' The following are not supported as they are too much of a pain to parse:
#' buoyancy, seed_bank, sla_geo
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples \dontrun{
#' # Age of first flowering
#' leda(trait = "age_first_flowering")
#'
#' # Seed number
#' leda("seed_number")
#'
#' # Releasing height
#' leda(trait = "releasing_height")
#'
#' # Clonal growth organs
#' leda(trait = "clonal_growth_organs")
#'
#' all <- c("age_first_flowering", "branching", "buds_seasonality",
#'   "buds_vertical_dist", "canopy_height",
#'   "dispersal_type", "leaf_distribution", "ldmc_geo", "leaf_mass",
#'   "leaf_size", "morphology_disperal", "growth_form", "life_span",
#'   "releasing_height", "seed_longevity", "seed_mass",
#'   "seed_number", "seed_shape", "shoot_growth_form",
#'   "snp", "ssd", "tv", "clonal_growth_organs")
#' out <- list()
#' for (i in seq_along(all)) {
#'   cat(all[i], sep="\n")
#'   out[[i]] <- leda(all[i])
#' }
#' sapply(out, NROW)
#' }
leda <- function(trait = "age_first_flowering", ...) {
  tt <- GET(utils::URLencode(paste0(leda_base(), pick_file_name(trait))), ...)
  out <- rawToChar(content(tt, "raw", encoding = "UTF-8"))
  stop_for_status(tt)
  out <- iconv(out, "latin1", "UTF-8")
  str <- sub("^\\r\\n\\r\\n", "", substring(out, regexpr("\r\n\r", out)[1], nchar(out)))
  df <- suppressWarnings(readr::read_delim(str, delim = ";"))
  stats::setNames(df, gsub("\\s", "_", tolower(names(df))))
}

pick_file_name <- function(x) {
  x <- match.arg(x, c("age_first_flowering", "branching", "buds_seasonality",
                      "buds_vertical_dist", "canopy_height",
                      "dispersal_type", "leaf_distribution", "ldmc_geo", "leaf_mass",
                      "leaf_size", "morphology_disperal", "growth_form", "life_span",
                      "releasing_height", "seed_longevity", "seed_mass",
                      "seed_number", "seed_shape", "shoot_growth_form",
                      "snp", "ssd", "tv", "clonal_growth_organs"))
  switch(x,
         age_first_flowering = aff,
         branching = branching,
         buds_seasonality = budseas,
         buds_vertical_dist = budvertdist,
         canopy_height = canheight,
         dispersal_type = disptype,
         leaf_distribution = leafdist,
         ldmc_geo = ldmc,
         leaf_mass = leafmass,
         leaf_size = leafsize,
         morphology_disperal = morphdisp,
         growth_form = growthform,
         life_span = lifespan,
         releasing_height = relheight,
         seed_longevity = seedlong,
         seed_mass = seedmass,
         seed_number = seednum,
         seed_shape = seedshape,
         shoot_growth_form = shootgrowth,
         snp = snp,
         ssd = ssd,
         tv = tv,
         clonal_growth_organs = clonalgrowth)
}

# leda_base <- function() "http://www.leda-traitbase.org/LEDAportal/objects/Data_files/"
leda_base <- function() "http://www.uni-oldenburg.de/fileadmin/user_upload/biologie/ag/landeco/download/LEDA/Data_files/"

aff <- "age_of_first_flowering.txt"
branching <- "branching.txt"
budseas <- "buds_seasonality.txt"
budvertdist <- "buds_vertical_dist.txt"
buoy <- "buoyancy.txt"
canheight <- "canopy_height.txt"
disptype <- "dispersal_type.txt"
leafdist <- "leaf_distribution.txt"
ldmc <- "LDMC_und_Geo.txt"
leafmass <- "leaf_mass.txt"
leafsize <- "leaf_size.txt"
morphdisp <- "morphology_dispersal_unit.txt"
growthform <- "plant_growth_form.txt"
lifespan <- "plant_life_span.txt"
relheight <- "releasing_height.txt"
seedbank <- "seed_bank.txt"
seedlong <- "seed_longevity.txt"
seedmass <- "seed_mass.txt"
seednum <- "seed_number.txt"
seedshape <- "seed_shape.txt"
shootgrowth <- "shoot_growth_form.txt"
sla <- "SLA_und_geo_neu.txt"
snp <- "SNP.txt"
ssd <- "ssd.txt"
tv <- "TV.txt"
clonalgrowth <- 'CGO.txt'
