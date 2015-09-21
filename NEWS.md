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
