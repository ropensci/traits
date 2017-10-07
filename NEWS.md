traits 0.3.0
============

### DEFUNCT

* Four functions are now defunct - those involving getting data
on whether a species if native/invasive in a particular region. 
See `?traits-defunct` for more information. Deprecated functions:
`eol_invasive_()`, `fe_native()`, `g_invasive()`, `is_native()` (#72)

### NEW FEATURES

* Gains new function `tr_ernest` for a dataset of Amniote life history
data (#60)
* Gains new function `tr_usda` for the USDA plants database (#61)
* Gains new function `tr_zanne` for a dataset of plant growth data (#73)

### MINOR IMPROVEMENTS

* Change Coral database base URL to https (#99)
* Now requiring `readr > 1.0` (#76)
* Changed `ncbi_*()` functions to give back `NA` types that match
data.frame column classes to make combining easier (#96)
* replace `xml2::xml_find_one` with `xml2::xml_find_first` throughout (#97)
* namespace all fxn calls for base pkgs, remove from Imports (#98)
* BetyDB cleanup (#25) (#77) (#82) (#88) 

### BUG FIXES

* Fixed `birdlife*` functions that needed to change URL structure 
due to changes in the Birdlife website (#100)
* Fixes to `traitbank()` (#79) (#80) thanks @dschlaep !
* `ncbi_*()` fxns now use https (#95)


traits 0.2.0
============

### DEPRECATED

* Marked four functions as deprecated - those involving getting data
on whether a species if native/invasive in a particular region. 
See `?traits-deprecated` for more information. Deprecated functions:
`eol_invasive_()`, `fe_native()`, `g_invasive()`, `is_native()` (#63)

### MINOR IMPROVEMENTS

* Standardized outputs of all data - all data.frame column names should 
be lowercase now (#47)
* With all `httr::content()` calls now explicitly setting encoding to 
`UTF-8`, and parsing to `text`, then manually parsing either JSON
or XML later (#65)
* Replaced `XML` with `xml2` for XML parsing (#67)

traits 0.1.2
============

### NEW FEATURES

* `ncbi_searcher()` gains new parameter `fuzzy` to toggle fuzzy taxonomic ID search or exact search. (#34) (thx @mpnelsen)

### MINOR IMPROVEMENTS

* Importing only functions (via `importFrom`) used across all imports now.
In addition, `importFrom` for all non-base R pkgs, including `methods`,
`stats` and `utils` packages (#36)
* Changed the `trait` parameter in `traitbank()` function to `pageid`, 
because EOL expects a page identifier, which is associated with a taxon, 
not a trait. The previous parameter name was very misleading.

traits 0.1.0
============

### NEW FEATURES

* released to CRAN
