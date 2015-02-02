traits
=======



R client for various sources of species trait data.

To be included, with the associated function prefix:

* [Polytraits](http://polytraits.lifewatchgreece.eu/download-api) - `poly_` (_not in the package yet_)
* [BETYdb](http://www.betydb.org) - `bety_`
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
install.packages("devtools")
devtools::install_github("ropensci/traits")
```


```r
library("traits")
```

## BetyDB

Function setup: plural functions like `bety_traits()` accept parameters and always give back a data.frame, while singlur function names accept an ID and give back a list. 

### Traits

Get trait data for _Miscanthus giganteus_


```r
(out <- bety_traits(genus = "Miscanthus", species = "giganteus"))
#> Source: local data frame [12,335 x 28]
#> 
#>    access_level checked citation_id                created_at cultivar_id
#> 1             3       0         227 2010-09-27T14:06:06-05:00          NA
#> 2             3       0         229 2010-09-27T15:07:09-05:00          NA
#> 3             3       0         241 2010-09-30T14:32:08-05:00          NA
#> 4             3       0         241 2010-09-30T14:34:36-05:00          NA
#> 5             3       0         247 2010-10-04T10:40:12-05:00          NA
#> 6             3       0         248 2010-10-04T11:07:28-05:00          NA
#> 7             3       0         256 2010-10-06T11:37:20-05:00          NA
#> 8             3       0         256 2010-10-06T11:37:54-05:00          NA
#> 9             3       0         261 2010-10-07T13:37:31-05:00          NA
#> 10            4       1          42                        NA           3
#> ..          ...     ...         ...                       ...         ...
#> Variables not shown: date (chr), date_day (int), date_month (int),
#>   date_year (int), dateloc (chr), entity_id (int), id (int), mean (chr),
#>   method_id (int), n (int), notes (chr), site_id (int), specie_id (int),
#>   stat (chr), statname (chr), time (chr), time_hour (int), time_minute
#>   (int), timeloc (chr), treatment_id (int), updated_at (chr), user_id
#>   (int), variable_id (int)
```

Summarise data from the output `data.frame`


```r
library("dplyr")
out %>%
  group_by(specie_id) %>%
  summarise(mean_result = mean(as.numeric(mean), na.rm = TRUE)) %>%
  arrange(desc(mean_result))
#> Source: local data frame [768 x 2]
#> 
#>    specie_id  mean_result
#> 1       2869 2.486526e+09
#> 2        896 9.999990e+05
#> 3        756 8.062186e+03
#> 4       1156 7.465770e+03
#> 5       1150 7.391027e+03
#> 6       2953 2.084548e+03
#> 7      40977 5.070850e+02
#> 8        611 3.786462e+02
#> 9       2304 3.555000e+02
#> 10     12453 3.296458e+02
#> ..       ...          ...
```

Single trait


```r
bety_trait(id = 10)
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

* Please report any issues or bugs](https://github.com/ropensci/traits/issues).
* License: MIT
* Get citation information for `traits` in R doing `citation(package = 'traits')`

[![rofooter](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
