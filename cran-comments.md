## Test environments

* local macOS install, R 4.3.1
* Ubuntu 22.04 (via GitHub Actions), R 4.3.1
* Windows (via GitHub Actions), R 4.3.1 
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 NOTE

* The NOTE is a known benign issue: “checking for future file timestamps ... unable to verify current time”.

## Changes in this version

* Added automatic archiving of releases on Zenodo.
* Added `CITATION.cff` file and DOI to metadata.
* Fixed syntax error in `test-ncbi.R` causing test failures.
* Added missing `batch_size` argument to `ncbi_byname` documentation.
* Update tests.
* Add `inst/CITATION` file. 


## Resubmission Notes


- "Archived due to dependency on orphaned package `taxize`"
  - `taxize` is no longer orphaned and has been restored on CRAN. The dependency is now valid.

- "Invalid URLs (status 301: Moved Permanently) in `README.md`"  
  - Removed codecov URL:
  - updated EOL API doc URL to `https://github.com/EOL/publishing/blob/master/doc/api.md`
  - All URLs were verified with `urlchecker::url_check()`.
  
------

Thanks!
David LeBauer
