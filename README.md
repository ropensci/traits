traits
=======



[![cran checks](https://badges.cranchecks.info/worst/traits)](https://badges.cranchecks.info/pkgs/traits)
[![Build Status](https://app.travis-ci.com/ropensci/traits.svg?branch=master)](https://app.travis-ci.com/ropensci/traits)
[![codecov](https://app.codecov.io/gh/ropensci/traits/branch/master/graph/badge.svg)](https://app.codecov.io/gh/ropensci/traits)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/traits)](https://github.com/r-hub/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/traits)](https://CRAN.R-project.org/package=traits)

R client for various sources of species trait data.

Docs: https://docs.ropensci.org/traits/

What is a trait? A "trait" for the purposes of this package is broadly defined as an aspect of a species that can be described or measured, such as physical traits (size, length, height, color), behavioral traits (running speed, etc.), and even variables that make up the niche of the species (e.g., habitat).

Included in `traits` with the associated function prefix or function name:

<table>
<colgroup>
<col style="text-align:left;"/>
<col style="text-align:left;"/>
<col style="text-align:left;"/>
<col style="text-align:left;"/>
</colgroup>

<thead>
<tr>
  <th style="text-align:left;">Souce</th>
  <th style="text-align:left;">Function prefix</th>
  <th style="text-align:left;">Link</th>
</tr>
</thead>

<tbody>
<tr>
  <td style="text-align:left;">BETYdb</td>
  <td style="text-align:left;"><code>betydb_</code></td>
  <td style="text-align:left;">https://www.betydb.org/</td>
</tr>
<tr>
  <td style="text-align:left;">NCBI</td>
  <td style="text-align:left;"><code>ncbi_</code></td>
  <td style="text-align:left;">https://www.ncbi.nlm.nih.gov/</td>
</tr>
<tr>
  <td style="text-align:left;">Encylopedia of Life</td>
  <td style="text-align:left;"><code>traitbank_</code></td>
  <td style="text-align:left;">https://github.com/EOL/eol_website/blob/master/doc/api.md</td>
</tr>
<tr>
  <td style="text-align:left;">Birdlife International</td>
  <td style="text-align:left;"><code>birdlife_</code></td>
  <td style="text-align:left;">https://www.birdlife.org/</td>
</tr>
<tr>
  <td style="text-align:left;">LEDA Traitbase</td>
  <td style="text-align:left;"><code>leda_</code></td>
  <td style="text-align:left;"></td>
</tr>
<tr>
  <td style="text-align:left;">Zanne et al. plant dataset</td>
  <td style="text-align:left;"><code>tr_zanne</code></td>
  <td style="text-align:left;"></td>
</tr>
<tr>
  <td style="text-align:left;">Amniote life history dataset</td>
  <td style="text-align:left;"><code>tr_ernest</code></td>
  <td style="text-align:left;"></td>
</tr>
</tbody>
</table>


Talk to us on the issues page (https://github.com/ropensci/traits/issues) if you know of a source of traits data with an API, and we'll see about including it.

## Installation

Stable CRAN version


```r
install.packages("traits")
```

Or development version from GitHub


```r
remotes::install_github("ropensci/traits")
```


```r
library("traits")
library("dplyr")
```

## Contributors

* [Scott Chamberlain](https://github.com/sckott)
* [Zachary Foster](https://github.com/zachary-foster)
* [Ignasi Bartomeus](https://github.com/ibartomeus)
* [David LeBauer](https://github.com/dlebauer)
* [David Harris](https://github.com/davharris)
* [Chris Black](https://github.com/infotroph)
* [Rupert Collins](https://github.com/boopsboops)

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/traits/issues).
* License: MIT
* Get citation information for `traits` in R doing `citation(package = 'traits')`
* Please note that this package is released with a [Contributor Code of Conduct](https://ropensci.org/code-of-conduct/). By contributing to this project, you agree to abide by its terms.

[![ropensci_footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
