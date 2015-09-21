<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{traits Intro}
%\VignetteEncoding{UTF-8}
-->



`traits` introduction
=====================


```r
library("traits")
```

## BetyDB

Get trait data for Willow (_Salix_ spp.)


```r
(salix <- betydb_search("Salix Vcmax"))
#> Source: local data frame [14 x 30]
#> 
#>    access_level       author citation_id citation_year  city    commonname
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
#> Groups: scientificname
#> 
#>                    scientificname trait  mean   min   max n
#> 1                           Salix Vcmax 65.00 65.00 65.00 1
#> 2                Salix dasyclados Vcmax 46.08 34.30 56.68 4
#> 3 Salix sachalinensis × miyabeana Vcmax 79.28 79.28 79.28 1
#> 4                 Salix viminalis Vcmax 43.04 19.99 61.29 8
```

## NCBI sequence data

Get sequences by id


```r
ncbi_byid(ids = "360040093", format = "fasta")
#>                  taxon
#> 1 Eristalis transversa
#>                                                                                                              gene_desc
#> 1  Eristalis transversa voucher CNC:Diptera:102013 cytochrome oxidase subunit 1 (COI) gene, partial cds; mitochondrial
#>       gi_no     acc_no length
#> 1 360040093 JN991986.1    658
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             sequence
#> 1 TACTTTATATTTTGTATTTGGAACATGAGCGGGTATAGTAGGAACTTCATTAAGAATTTTAATTCGAGCTGAATTAGGTCATCCAGGTGCATTAATTGGTGATGATCAAATTTATAATGTTATTGTAACAGCTCATGCTTTTGTTATAATTTTTTTTATAGTAATACCTATTATAATTGGAGGATTTGGAAATTGATTAGTACCACTTATATTAGGAGCTCCAGATATAGCATTCCCTCGAATAAATAATATAAGTTTCTGATTATTACCTCCTTCTTTAACTCTATTATTAGTAAGAAGTATAGTAGAAAATGGGGCTGGAACAGGATGAACAGTTTATCCTCCATTATCAAGTAATATTGCACATGGAGGAGCCTCAGTTGATTTAGCAATTTTTTCACTTCACTTATCAGGAATATCATCTATTTTAGGTGCAGTAAATTTTATTACAACAGTTATTAATATACGATCAACAGGAATTACTTATGATCGTATACCTTTATTTGTTTGATCTGTTGCTATTACAGCTTTATTATTATTATTATCATTACCAGTACTAGCAGGAGCTATTACAATATTATTAACTGATCGAAATTTAAATACATCATTCTTTGATCCAGCAGGAGGAGGAGACCCTATCCTGTACCAACACTTATTC
```

Get sequences searching by taxonomic name


```r
out <- ncbi_searcher(taxa = "Umbra limi", seqrange = "1:2000")
head(out)
#>        taxon length
#> 1 Umbra limi    412
#> 2 Umbra limi    315
#> 3 Umbra limi    200
#> 4 Umbra limi    333
#> 5 Umbra limi    242
#> 6 Umbra limi    386
#>                                                                                   gene_desc
#> 1 tRNA-Glu gene, partial sequence; and cytochrome b (CYTB) gene, partial cds; mitochondrial
#> 2                                   16S ribosomal RNA gene, partial sequence; mitochondrial
#> 3                                   16S ribosomal RNA gene, partial sequence; mitochondrial
#> 4                                   16S ribosomal RNA gene, partial sequence; mitochondrial
#> 5                                   12S ribosomal RNA gene, partial sequence; mitochondrial
#> 6                                   12S ribosomal RNA gene, partial sequence; mitochondrial
#>     acc_no     gi_no
#> 1 KM523322 725542537
#> 2 KM435059 725542420
#> 3 KM434991 725542361
#> 4 KM282516 725542294
#> 5 KM282453 725542240
#> 6 KM273864 725542182
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
res <- traitbank(trait = 328566)
res$graph %>% 
  select(dwc.measurementtype..id, dwc.measurementtype.rdfs.label.en, dwc.measurementvalue) %>% 
  filter(!is.na(dwc.measurementvalue))
#> Source: local data frame [59 x 3]
#> 
#>                 dwc.measurementtype..id dwc.measurementtype.rdfs.label.en
#> 1      http://iucn.org/population_trend                  population trend
#> 2  http://rs.tdwg.org/dwc/terms/habitat                           habitat
#> 3  http://rs.tdwg.org/dwc/terms/habitat                           habitat
#> 4  http://rs.tdwg.org/dwc/terms/habitat                           habitat
#> 5  http://rs.tdwg.org/dwc/terms/habitat                           habitat
#> 6  http://rs.tdwg.org/dwc/terms/habitat                           habitat
#> 7  http://rs.tdwg.org/dwc/terms/habitat                           habitat
#> 8  http://rs.tdwg.org/dwc/terms/habitat                           habitat
#> 9  http://rs.tdwg.org/dwc/terms/habitat                           habitat
#> 10 http://rs.tdwg.org/dwc/terms/habitat                           habitat
#> ..                                  ...                               ...
#> Variables not shown: dwc.measurementvalue (chr)
```

## Coral

Get the species list and their ids


```r
coral_species()
#> Source: local data frame [1,547 x 2]
#> 
#>                          name id
#> 1         Acanthastrea brevis  3
#> 2       Acanthastrea echinata  4
#> 3      Acanthastrea hemprichi  6
#> 4  Acanthastrea ishigakiensis  8
#> 5      Acanthastrea regularis 12
#> 6   Acanthastrea rotundoflora 13
#> 7    Acanthastrea subechinata 14
#> 8      Acropora abrolhosensis 16
#> 9       Acropora abrotanoides 17
#> 10           Acropora aculeus 18
#> ..                        ... ..
```

Get data by taxon


```r
coral_taxa(80)
#> Source: local data frame [3,084 x 25]
#> 
#>    observation_id access user_id specie_id         specie_name location_id
#> 1          109330      1       2        80 Acropora hyacinthus           1
#> 2           88793      1      14        80 Acropora hyacinthus           0
#> 3          115791      1      10        80 Acropora hyacinthus           1
#> 4          115792      1      10        80 Acropora hyacinthus           1
#> 5            5694      1       2        80 Acropora hyacinthus           1
#> 6            5696      1       2        80 Acropora hyacinthus           1
#> 7            5741      1       1        80 Acropora hyacinthus           1
#> 8            5751      1       1        80 Acropora hyacinthus           1
#> 9            5787      1       1        80 Acropora hyacinthus           1
#> 10           5766      1       1        80 Acropora hyacinthus           1
#> ..            ...    ...     ...       ...                 ...         ...
#> Variables not shown: location_name (chr), latitude (dbl), longitude (dbl),
#>   resource_id (int), resource_secondary_id (int), measurement_id (int),
#>   trait_id (int), trait_name (chr), standard_id (int), standard_unit
#>   (chr), methodology_id (int), methodology_name (chr), value (chr),
#>   value_type (chr), precision (lgl), precision_type (lgl), precision_upper
#>   (lgl), replicates (lgl), notes (lgl)
```

Get data by trait


```r
coral_traits(105)
#> Source: local data frame [1,491 x 25]
#> 
#>    observation_id access user_id specie_id                specie_name
#> 1             155      1       8         3        Acanthastrea brevis
#> 2             236      1       1         4      Acanthastrea echinata
#> 3             364      1       8         6     Acanthastrea hemprichi
#> 4             495      1       1         8 Acanthastrea ishigakiensis
#> 5             738      1       8        12     Acanthastrea regularis
#> 6             804      1       8        13  Acanthastrea rotundoflora
#> 7             865      1       1        14   Acanthastrea subechinata
#> 8             981      1       8        16     Acropora abrolhosensis
#> 9            1061      1       8        17      Acropora abrotanoides
#> 10          90549      1       8        18           Acropora aculeus
#> ..            ...    ...     ...       ...                        ...
#> Variables not shown: location_id (int), location_name (chr), latitude
#>   (lgl), longitude (lgl), resource_id (int), resource_secondary_id (lgl),
#>   measurement_id (int), trait_id (int), trait_name (chr), standard_id
#>   (int), standard_unit (chr), methodology_id (lgl), methodology_name
#>   (lgl), value (chr), value_type (chr), precision (lgl), precision_type
#>   (lgl), precision_upper (lgl), replicates (lgl), notes (chr)
```

## Flora Europaea


```r
sp <- c("Lavandula stoechas", "Carpobrotus edulis", "Rhododendron ponticum",
        "Alkanna lutea", "Anchusa arvensis")
sapply(sp, fe_native, simplify = FALSE)
#> $`Lavandula stoechas`
#> $`Lavandula stoechas`$native
#>  [1] "Islas_Baleares" "Corse"          "Kriti"          "France"        
#>  [5] "Greece"         "Spain"          "Italy"          "Portugal"      
#>  [9] "Sardegna"       "Sicilia"        "Turkey"        
#> 
#> $`Lavandula stoechas`$exotic
#> [1] NA
#> 
#> $`Lavandula stoechas`$status_doubtful
#> [1] NA
#> 
#> $`Lavandula stoechas`$occurrence_doubtful
#> [1] NA
#> 
#> $`Lavandula stoechas`$extinct
#> [1] NA
#> 
#> 
#> $`Carpobrotus edulis`
#> $`Carpobrotus edulis`$native
#> [1] NA
#> 
#> $`Carpobrotus edulis`$exotic
#>  [1] "Albania"        "Azores"         "Belgium"        "Islas_Baleares"
#>  [5] "Britain"        "Corse"          "France"         "Greece"        
#>  [9] "Ireland"        "Spain"          "Italy"          "Portugal"      
#> [13] "Sicilia"       
#> 
#> $`Carpobrotus edulis`$status_doubtful
#> [1] NA
#> 
#> $`Carpobrotus edulis`$occurrence_doubtful
#> [1] NA
#> 
#> $`Carpobrotus edulis`$extinct
#> [1] NA
#> 
#> 
#> $`Rhododendron ponticum`
#> $`Rhododendron ponticum`$native
#> [1] "Bulgaria" "Spain"    "Portugal" "Turkey"  
#> 
#> $`Rhododendron ponticum`$exotic
#> [1] "Belgium" "Britain" "France"  "Ireland"
#> 
#> $`Rhododendron ponticum`$status_doubtful
#> [1] NA
#> 
#> $`Rhododendron ponticum`$occurrence_doubtful
#> [1] NA
#> 
#> $`Rhododendron ponticum`$extinct
#> [1] NA
#> 
#> 
#> $`Alkanna lutea`
#> $`Alkanna lutea`$native
#> [1] "Islas_Baleares" "Corse"          "France"         "Spain"         
#> [5] "Italy"          "Sardegna"      
#> 
#> $`Alkanna lutea`$exotic
#> [1] NA
#> 
#> $`Alkanna lutea`$status_doubtful
#> [1] NA
#> 
#> $`Alkanna lutea`$occurrence_doubtful
#> [1] "Portugal"
#> 
#> $`Alkanna lutea`$extinct
#> [1] NA
#> 
#> 
#> $`Anchusa arvensis`
#> $`Anchusa arvensis`$native
#>  [1] "Albania"                    "Austria"                   
#>  [3] "Belgium"                    "Islas_Baleares"            
#>  [5] "Britain"                    "Bulgaria"                  
#>  [7] "Corse"                      "Czechoslovakia"            
#>  [9] "Denmark"                    "Finland"                   
#> [11] "France"                     "Germany"                   
#> [13] "Greece"                     "Switzerland"               
#> [15] "Netherlands"                "Spain"                     
#> [17] "Hungary"                    "Italy"                     
#> [19] "Jugoslavia"                 "Portugal"                  
#> [21] "Norway"                     "Poland"                    
#> [23] "Romania"                    "USSR"                      
#> [25] "USSR_Northern_Division"     "USSR_Baltic_Division"      
#> [27] "USSR_Central_Division"      "USSR_South_western"        
#> [29] "USSR_Krym"                  "USSRSouth_eastern_Division"
#> [31] "Sicilia"                    "Sweden"                    
#> 
#> $`Anchusa arvensis`$exotic
#> [1] "Faroer"
#> 
#> $`Anchusa arvensis`$status_doubtful
#> [1] "Ireland"  "Sardegna"
#> 
#> $`Anchusa arvensis`$occurrence_doubtful
#> [1] NA
#> 
#> $`Anchusa arvensis`$extinct
#> [1] NA
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

Threats data


```r
birdlife_threats(22721692)
#>         id                                                  threat1
#> 1 22721692                                Agriculture & aquaculture
#> 2 22721692                                Agriculture & aquaculture
#> 3 22721692                                  Biological resource use
#> 4 22721692                               Energy production & mining
#> 5 22721692 Invasive and other problematic species, genes & diseases
#> 6 22721692                     Residential & commercial development
#>                                                                                  threat2
#> 1                            Annual & perennial non-timber crops / Agro-industry farming
#> 2                             Annual & perennial non-timber crops / Small-holder farming
#> 3 Logging & wood harvesting / Unintentional effects: (subsistence/small scale) [harvest]
#> 4                                                                     Mining & quarrying
#> 5                                                    Problematic native species/diseases
#> 6                                                                  Housing & urban areas
#>                                      stresses  timing             scope
#> 1 Ecosystem degradation, Ecosystem conversion Ongoing Majority (50-90%)
#> 2 Ecosystem degradation, Ecosystem conversion Ongoing Majority (50-90%)
#> 3                       Ecosystem degradation Ongoing Majority (50-90%)
#> 4 Ecosystem degradation, Ecosystem conversion Ongoing Majority (50-90%)
#> 5                           Species mortality Ongoing        Minority (
#> 6 Ecosystem degradation, Ecosystem conversion Ongoing        Minority (
#>                    severity           impact
#> 1 Slow, Significant Decline Medium Impact: 6
#> 2 Slow, Significant Decline Medium Impact: 6
#> 3 Slow, Significant Decline Medium Impact: 6
#> 4 Slow, Significant Decline Medium Impact: 6
#> 5                No decline    Low Impact: 4
#> 6 Slow, Significant Decline    Low Impact: 5
```

## Nativity


```r
sp <- c("Lavandula stoechas", "Carpobrotus edulis", "Rhododendron ponticum",
      "Alkanna lutea", "Anchusa arvensis")
```

Native in the continental USA?


```r
sapply(sp, is_native, where = "Continental US", region = "america")
#>    Lavandula stoechas    Carpobrotus edulis Rhododendron ponticum 
#>          "Introduced"          "Introduced" "species not in itis" 
#>         Alkanna lutea      Anchusa arvensis 
#> "species not in itis"          "Introduced"
```

Native on Islas Baleares?


```r
sapply(sp, is_native, where = "Islas_Baleares", region = "europe")
#>    Lavandula stoechas    Carpobrotus edulis Rhododendron ponticum 
#>              "Native"          "Introduced"           "Not found" 
#>         Alkanna lutea      Anchusa arvensis 
#>              "Native"              "Native"
```
