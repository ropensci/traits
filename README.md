traits
=======



[![Build Status](https://travis-ci.org/ropensci/traits.svg?branch=master)](https://travis-ci.org/ropensci/traits)
[![codecov.io](https://codecov.io/github/ropensci/traits/coverage.svg?branch=master)](https://codecov.io/github/ropensci/traits?branch=master)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/traits)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/traits)](http://cran.rstudio.com/web/packages/traits)

R client for various sources of species trait data.

Included in `traits` with the associated function prefix:

* [BETYdb](http://www.betydb.org) - `betydb_`
* [National Center for Biotechnology Information - NCBI](http://www.ncbi.nlm.nih.gov/) - `ncbi_`
* [Global Invasive Species Database - GISD](http://www.issg.org/database/welcome/) - `g_`
* [Encyclopedia of Life Invasive Species](link) - `eol_`
* [Encyclopedia of Life Traitbank](link) - `traitbank_`
* [Coral Traits Database](http://coraltraits.org/) - `coral_`
* [Flora Europaea](http://rbg-web2.rbge.org.uk/FE/fe.html) - `fe_`
* [Birdlife International](http://rbg-web2.rbge.org.uk/FE/fe.html) - `birdlife_`
* LEDA Traitbase (http://www.leda-traitbase.org/LEDAportal/index.jsp) - `leda_`
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

## BetyDB

Get trait data for Willow (_Salix_ spp.)


```r
(salix <- betydb_search("Salix Vcmax"))
#> Source: local data frame [14 x 30]
#> 
#>    access_level       author citation_id citation_year  city    commonname
#>           (int)        (chr)       (int)         (int) (chr)         (chr)
#> 1             4       Merilo         430          2005 Saare basket willow
#> 2             4       Merilo         430          2005 Saare basket willow
#> 3             4       Merilo         430          2005 Saare basket willow
#> 4             4       Merilo         430          2005 Saare basket willow
#> 5             4 Wullschleger          51          1993    NA        willow
#> 6             4       Merilo         430          2005 Saare basket willow
#> 7             4       Merilo         430          2005 Saare basket willow
#> 8             4       Merilo         430          2005 Saare basket willow
#> 9             4       Merilo         430          2005 Saare basket willow
#> 10            4       Merilo         430          2005 Saare        willow
#> 11            4       Merilo         430          2005 Saare        willow
#> 12            4       Merilo         430          2005 Saare        willow
#> 13            4       Merilo         430          2005 Saare        willow
#> 14            4         Wang         381          2010    NA              
#> Variables not shown: cultivar_id (int), date (chr), dateloc (chr), genus
#>   (chr), id (int), lat (dbl), lon (dbl), mean (chr), month (dbl), n (int),
#>   notes (chr), result_type (chr), scientificname (chr), site_id (int),
#>   sitename (chr), species_id (int), stat (chr), statname (chr), trait
#>   (chr), trait_description (chr), treatment (chr), treatment_id (int),
#>   units (chr), year (dbl)
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
#> Source: local data frame [4 x 6]
#> Groups: scientificname [?]
#> 
#>                    scientificname trait  mean   min   max     n
#>                             (chr) (chr) (dbl) (dbl) (dbl) (int)
#> 1                           Salix Vcmax 65.00 65.00 65.00     1
#> 2                Salix dasyclados Vcmax 46.08 34.30 56.68     4
#> 3 Salix sachalinensis × miyabeana Vcmax 79.28 79.28 79.28     1
#> 4                 Salix viminalis Vcmax 43.04 19.99 61.29     8
```

## GISD invasive species data


```r
sp <- c("Carpobrotus edulis", "Rosmarinus officinalis")
g_invasive(sp)
#>                  species
#> 1     Carpobrotus edulis
#> 2 Rosmarinus officinalis
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               status
#> 1 Carpobrotus edulis is a mat-forming succulent native to South Africa which is invasive primarily in coastal habitats in many parts of the world. It was often introduced as an ornamental plant or used for planting along roadsides, from which it has spread to become invasive. Its main impacts are smothering, reduced regeneration of native flora and changes to soil pH and nutrient regimes.;  (succulent); Common Names: balsamo, Cape fig, figue marine, freeway iceplant, ghaukum, ghoenavy, highway ice plant, higo del Cabo, higo marino, Hottentosvy, hottentot fig, Hottentottenfeige, iceplant, ikhambi-lamabulawo, Kaapsevy, patata frita, perdevy, pigface, rankvy, sea fig, sour fig, suurvy, umgongozi, vyerank; Synonyms: Mesembryanthemum edule L., Mesembryanthemum edulis
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        Not in GISD
```

Or as simplified output


```r
g_invasive(sp, simplify = TRUE)
#>                  species      status
#> 1     Carpobrotus edulis    Invasive
#> 2 Rosmarinus officinalis Not in GISD
```

## EOL invasive species data


```r
eol_invasive_('Brassica oleracea', dataset = 'gisd')
#>       searched_name              name eol_object_id   db
#> 1 Brassica oleracea Brassica oleracea           NaN gisd
```

Another example, with more species, and from


```r
eol_invasive_(c('Lymantria dispar','Cygnus olor','Hydrilla verticillata','Pinus concolor'),
              dataset = 'i3n')
#>           searched_name                                name eol_object_id
#> 1      Lymantria dispar                    Lymantria dispar           NaN
#> 2           Cygnus olor           Cygnus olor (Gmelin 1789)        913227
#> 3 Hydrilla verticillata Hydrilla verticillata (L. f.) Royle       1088921
#> 4        Pinus concolor                      Pinus concolor           NaN
#>    db
#> 1 i3n
#> 2 i3n
#> 3 i3n
#> 4 i3n
```

## EOL's traitbank trait data

Searching for _Mesoplodon bidens_, page id `328566`


```r
res <- traitbank(846827)
res$graph %>%
  select(`dwc:measurementtype.@id`, `dwc:measurementtype.rdfs:label.en`) %>%
  filter(!is.na(`dwc:measurementtype.rdfs:label.en`))
#> Source: local data frame [6 x 2]
#> 
#>                              dwc:measurementtype.@id
#>                                                (chr)
#> 1 http://eol.org/schema/terms/TypeSpecimenRepository
#> 2 http://eol.org/schema/terms/TypeSpecimenRepository
#> 3                http://eol.org/schema/terms/Habitat
#> 4                http://eol.org/schema/terms/Habitat
#> 5       http://eol.org/schema/terms/ExtinctionStatus
#> 6       http://eol.org/schema/terms/ExtinctionStatus
#> Variables not shown: dwc:measurementtype.rdfs:label.en (chr)
```

## Coral

Get the species list and their ids


```r
coral_species()
#> Source: local data frame [1,547 x 2]
#> 
#>                          name    id
#>                         (chr) (chr)
#> 1         Acanthastrea brevis     3
#> 2       Acanthastrea echinata     4
#> 3      Acanthastrea hemprichi     6
#> 4  Acanthastrea ishigakiensis     8
#> 5      Acanthastrea regularis    12
#> 6   Acanthastrea rotundoflora    13
#> 7    Acanthastrea subechinata    14
#> 8      Acropora abrolhosensis    16
#> 9       Acropora abrotanoides    17
#> 10           Acropora aculeus    18
#> ..                        ...   ...
```

Get data by taxon


```r
coral_taxa(80)
#> Source: local data frame [3,121 x 25]
#> 
#>    observation_id access user_id specie_id         specie_name location_id
#>             (int)  (int)   (int)     (int)               (chr)       (int)
#> 1          119211      1      49        80 Acropora hyacinthus           1
#> 2          109330      1       2        80 Acropora hyacinthus           1
#> 3           88793      1      14        80 Acropora hyacinthus           0
#> 4          115791      1      10        80 Acropora hyacinthus           1
#> 5          115792      1      10        80 Acropora hyacinthus           1
#> 6            5696      1       2        80 Acropora hyacinthus           1
#> 7            5741      1       1        80 Acropora hyacinthus           1
#> 8            5751      1       1        80 Acropora hyacinthus           1
#> 9            5773      1       5        80 Acropora hyacinthus           1
#> 10           5766      1       1        80 Acropora hyacinthus           1
#> ..            ...    ...     ...       ...                 ...         ...
#> Variables not shown: location_name (chr), latitude (dbl), longitude (dbl),
#>   resource_id (int), resource_secondary_id (int), measurement_id (int),
#>   trait_id (int), trait_name (chr), standard_id (int), standard_unit
#>   (chr), methodology_id (int), methodology_name (chr), value (chr),
#>   value_type (chr), precision (dbl), precision_type (chr), precision_upper
#>   (dbl), replicates (int), notes (chr)
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

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/traits/issues).
* License: MIT
* Get citation information for `traits` in R doing `citation(package = 'traits')`

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
