## Test environments

* local macOS install, R 4.5.2 (`devtools::check(remote = TRUE, manual = TRUE)`)
* win-builder devel (submitted on 2026-02-18; results pending email)

## R CMD check results

0 errors | 0 warnings | 2 NOTEs

* "checking CRAN incoming feasibility ... NOTE" because this is a resubmission of an archived package (`taxize` is now restored on CRAN).
* "checking for future file timestamps ... unable to verify current time" (known benign timing NOTE in this environment).

## Changes in this version

* Fully removed previously defunct functions that were marked as defunct in prior versions:
  * `tr_usda()` and `coral_*` functions (defunct since v0.5.0)
  * `is_native()`, `g_invasive()`, `eol_invasive()`, `fe_native()` (defunct since v0.3.0)
* Updated package documentation and synchronized generated Rd files with roxygen sources.
* Integrated CRAN reviewer-requested example updates (`\dontrun` -> `\donttest`) and added non-interactive guards for internet-dependent examples to avoid transient network failures during automated checks.
* Made `ncbi_searcher()` startup output suppressible via existing verbosity controls.

## Resubmission Notes

- This is a resubmission.
- "Archived due to dependency on orphaned package `taxize`"
  - `taxize` is no longer orphaned and has been restored on CRAN. The dependency is now valid.

- "Invalid URLs (status 301: Moved Permanently) in `README.md`"  
  - All URLs have been verified with `urlchecker::url_check()`.
  
------

Thanks!
David LeBauer
