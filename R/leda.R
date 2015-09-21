#' Access LEDA trait data
#'
#' @importFrom data.table fread
#' @export
#' @param trait (character) Trait to get. See Details.
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @details For parameter \code{trait}, one of age_first_flowering, branching,
#' buds_seasonality, buds_vertical_dist, buoyancy, canopy_height, dispersal_type,
#' leaf_distribution, ldmc_geo, leaf_mass, leaf_size, morphology_disperal,
#' growth_form, life_span, releasing_height, seed_bank, seed_longevity,
#' seed_mass, seed_number, seed_shape, shoot_growth_form, sla_geo, snp, ssd, or tv
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples \dontrun{
#' # Age of first flowering
#' leda(trait = "age_first_flowering")
#'
#' # Age of first flowering
#' leda(trait = "seed_bank")
#' }
leda <- function(trait = "age_first_flowering", ...) {
  tt <- GET(URLencode(paste0(leda_base(), pick_file_name(trait))), ...)
  stop_for_status(tt)
  out <- content(tt, as = "text")
  str <- sub("^\\r\\n\\r\\n", "", substring(out, regexpr("\r\n\r", out)[1], nchar(out)))
  df <- suppressWarnings(data.table::fread(str, stringsAsFactors = FALSE, data.table = FALSE))
  dplyr::tbl_df(setNames(df, tolower(names(df))))
}

pick_file_name <- function(x) {
  x <- match.arg(x, c("age_first_flowering", "branching", "buds_seasonality ",
                      "buds_vertical_dist", "buoyancy", "canopy_height",
                      "dispersal_type", "leaf_distribution", "ldmc_geo", "leaf_mass",
                      "leaf_size", "morphology_disperal", "growth_form", "life_span",
                      "releasing_height", "seed_bank", "seed_longevity", "seed_mass",
                      "seed_number", "seed_shape", "shoot_growth_form", "sla_geo",
                      "snp", "ssd", "tv"))
  switch(x,
         age_first_flowering = aff,
         branching = branching,
         buds_seasonality  = budseas,
         buds_vertical_dist = budvertdist,
         buoyancy = buoy,
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
         seed_bank = seedbank,
         seed_longevity = seedlong,
         seed_mass = seedmass,
         seed_number = seednum,
         seed_shape = seedshape,
         shoot_growth_form = shootgrowth,
         sla_geo = sla,
         snp = snp,
         ssd = ssd,
         tv = tv)
}

leda_base <- function() "http://www.leda-traitbase.org/LEDAportal/objects/Data_files/"
aff <- "age of first flowering.txt"
branching <- "branching.txt"
budseas <- "buds seasonality.txt"
budvertdist <- "buds vertical dist.txt"
buoy <- "buoyancy.txt"
canheight <- "canopy height.txt"
disptype <- "dispersal type.txt"
leafdist <- "leaf distribution.txt"
ldmc <- "LDMC und Geo.txt"
leafmass <- "leaf mass.txt"
leafsize <- "leaf size.txt"
morphdisp <- "morphology dispersal unit.txt"
growthform <- "plant growth form.txt"
lifespan <- "plant life span.txt"
relheight <- "releasing height.txt"
seedbank <- "seed bank.txt"
seedlong <- "seed longevity.txt"
seedmass <- "seed mass.txt"
seednum <- "seed number.txt"
seedshape <- "seed shape.txt"
shootgrowth <- "shoot growth form.txt"
sla <- "SLA und geo.txt"
snp <- "SNP.txt"
ssd <- "ssd.txt"
tv <- "TV.txt"
