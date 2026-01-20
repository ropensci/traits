## Test environments

* local macOS install, R 4.5.2
* Ubuntu 22.04 (via GitHub Actions), R 4.3.1
* Windows (via GitHub Actions), R 4.3.1
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 NOTE

* The NOTE is a known benign issue: "checking for future file timestamps ... unable to verify current time".

## Changes in this version

* Fully removed previously defunct functions that were marked as defunct in prior versions:
  * `tr_usda()` and `coral_*` functions (defunct since v0.5.0)
  * `is_native()`, `g_invasive()`, `eol_invasive()`, `fe_native()` (defunct since v0.3.0)
* Updated package documentation. Changed internet-dependent examples from \donttest to \dontrun.
* Fixed various function documentation issues

## Resubmission Notes

- This is a resubmission.
- "Archived due to dependency on orphaned package `taxize`"
  - `taxize` is no longer orphaned and has been restored on CRAN. The dependency is now valid.

- "Invalid URLs (status 301: Moved Permanently) in `README.md`"  
  - All URLs have been verified with `urlchecker::url_check()`.
  
------

Thanks!
David LeBauer
