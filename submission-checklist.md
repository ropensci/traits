First release:

* [ ] `usethis::use_cran_comments()`
* [ ] Update (aspirational) install instructions in README
* [ ] Proofread `Title:` and `Description:`
* [ ] Check that all exported functions have `@return` and `@examples`
* [ ] Check that `Authors@R:` includes a copyright holder (role 'cph')
* [ ] Check [licensing of included files](https://r-pkgs.org/license.html#sec-code-you-bundle)
* [ ] Review <https://github.com/DavisVaughan/extrachecks>

Prepare for release:

* [ ] `git pull`
* [ ] `urlchecker::url_check()`
* [ ] `devtools::build_readme()`
* [ ] `devtools::check(remote = TRUE, manual = TRUE)`
* [ ] `devtools::check_win_devel()`
* [ ] `git push`

Submit to CRAN:

* [ ] `usethis::use_version('patch')`
* [ ] `devtools::submit_cran()`
* [ ] Approve email

Wait for CRAN...

* [ ] Accepted :tada:
* [ ] `usethis::use_github_release()`
* [ ] `usethis::use_dev_version(push = TRUE)`
