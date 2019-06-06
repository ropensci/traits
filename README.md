traits
=======



[![Build Status](https://travis-ci.org/ropensci/traits.svg?branch=master)](https://travis-ci.org/ropensci/traits)
[![codecov.io](https://codecov.io/github/ropensci/traits/coverage.svg?branch=master)](https://codecov.io/github/ropensci/traits?branch=master)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/traits)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/traits)](https://CRAN.R-project.org/package=traits)

R client for various sources of species trait data.

What is a trait? A "trait" for the purposes of this package is broadly defined as an aspect of a species that can be described or measured, such as physical traits (size, length, height, color), behavioral traits (running speed, etc.), and even variables that make up the niche of the species (e.g., habitat).

Included in `traits` with the associated function prefix or function name:

* [BETYdb](http://www.betydb.org) - `betydb_`
* [National Center for Biotechnology Information - NCBI](http://www.ncbi.nlm.nih.gov/) - `ncbi_`
* [Encyclopedia of Life Traitbank](http://eol.org/info/516) - `traitbank_`
* [Coral Traits Database](http://coraltraits.org/) - `coral_`
* [Birdlife International](https://www.birdlife.org/) - `birdlife_`
* LEDA Traitbase - `leda_`
* USDA Plants Database - `tr_usda`
* Zanne et al. plant dataset - `tr_zanne`
* Amniote life history dataset - `tr_ernest`
* More to come ...

Talk to us on the [issues page](https://github.com/ropensci/traits/issues) if you know of a source of traits data with an API, and we'll see about including it.

For an introduction to the package, see [the vignette](vignettes/traits_intro.Rmd).

## Installation

Stable CRAN version


```r
install.packages("traits")
```

Or development version from GitHub


```r
devtools::install_github("ropensci/traits")
```


```r
library("traits")
library("dplyr")
```

## BETYdb

Get trait data for Willow (_Salix_ spp.)


```r
(salix <- betydb_search("Salix Vcmax"))
#> # A tibble: 14 x 36
#>    access_level       author checked citation_id citation_year  city
#>  *        <int>        <chr>   <int>       <int>         <int> <chr>
#>  1            4 Wullschleger       1          51          1993  <NA>
#>  2            4         Wang       1         381          2010  <NA>
#>  3            4       Merilo       1         430          2005 Saare
#>  4            4       Merilo       1         430          2005 Saare
#>  5            4       Merilo       1         430          2005 Saare
#>  6            4       Merilo       1         430          2005 Saare
#>  7            4       Merilo       1         430          2005 Saare
#>  8            4       Merilo       1         430          2005 Saare
#>  9            4       Merilo       1         430          2005 Saare
#> 10            4       Merilo       1         430          2005 Saare
#> 11            4       Merilo       1         430          2005 Saare
#> 12            4       Merilo       1         430          2005 Saare
#> 13            4       Merilo       1         430          2005 Saare
#> 14            4       Merilo       1         430          2005 Saare
#> # ... with 30 more variables: commonname <chr>, cultivar <chr>,
#> #   cultivar_id <int>, date <chr>, dateloc <chr>, entity <lgl>,
#> #   genus <chr>, id <int>, lat <dbl>, lon <dbl>, mean <dbl>,
#> #   method_name <lgl>, month <int>, n <int>, notes <chr>, raw_date <chr>,
#> #   result_type <chr>, scientificname <chr>, site_id <int>,
#> #   sitename <chr>, species_id <int>, stat <dbl>, statname <chr>,
#> #   time <chr>, trait <chr>, trait_description <chr>, treatment <chr>,
#> #   treatment_id <int>, units <chr>, year <int>
# equivalent:
# (out <- betydb_search("willow"))
```

Summarise data from the output `data.frame`


```r
library("dplyr")
salix %>%
  group_by(scientificname, trait) %>%
  mutate(.mean = as.numeric(mean)) %>%
  summarise(mean = round(mean(.mean, na.rm = TRUE), 2),
            min = round(min(.mean, na.rm = TRUE), 2),
            max = round(max(.mean, na.rm = TRUE), 2),
            n = length(n))
#> # A tibble: 4 x 6
#> # Groups:   scientificname [?]
#>                    scientificname trait  mean   min   max     n
#>                             <chr> <chr> <dbl> <dbl> <dbl> <int>
#> 1                           Salix Vcmax 65.00 65.00 65.00     1
#> 2                Salix dasyclados Vcmax 46.08 34.30 56.68     4
#> 3 Salix sachalinensis × miyabeana Vcmax 79.28 79.28 79.28     1
#> 4                 Salix viminalis Vcmax 43.04 19.99 61.29     8
```

## EOL's traitbank trait data

Searching for _Balaenoptera musculus_ (blue whale), page id `328574`


```r
res <- traitbank(328574)
res$graph %>%
  select(`dwc:measurementtype`) %>%
  filter(!is.na(`dwc:measurementtype`))
#> # A tibble: 181 x 1
#>                                   `dwc:measurementtype`
#>                                                   <chr>
#>  1 http://eol.org/schema/terms/MineralCompositionOfMilk
#>  2 http://eol.org/schema/terms/MineralCompositionOfMilk
#>  3 http://eol.org/schema/terms/MineralCompositionOfMilk
#>  4 http://eol.org/schema/terms/MineralCompositionOfMilk
#>  5 http://eol.org/schema/terms/MineralCompositionOfMilk
#>  6 http://eol.org/schema/terms/MineralCompositionOfMilk
#>  7 http://eol.org/schema/terms/MineralCompositionOfMilk
#>  8 http://eol.org/schema/terms/MineralCompositionOfMilk
#>  9 http://eol.org/schema/terms/MineralCompositionOfMilk
#> 10 http://eol.org/schema/terms/MineralCompositionOfMilk
#> # ... with 171 more rows
```

## Coral

Get the species list and their ids


```r
coral_species()
#> # A tibble: 1,548 x 2
#>                          name    id
#>                         <chr> <chr>
#>  1        Acanthastrea brevis     3
#>  2      Acanthastrea echinata     4
#>  3     Acanthastrea hemprichi     6
#>  4 Acanthastrea ishigakiensis     8
#>  5     Acanthastrea regularis    12
#>  6  Acanthastrea rotundoflora    13
#>  7   Acanthastrea subechinata    14
#>  8     Acropora abrolhosensis    16
#>  9      Acropora abrotanoides    17
#> 10           Acropora aculeus    18
#> # ... with 1,538 more rows
```

Get data by taxon


```r
coral_taxa(80)
#> # A tibble: 3,540 x 25
#>    observation_id access user_id specie_id         specie_name location_id
#>             <int>  <int>   <int>     <int>               <chr>       <int>
#>  1         157133      1      10        80 Acropora hyacinthus           1
#>  2         156961      1      14        80 Acropora hyacinthus         409
#>  3           5781      1       1        80 Acropora hyacinthus           1
#>  4         156610      1       2        80 Acropora hyacinthus         500
#>  5         158118      1      10        80 Acropora hyacinthus         409
#>  6         119211      1      49        80 Acropora hyacinthus           1
#>  7         158211      1      10        80 Acropora hyacinthus         413
#>  8          90294      1      15        80 Acropora hyacinthus         341
#>  9          90294      1      15        80 Acropora hyacinthus         341
#> 10          90294      1      15        80 Acropora hyacinthus         341
#> # ... with 3,530 more rows, and 19 more variables: location_name <chr>,
#> #   latitude <dbl>, longitude <dbl>, resource_id <int>,
#> #   resource_secondary_id <int>, measurement_id <int>, trait_id <int>,
#> #   trait_name <chr>, standard_id <int>, standard_unit <chr>,
#> #   methodology_id <int>, methodology_name <chr>, value <chr>,
#> #   value_type <chr>, precision <dbl>, precision_type <chr>,
#> #   precision_upper <dbl>, replicates <int>, notes <chr>
```

## Birdlife International

Habitat data


```r
birdlife_habitat(22721692)
#>         id Habitat (level 1)                  Habitat (level 2) Importance
#> 1 22721692            Forest           Subtropical/Tropical Dry   suitable
#> 2 22721692            Forest Subtropical/Tropical Moist Montane      major
#> 3 22721692            Forest                          Temperate   suitable
#> 4 22721692         Shrubland Subtropical/Tropical High Altitude   suitable
#>     Occurrence
#> 1     breeding
#> 2 non-breeding
#> 3     breeding
#> 4     breeding
```

## Contributors

* [Scott Chamberlain](https://github.com/ropensci/sckott)
* [Zachary Foster](https://github.com/ropensci/zachary-foster)
* [Ignasi Bartomeus](https://github.com/ropensci/ibartomeus)
* [David LeBauer](https://github.com/ropensci/dlebauer)
* [David Harris](https://github.com/ropensci/davharris)
* [Rupert Collins](https://github.com/ropensci/boopsboops)

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/traits/issues).
* License: MIT
* Get citation information for `traits` in R doing `citation(package = 'traits')`
* Please note that this project is released with a [Contributor Code of Conduct](https://github.com/ropensci/traits/blob/master/CODE_OF_CONDUCT.md).
By participating in this project you agree to abide by its terms.

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
