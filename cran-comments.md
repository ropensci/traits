## Test environments

* local macOS install, R 4.5.2 (`devtools::check(remote = TRUE, manual = TRUE)`) on 2026-04-05
* win-builder devel (submitted on 2026-04-05; results pending email)

## R CMD check results

0 errors | 0 warnings | 1 NOTE

* "checking CRAN incoming feasibility ... NOTE" because this is a resubmission of an archived package (`taxize` is now restored on CRAN).

## Changes in this version

* Fully removed previously defunct functions that were marked as defunct in prior versions:
  * `tr_usda()` and `coral_*` functions (defunct since v0.5.0)
  * `is_native()`, `g_invasive()`, `eol_invasive()`, `fe_native()` (defunct since v0.3.0)
* Updated package documentation and synchronized generated Rd files with roxygen sources.
* Added safe, non-network example lines so documentation can demonstrate validation behavior without making HTTP requests.
* Updated the BETYdb API v0 documentation link to the current live URL.
* Integrated CRAN reviewer-requested example updates (`\dontrun` -> `\donttest`) and added non-interactive guards for internet-dependent examples to avoid transient network failures during automated checks.
* Made `ncbi_searcher()` startup output suppressible via existing verbosity controls.

## Resubmission Notes

- This is a resubmission.
- "Archived due to dependency on orphaned package `taxize`"
  - `taxize` is no longer orphaned and has been restored on CRAN. The dependency is now valid.
- Previous invalid or redirected documentation URLs have been corrected and all package URLs now pass `urlchecker::url_check()`.

------

Thanks!
David LeBauer
