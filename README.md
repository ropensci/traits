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
#> Error in betydb_http(url, args, key, user, pwd, ...): could not find function "GET"
```

Summarise data from the output `data.frame`


```r
library("dplyr")
out %>%
  group_by(specie_id) %>%
  summarise(mean_result = mean(as.numeric(mean), na.rm = TRUE)) %>%
  arrange(desc(mean_result))
#> Error in eval(expr, envir, enclos): object 'out' not found
```

Single trait


```r
bety_trait(id = 10)
#> Error in betydb_http(url, args, key, user, pwd, ...): could not find function "GET"
```

## Meta

* Please report any issues or bugs](https://github.com/ropensci/traits/issues).
* License: MIT
* Get citation information for `traits` in R doing `citation(package = 'traits')`

[![rofooter](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
