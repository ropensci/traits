<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{BETYdb Tutorial}
%\VignetteEncoding{UTF-8}
-->



[BETYdb](https://www.betydb.org/) is the _Biofuel Ecophysiological Traits and Yields Database_. You can get many different types of data from this database, including trait data. 

Function setup: All functions are prefixed with `betydb_`. Plural function names like `betydb_traits()` accept parameters and always give back a data.frame, while singlur function names like `betydb_trait()` accept an ID and give back a list. 

The idea with the functions with plural names is to search for either traits, species, etc., and with the singular function names to get data by one or more IDs.

## Load traits


```r
library("traits")
```

## Traits

Get trait data for _Miscanthus giganteus_


```r
out <- betydb_search(query = "Switchgrass Yield")
```

Summarise data from the output `data.frame`


```r
library("dplyr")
out %>%
  group_by(id) %>%
  summarise(mean_result = mean(as.numeric(mean), na.rm = TRUE)) %>%
  arrange(desc(mean_result))
```

```
## # A tibble: 449 x 2
##       id mean_result
##    <int>       <dbl>
##  1  1666       27.36
##  2 16845       27.00
##  3  1669       26.36
##  4 16518       26.00
##  5  1663       25.35
##  6 16742       25.00
##  7  1594       24.78
##  8  1674       22.71
##  9  1606       22.54
## 10  1665       22.46
## # ... with 439 more rows
```

Single trait


```r
betydb_trait(id = 10)
```

```
## $description
## [1] "Leaf Percent Nitrogen"
## 
## $id
## [1] 10
## 
## $max
## [1] "10"
## 
## $min
## [1] "0.02"
## 
## $name
## [1] "leafN"
## 
## $notes
## [1] ""
## 
## $units
## [1] "percent"
## 
## $updated_at
## [1] "2011-06-06T09:40:42-05:00"
```

## Species

Single species, _Acacia karroothorn_


```r
betydb_specie(id = 10)
```

```
## $acceptedsymbol
## [1] "ACKA2"
## 
## $commonname
## [1] "karroothorn"
## 
## $genus
## [1] "Acacia"
## 
## $id
## [1] 10
## 
## $notes
## [1] ""
## 
## $scientificname
## [1] "Acacia karroo"
## 
## $species
## [1] "karroo"
## 
## $updated_at
## [1] "2011-03-01T15:02:25-06:00"
```

## Citations

Get citatons searching for _Miscanthus_


```r
betydb_citation(10)
```

```
## $author
## [1] "Casler"
## 
## $doi
## [1] "10.2135/cropsci2003.2226"
## 
## $id
## [1] 10
## 
## $journal
## [1] "Crop Science"
## 
## $pdf
## [1] "http://crop.scijournals.org/cgi/reprint/43/6/2226.pdf"
## 
## $pg
## [1] "2226–2233"
## 
## $title
## [1] "Cultivar X environment interactions in switchgrass"
## 
## $url
## [1] "http://crop.scijournals.org/cgi/content/abstract/43/6/2226"
## 
## $vol
## [1] 43
## 
## $year
## [1] 2003
```

## Sites

Single site


```r
betydb_site(id = 1)
```

```
## $city
## [1] "Aliartos"
## 
## $country
## [1] "GR"
## 
## $geometry
## [1] "POINT (23.17 38.37 114.0)"
## 
## $greenhouse
## [1] FALSE
## 
## $notes
## [1] ""
## 
## $sitename
## [1] "Aliartos"
## 
## $state
## [1] ""
## 
## $time_zone
## [1] "Europe/Athens"
```
