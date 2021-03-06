% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/leda.R
\name{leda}
\alias{leda}
\title{Access LEDA trait data}
\usage{
leda(trait = "age_first_flowering", ...)
}
\arguments{
\item{trait}{(character) Trait to get. See Details.}

\item{...}{Curl options passed on to \link[crul:verb-GET]{crul::verb-GET}}
}
\description{
Access LEDA trait data
}
\details{
For parameter \code{trait}, one of age_first_flowering, branching,
buds_seasonality, buds_vertical_dist, canopy_height, dispersal_type,
leaf_distribution, ldmc_geo, leaf_mass, leaf_size, morphology_disperal,
growth_form, life_span, releasing_height, seed_longevity,
seed_mass, seed_number, seed_shape, shoot_growth_form, snp, ssd, tv,
or clonal_growth_organs

The following are not supported as they are too much of a pain to parse:
buoyancy, seed_bank, sla_geo
}
\examples{
\dontrun{
# Age of first flowering
leda(trait = "age_first_flowering")

# Seed number
leda("seed_number")

# Releasing height
leda(trait = "releasing_height")

# Clonal growth organs
leda(trait = "clonal_growth_organs")

all <- c("age_first_flowering", "branching", "buds_seasonality",
  "buds_vertical_dist", "canopy_height",
  "dispersal_type", "leaf_distribution", "ldmc_geo", "leaf_mass",
  "leaf_size", "morphology_disperal", "growth_form", "life_span",
  "releasing_height", "seed_longevity", "seed_mass",
  "seed_number", "seed_shape", "shoot_growth_form",
  "snp", "ssd", "tv", "clonal_growth_organs")
out <- list()
for (i in seq_along(all)) {
  cat(all[i], sep="\n")
  out[[i]] <- leda(all[i])
}
sapply(out, NROW)
}
}
