traits 0.5.1
============

### NEW FEATURES

* David LeBauer (@dlebauer) is now the maintainer of the traits package. Many thanks to previous maintainer Scott Chamberlain!

traits 0.5.0
============

### DEFUNCT

* `tr_usda()` is defunct. The API is down for good (#122)
* all `coral_*` functions are defunct (#124)

### MINOR IMPROVEMENTS

* replace httr with crul (#89)
* fix BETYdb tess (#123)

### BUG FIXES

* `ncbi_searcher()` fix: we weren't including the NCBI Entrez API key even when it was found  (#120)


traits 0.4.2
============

### MINOR IMPROVEMENTS

* betydb gains alias for API versions (#114)

### BUG FIXES

* `taxa_search`: removed `traitbank` option because `traits::traitbank()` used internally has completely changed and it's no longer feasible to do a straight-forward taxon search for all traits in EOL's Traitbank  (#115)


traits 0.4.0
============

### NEW FEATURES

* New package author: Chris Black (@infotroph) (#106) 
* betydb functions now can do pagination (#94)
* betydb functions gain progress parameter to optionally suppress the progress bar (#113)
* EOL Traitbank completely changed their query interface - function no longer works as it did before. for now, you have to specify your own query that's rather complex, see docs for help. Later on we can try to simplify queries for users (#112)

### MINOR IMPROVEMENTS

* table in README for different sources and clarify what traits are (#110) (#111)
* fixed link to Birdlife (#108)

### BUG FIXES

* fix to `ncbi_searcher()` to prevent failures in some cases (#107) thanks @zachary-foster
* fix to `ncbi_byid()`: ten new fields added to the output (#101) (#102) thanks @boopsboops


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
* BetyDB functions gain automatic paging of large requests where API supports it, i.e. not in v0 (#94)

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
