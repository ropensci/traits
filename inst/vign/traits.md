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

## NCBI sequence data

Get sequences by id


```r
ncbi_byid(ids = "360040093")
#>                  taxon
#> 1 Eristalis transversa
#>                                                                                                                                                                                       taxonomy
#> 1 Eukaryota; Metazoa; Ecdysozoa; Arthropoda; Hexapoda; Insecta; Pterygota; Neoptera; Holometabola; Diptera; Brachycera; Muscomorpha; Syrphoidea; Syrphidae; Eristalinae; Eristalini; Eristalis
#>                                                                                                             gene_desc
#> 1 Eristalis transversa voucher CNC:Diptera:102013 cytochrome oxidase subunit 1 (COI) gene, partial cds; mitochondrial
#>       organelle     gi_no     acc_no keyword   specimen_voucher
#> 1 mitochondrion 360040093 JN991986.1 BARCODE CNC:Diptera:102013
#>               lat_lon
#> 1 38.4623 N 79.2417 W
#>                                                       country
#> 1 USA: Virginia, Reddish Knob Lookout, 14.5km W Briery Branch
#>                                                              paper_title
#> 1 The evolution of imperfect mimicry in hover flies (Diptera: Syrphidae)
#>       journal first_author uploaded_date length
#> 1 Unpublished   Penny,H.D.   03-NOV-2012    658
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             sequence
#> 1 tactttatattttgtatttggaacatgagcgggtatagtaggaacttcattaagaattttaattcgagctgaattaggtcatccaggtgcattaattggtgatgatcaaatttataatgttattgtaacagctcatgcttttgttataattttttttatagtaatacctattataattggaggatttggaaattgattagtaccacttatattaggagctccagatatagcattccctcgaataaataatataagtttctgattattacctccttctttaactctattattagtaagaagtatagtagaaaatggggctggaacaggatgaacagtttatcctccattatcaagtaatattgcacatggaggagcctcagttgatttagcaattttttcacttcacttatcaggaatatcatctattttaggtgcagtaaattttattacaacagttattaatatacgatcaacaggaattacttatgatcgtatacctttatttgtttgatctgttgctattacagctttattattattattatcattaccagtactagcaggagctattacaatattattaactgatcgaaatttaaatacatcattctttgatccagcaggaggaggagaccctatcctgtaccaacacttattc
```

Get sequences searching by taxonomic name


```r
out <- ncbi_searcher(taxa = "Umbra limi", seqrange = "1:2000")
#> ══  1 queries  ═══════════════
#> ✔  Found:  Umbra+limi
#> ══  Results  ═════════════════
#> 
#> ● Total: 1 
#> ● Found: 1 
#> ● Not Found: 0
head(out)
#>        taxon length
#> 1 Umbra limi    761
#> 2 Umbra limi    765
#> 3 Umbra limi    764
#> 4 Umbra limi    743
#> 5 Umbra limi    758
#> 6 Umbra limi    653
#>                                                                                          gene_desc
#> 1                                  Umbra limi voucher NXG2012264 rhodopsin (Rho) gene, partial cds
#> 2                                   Umbra limi voucher NXG201250 rhodopsin (Rho) gene, partial cds
#> 3                                  Umbra limi voucher NXG2012183 rhodopsin (Rho) gene, partial cds
#> 4                                   Umbra limi voucher NXG201252 rhodopsin (Rho) gene, partial cds
#> 5                                  Umbra limi voucher NXG2012231 rhodopsin (Rho) gene, partial cds
#> 6 Umbra limi voucher NXG201250 cytochrome oxidase subunit 1 (COI) gene, partial cds; mitochondrial
#>     acc_no      gi_no
#> 1 KX146134 1049488959
#> 2 KX146015 1049488721
#> 3 KX145969 1049488629
#> 4 KX145777 1049488245
#> 5 KX145759 1049488209
#> 6 KX145415 1049487591
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

Get data by trait


```r
coral_traits(105)
#> # A tibble: 0 x 25
#> # … with 25 variables: observation_id <lgl>, access <lgl>, user_id <lgl>,
#> #   specie_id <lgl>, specie_name <lgl>, location_id <lgl>,
#> #   location_name <lgl>, latitude <lgl>, longitude <lgl>,
#> #   resource_id <lgl>, resource_secondary_id <lgl>, measurement_id <lgl>,
#> #   trait_id <lgl>, trait_name <lgl>, standard_id <lgl>,
#> #   standard_unit <lgl>, methodology_id <lgl>, methodology_name <lgl>,
#> #   value <lgl>, value_type <lgl>, precision <lgl>, precision_type <lgl>,
#> #   precision_upper <lgl>, replicates <lgl>, notes <lgl>
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

Threats data


```r
birdlife_threats(22721692)
#>          id                                                  threat1
#> 1  22721692                                Agriculture & aquaculture
#> 2  22721692                                Agriculture & aquaculture
#> 3  22721692                                  Biological resource use
#> 4  22721692                          Climate change & severe weather
#> 5  22721692                          Climate change & severe weather
#> 6  22721692                          Climate change & severe weather
#> 7  22721692 Invasive and other problematic species, genes & diseases
#> 8  22721692 Invasive and other problematic species, genes & diseases
#> 9  22721692 Invasive and other problematic species, genes & diseases
#> 10 22721692 Invasive and other problematic species, genes & diseases
#> 11 22721692 Invasive and other problematic species, genes & diseases
#> 12 22721692 Invasive and other problematic species, genes & diseases
#> 13 22721692                             Natural system modifications
#> 14 22721692                             Natural system modifications
#> 15 22721692                     Residential & commercial development
#> 16 22721692                       Transportation & service corridors
#>                                                                                   threat2
#> 1                             Annual & perennial non-timber crops - Agro-industry farming
#> 2                              Annual & perennial non-timber crops - Small-holder farming
#> 3  Logging & wood harvesting - Unintentional effects: (subsistence/small scale) [harvest]
#> 4                                                                                Droughts
#> 5                                                           Habitat shifting & alteration
#> 6                                                                       Storms & flooding
#> 7                                 Invasive non-native/alien species/diseases - Sus scrofa
#> 8                        Invasive non-native/alien species/diseases - Unspecified species
#> 9                            Problematic native species/diseases - Dendroctonus frontalis
#> 10                           Problematic native species/diseases - Odocoileus virginianus
#> 11                              Problematic native species/diseases - Unspecified species
#> 12                    Problematic species/disease of unknown origin - Unspecified species
#> 13                                     Fire & fire suppression - Trend Unknown/Unrecorded
#> 14                                                          Other ecosystem modifications
#> 15                                                                  Housing & urban areas
#> 16                                                                      Roads & railroads
#>                                                                 stresses
#> 1                     Ecosystem degradation, Ecosystem conversion, Other
#> 2                     Ecosystem degradation, Ecosystem conversion, Other
#> 3                                                  Ecosystem degradation
#> 4                                                  Ecosystem degradation
#> 5                            Ecosystem degradation, Ecosystem conversion
#> 6                                                  Ecosystem degradation
#> 7                            Ecosystem degradation, Ecosystem conversion
#> 8                                                      Species mortality
#> 9                                                  Ecosystem degradation
#> 10                                                 Ecosystem degradation
#> 11                   Ecosystem degradation, Reduced reproductive success
#> 12                                                     Species mortality
#> 13                           Ecosystem degradation, Ecosystem conversion
#> 14                           Ecosystem degradation, Ecosystem conversion
#> 15 Ecosystem degradation, Ecosystem conversion, Species mortality, Other
#> 16                                                     Species mortality
#>                                                      timing
#> 1                                 Agriculture & aquaculture
#> 2                                 Agriculture & aquaculture
#> 3                                   Biological resource use
#> 4                           Climate change & severe weather
#> 5                           Climate change & severe weather
#> 6                           Climate change & severe weather
#> 7  Invasive and other problematic species, genes & diseases
#> 8  Invasive and other problematic species, genes & diseases
#> 9  Invasive and other problematic species, genes & diseases
#> 10 Invasive and other problematic species, genes & diseases
#> 11 Invasive and other problematic species, genes & diseases
#> 12 Invasive and other problematic species, genes & diseases
#> 13                             Natural system modifications
#> 14                             Natural system modifications
#> 15                     Residential & commercial development
#> 16                       Transportation & service corridors
#>                                                                                     scope
#> 1                             Annual & perennial non-timber crops - Agro-industry farming
#> 2                              Annual & perennial non-timber crops - Small-holder farming
#> 3  Logging & wood harvesting - Unintentional effects: (subsistence/small scale) [harvest]
#> 4                                                                                Droughts
#> 5                                                           Habitat shifting & alteration
#> 6                                                                       Storms & flooding
#> 7                                 Invasive non-native/alien species/diseases - Sus scrofa
#> 8                        Invasive non-native/alien species/diseases - Unspecified species
#> 9                            Problematic native species/diseases - Dendroctonus frontalis
#> 10                           Problematic native species/diseases - Odocoileus virginianus
#> 11                              Problematic native species/diseases - Unspecified species
#> 12                    Problematic species/disease of unknown origin - Unspecified species
#> 13                                     Fire & fire suppression - Trend Unknown/Unrecorded
#> 14                                                          Other ecosystem modifications
#> 15                                                                  Housing & urban areas
#> 16                                                                      Roads & railroads
#>    severity  impact
#> 1   Ongoing Ongoing
#> 2   Ongoing Ongoing
#> 3   Ongoing Ongoing
#> 4   Ongoing Ongoing
#> 5    Future  Future
#> 6   Ongoing Ongoing
#> 7   Ongoing Ongoing
#> 8   Ongoing Ongoing
#> 9   Ongoing Ongoing
#> 10  Ongoing Ongoing
#> 11  Ongoing Ongoing
#> 12  Ongoing Ongoing
#> 13  Ongoing Ongoing
#> 14   Future  Future
#> 15  Ongoing Ongoing
#> 16  Ongoing Ongoing
```
