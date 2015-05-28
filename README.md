traits
=======



[![Build Status](https://travis-ci.org/ropensci/traits.svg?branch=master)](https://travis-ci.org/ropensci/traits)

R client for various sources of species trait data.

To be included, with the associated function prefix:

* [Polytraits](http://polytraits.lifewatchgreece.eu/download-api) - `poly_` (_not in the package yet_)
* [BETYdb](http://www.betydb.org) - `betydb_`
* [National Center for Biotechnology Information - NCBI](http://www.ncbi.nlm.nih.gov/) - `ncbi_`
* [Global Invasive Species Database - GISD](http://www.issg.org/database/welcome/) - `g_`
* [Encyclopedia of Life Invasive Species](link) - `eol_`
* [Encyclopedia of Life Traitbank](link) - `traitbank_`
* [Coral Traits Database](http://coraltraits.org/) - `coral_`
* ...

Talk to us on the [issues page](https://github.com/ropensci/traits/issues) if you know of a source of traits data with an API, and we'll see about including it.

For more info on Betydb, see [the vignette](vignettes/betydb.Rmd).

## Installation


```r
devtools::install_github("ropensci/traits")
```


```r
library("traits")
```

## BetyDB

Function setup: plural functions like `betydb_traits()` accept parameters and always give back a data.frame, while singlur function names accept an ID and give back a list. 

### Traits

Get trait data for Willow (_Salix_ spp.)


```r
(out <- betydb_search("Salix"))
#> Source: local data frame [949 x 30]
#> 
#>    access_level        author citation_id citation_year         city
#> 1             4 Matthes-Sears         280          1988 Brooks Range
#> 2             4 Matthes-Sears         280          1988 Brooks Range
#> 3             4 Matthes-Sears         280          1988 Brooks Range
#> 4             4 Matthes-Sears         280          1988 Brooks Range
#> 5             4 Matthes-Sears         280          1988 Brooks Range
#> 6             4 Matthes-Sears         280          1988 Brooks Range
#> 7             4 Matthes-Sears         280          1988 Brooks Range
#> 8             4 Matthes-Sears         280          1988 Brooks Range
#> 9             4 Matthes-Sears         280          1988 Brooks Range
#> 10            4 Matthes-Sears         280          1988 Brooks Range
#> ..          ...           ...         ...           ...          ...
#> Variables not shown: commonname (chr), cultivar_id (int), date (chr),
#>   dateloc (chr), genus (chr), id (int), lat (dbl), lon (dbl), mean (chr),
#>   month (dbl), n (int), notes (chr), result_type (chr), scientificname
#>   (chr), site_id (int), sitename (chr), species_id (int), stat (chr),
#>   statname (chr), trait (chr), trait_description (chr), treatment (chr),
#>   treatment_id (int), units (chr), year (dbl)
# ~= (out <- betydb_search("willow"))
```

Summarise data from the output `data.frame`


```r
library("dplyr")
out %>%
  group_by(scientificname, trait) %>%
      mutate(.mean = as.numeric(mean)) %>%
          summarise(mean = round(mean(.mean, na.rm = TRUE), 2),
                    min = round(min(.mean, na.rm = TRUE), 2),
                    max = round(max(.mean, na.rm = TRUE), 2),
                    n = length(n))
#> Source: local data frame [85 x 6]
#> Groups: scientificname
#> 
#>      scientificname              trait   mean    min    max  n
#> 1             Salix             Ayield  10.25   0.50  68.94 47
#> 2             Salix               Jmax 146.00 146.00 146.00  1
#> 3             Salix                SLA  16.10  10.00  26.40 51
#> 4             Salix              Vcmax  65.00  65.00  65.00  1
#> 5             Salix              leafN   2.37   1.15   4.23 37
#> 6             Salix quantum_efficiency   0.04   0.04   0.05  2
#> 7      Salix caprea             Ayield  57.73  14.30  83.30  3
#> 8       Salix clone                SLA  12.90  11.22  14.83 29
#> 9       Salix clone              leafN   1.89   1.39   2.74 29
#> 10 Salix dasyclados             Ayield  13.10   1.20  48.17 14
#> ..              ...                ...    ...    ...    ... ..
```

Single trait


```r
betydb_trait(id = 10)
#> $created_at
#> NULL
#> 
#> $description
#> [1] "Leaf Percent Nitrogen"
#> 
#> $id
#> [1] 10
#> 
#> $label
#> NULL
#> 
#> $max
#> [1] "10"
#> 
#> $min
#> [1] "0.02"
#> 
#> $name
#> [1] "leafN"
#> 
#> $notes
#> NULL
#> 
#> $standard_name
#> NULL
#> 
#> $standard_units
#> NULL
#> 
#> $units
#> [1] "percent"
#> 
#> $updated_at
#> [1] "2011-06-06T09:40:42-05:00"
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/traits/issues).
* License: MIT
* Get citation information for `traits` in R doing `citation(package = 'traits')`

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
