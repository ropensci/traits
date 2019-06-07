traits
=======



[![cran checks](https://cranchecks.info/badges/worst/traits)](https://cranchecks.info/pkgs/traits)
[![Build Status](https://travis-ci.org/ropensci/traits.svg?branch=master)](https://travis-ci.org/ropensci/traits)
[![codecov.io](https://codecov.io/github/ropensci/traits/coverage.svg?branch=master)](https://codecov.io/github/ropensci/traits?branch=master)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/traits)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/traits)](https://CRAN.R-project.org/package=traits)

R client for various sources of species trait data.

What is a trait? A "trait" for the purposes of this package is broadly defined as an aspect of a species that can be described or measured, such as physical traits (size, length, height, color), behavioral traits (running speed, etc.), and even variables that make up the niche of the species (e.g., habitat).

Included in `traits` with the associated function prefix or function name:

<table>
<colgroup>
<col style="text-align:left;"/>
<col style="text-align:left;"/>
<col style="text-align:left;"/>
<col style="text-align:left;"/>
</colgroup>

<thead>
<tr>
  <th style="text-align:left;">Souce</th>
  <th style="text-align:left;">Function prefix</th>
  <th style="text-align:left;">Link</th>
</tr>
</thead>

<tbody>
<tr>
  <td style="text-align:left;">BETYdb</td>
  <td style="text-align:left;"><code>betydb_</code></td>
  <td style="text-align:left;">http://www.betydb.org</td>
</tr>
<tr>
  <td style="text-align:left;">NCBI</td>
  <td style="text-align:left;"><code>ncbi_</code></td>
  <td style="text-align:left;">http://www.ncbi.nlm.nih.gov/</td>
</tr>
<tr>
  <td style="text-align:left;">Encylopedia of Life</td>
  <td style="text-align:left;"><code>traitbank_</code></td>
  <td style="text-align:left;">https://github.com/EOL/eol_website/blob/master/doc/api.md</td>
</tr>
<tr>
  <td style="text-align:left;">Coral Traits Database</td>
  <td style="text-align:left;"><code>coral_</code></td>
  <td style="text-align:left;">https://coraltraits.org/</td>
</tr>
<tr>
  <td style="text-align:left;">Birdlife International</td>
  <td style="text-align:left;"><code>birdlife_</code></td>
  <td style="text-align:left;">https://www.birdlife.org/</td>
</tr>
<tr>
  <td style="text-align:left;">LEDA Traitbase</td>
  <td style="text-align:left;"><code>leda_</code></td>
  <td style="text-align:left;"></td>
</tr>
<tr>
  <td style="text-align:left;">USDA Plants Database</td>
  <td style="text-align:left;"><code>tr_usda</code></td>
  <td style="text-align:left;"></td>
</tr>
<tr>
  <td style="text-align:left;">Zanne et al. plant dataset</td>
  <td style="text-align:left;"><code>tr_zanne</code></td>
  <td style="text-align:left;"></td>
</tr>
<tr>
  <td style="text-align:left;">Amniote life history dataset</td>
  <td style="text-align:left;"><code>tr_ernest</code></td>
  <td style="text-align:left;"></td>
</tr>
</tbody>
</table>


Talk to us on the [issues page](https://github.com/ropensci/traits/issues) if you know of a source of traits data with an API, and we'll see about including it.

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
#>    checked result_type    id citation_id site_id treatment_id sitename
#>      <int> <chr>       <int>       <int>   <int>        <int> <chr>   
#>  1       1 traits      39217         430     645         1342 ""      
#>  2       1 traits      39218         430     645         1343 ""      
#>  3       1 traits      39219         430     645         1344 ""      
#>  4       1 traits      39220         430     645         1345 ""      
#>  5       1 traits      25405          51      NA            1 <NA>    
#>  6       1 traits      39213         430     645         1342 ""      
#>  7       1 traits      39214         430     645         1343 ""      
#>  8       1 traits      39215         430     645         1344 ""      
#>  9       1 traits      39216         430     645         1345 ""      
#> 10       1 traits      39221         430     645         1342 ""      
#> 11       1 traits      39222         430     645         1343 ""      
#> 12       1 traits      39223         430     645         1344 ""      
#> 13       1 traits      39224         430     645         1345 ""      
#> 14       1 traits      37519         381     602         1220 <NA>    
#> # … with 29 more variables: city <chr>, lat <dbl>, lon <dbl>,
#> #   scientificname <chr>, commonname <chr>, genus <chr>, species_id <int>,
#> #   cultivar_id <int>, author <chr>, citation_year <int>, treatment <chr>,
#> #   date <chr>, time <chr>, raw_date <chr>, month <int>, year <int>,
#> #   dateloc <chr>, trait <chr>, trait_description <chr>, mean <dbl>,
#> #   units <chr>, n <int>, statname <chr>, stat <dbl>, notes <chr>,
#> #   access_level <int>, cultivar <chr>, entity <lgl>, method_name <lgl>
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
#> # Groups:   scientificname [4]
#>   scientificname                  trait  mean   min   max     n
#>   <chr>                           <chr> <dbl> <dbl> <dbl> <int>
#> 1 Salix                           Vcmax  65    65    65       1
#> 2 Salix dasyclados                Vcmax  46.1  34.3  56.7     4
#> 3 Salix sachalinensis × miyabeana Vcmax  79.3  79.3  79.3     1
#> 4 Salix viminalis                 Vcmax  43.0  20.0  61.3     8
```

## EOL's traitbank trait data


```r
traitbank(query = "MATCH (n:Trait) RETURN n LIMIT 1;")
#> $columns
#> [1] "n"
#> 
#> $data
#> $data[[1]]
#>   metadata.id metadata.labels
#> 1    20280619           Trait
#>                                                                                     paged_traverse
#> 1 http://10.252.248.44:7474/db/data/node/20280619/paged/traverse/{returnType}{?pageSize,leaseTime}
#>                                              outgoing_relationships
#> 1 http://10.252.248.44:7474/db/data/node/20280619/relationships/out
#>                                                        outgoing_typed_relationships
#> 1 http://10.252.248.44:7474/db/data/node/20280619/relationships/out/{-list|&|types}
#>                                                   labels
#> 1 http://10.252.248.44:7474/db/data/node/20280619/labels
#>                                             create_relationship
#> 1 http://10.252.248.44:7474/db/data/node/20280619/relationships
#>                                                                traverse
#> 1 http://10.252.248.44:7474/db/data/node/20280619/traverse/{returnType}
#>                                                   all_relationships
#> 1 http://10.252.248.44:7474/db/data/node/20280619/relationships/all
#>                                                             all_typed_relationships
#> 1 http://10.252.248.44:7474/db/data/node/20280619/relationships/all/{-list|&|types}
#>                                                           property
#> 1 http://10.252.248.44:7474/db/data/node/20280619/properties/{key}
#>                                              self
#> 1 http://10.252.248.44:7474/db/data/node/20280619
#>                                             incoming_relationships
#> 1 http://10.252.248.44:7474/db/data/node/20280619/relationships/in
#>                                                   properties
#> 1 http://10.252.248.44:7474/db/data/node/20280619/properties
#>                                                       incoming_typed_relationships
#> 1 http://10.252.248.44:7474/db/data/node/20280619/relationships/in/{-list|&|types}
#>     data.eol_pk data.resource_pk
#> 1 R74-PK5014587           110690
#>                                data.scientific_name
#> 1 <i>Adenopodia floribunda</i> (Kleinhoonte) Brenan
#>                                data.source
#> 1 http://www.pnas.org/content/114/40/10695
#>                                                                   data.literal
#> 1 http://eol.org/schema/terms/Tropical_and_subtropical_moist_broadleaf_forests
```

## Coral

Get the species list and their ids


```r
coral_species()
#> # A tibble: 1,548 x 2
#>    name                       id   
#>    <chr>                      <chr>
#>  1 Acanthastrea brevis        3    
#>  2 Acanthastrea echinata      4    
#>  3 Acanthastrea hemprichi     6    
#>  4 Acanthastrea ishigakiensis 8    
#>  5 Acanthastrea regularis     12   
#>  6 Acanthastrea rotundoflora  13   
#>  7 Acanthastrea subechinata   14   
#>  8 Acropora abrolhosensis     16   
#>  9 Acropora abrotanoides      17   
#> 10 Acropora aculeus           18   
#> # … with 1,538 more rows
```

Get data by taxon


```r
coral_taxa(80)
#> # A tibble: 3,540 x 25
#>    observation_id access user_id specie_id specie_name location_id
#>             <int>  <int>   <int>     <int> <chr>             <int>
#>  1         157133      1      10        80 Acropora h…           1
#>  2         156961      1      14        80 Acropora h…         409
#>  3           5781      1       1        80 Acropora h…           1
#>  4         156610      1       2        80 Acropora h…         500
#>  5         158118      1      10        80 Acropora h…         409
#>  6         119211      1      49        80 Acropora h…           1
#>  7         158211      1      10        80 Acropora h…         413
#>  8          90294      1      15        80 Acropora h…         341
#>  9          90294      1      15        80 Acropora h…         341
#> 10          90294      1      15        80 Acropora h…         341
#> # … with 3,530 more rows, and 19 more variables: location_name <chr>,
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
#> 1 22721692            Forest           Subtropical/Tropical Dry      major
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

* [Scott Chamberlain](https://github.com/sckott)
* [Zachary Foster](https://github.com/zachary-foster)
* [Ignasi Bartomeus](https://github.com/ibartomeus)
* [David LeBauer](https://github.com/dlebauer)
* [David Harris](https://github.com/davharris)
* [Chris Black](https://github.com/infotroph)
* [Rupert Collins](https://github.com/boopsboops)

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/traits/issues).
* License: MIT
* Get citation information for `traits` in R doing `citation(package = 'traits')`
* Please note that this project is released with a [Contributor Code of Conduct](https://github.com/ropensci/traits/blob/master/CODE_OF_CONDUCT.md).
By participating in this project you agree to abide by its terms.

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
