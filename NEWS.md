traits 0.2.0
===============

## DEPRECATED

* Marked four functions as deprecated - those involving getting data
on whether a species if native/invasive in a particular region. 
See `?traits-deprecated` for more information. Deprecated functions:
`eol_invasive_()`, `fe_native()`, `g_invasive()`, `is_native()` (#63)

## MINOR IMPROVEMENTS

* Standardized outputs of all data - all data.frame column names should 
be lowercase now (#47)
* With all `httr::content()` calls now explicitly setting encoding to 
`UTF-8`, and parsing to `text`, then manually parsing either JSON
or XML later (#65)
* Replaced `XML` with `xml2` for XML parsing (#67)

traits 0.1.2
===============

## NEW FEATURES

* `ncbi_searcher()` gains new parameter `fuzzy` to toggle fuzzy taxonomic ID search or exact search. (#34) (thx @mpnelsen)

## MINOR IMPROVEMENTS

* Importing only functions (via `importFrom`) used across all imports now.
In addition, `importFrom` for all non-base R pkgs, including `methods`,
`stats` and `utils` packages (#36)
* Changed the `trait` parameter in `traitbank()` function to `pageid`, 
because EOL expects a page identifier, which is associated with a taxon, 
not a trait. The previous parameter name was very misleading.

traits 0.1.0
===============

## NEW FEATURES

* released to CRAN
