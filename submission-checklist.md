First release:

* [x] `usethis::use_cran_comments()` (file present: `cran-comments.md`)
* [x] Update (aspirational) install instructions in README
* [ ] Proofread `Title:` and `Description:`
* [ ] Check that all exported functions have `@return` and `@examples`
* [x] Check that `Authors@R:` includes a copyright holder (role 'cph')
* [ ] Check [licensing of included files](https://r-pkgs.org/license.html#sec-code-you-bundle)
* [ ] Review <https://github.com/DavisVaughan/extrachecks>

Prepare for release:

* [ ] `git pull`
* [x] `urlchecker::url_check()`
* [x] `devtools::build_readme()`
* [x] `devtools::check(remote = TRUE, manual = TRUE)` (2 NOTES: archived resubmission info + future timestamp verification)
* [x] `devtools::check_win_devel()` (submitted 2026-02-18; wait for email results)
* [ ] `git push`

Submit to CRAN:

* [ ] `usethis::use_version('patch')` (only if you want to bump beyond 0.6.0)
* [ ] `devtools::submit_cran()`
* [ ] Approve email

Wait for CRAN...

* [ ] Accepted :tada:
* [ ] `usethis::use_github_release()`
* [ ] `usethis::use_dev_version(push = TRUE)`
