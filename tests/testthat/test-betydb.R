context("BETYdb tests")

test_that("Broken Function", {
  skip_on_cran()

  expect_error(betydb_traits(genus = "Miscanthus", author = "Arundale", trait = "yield"))
})

test_that("BETYdb v0 API works", {
  skip_on_cran()
  check_betydb()

  ## gh-18
  betyurl <- "https://www.betydb.org/"
  priors_url <- makeurl("priors", fmt = "json", betyurl = betyurl)
  expect_equal(priors_url, paste0(betyurl, "priors.json"))

  # Priors is a small table
  get.out <- GET(paste0(priors_url, "/?key=eI6TMmBl3IAb7v4ToWYzR0nZYY07shLiCikvT6Lv"))
  expect_is(get.out, "response")
  expect_match(httr::headers(get.out)$status, "OK")
  expect_match(get.out$url, betyurl)
})

test_that("BETYdb beta API works", {
  skip_on_cran()
  check_betydb()

  betyurl <- "https://www.betydb.org/"
  priors_url <- makeurl("priors", fmt = "json", betyurl = betyurl, api_version = "beta")
  expect_equal(priors_url, paste0(betyurl, "api/beta/priors.json"))

  get.out <- GET(paste0(priors_url, "/?key=eI6TMmBl3IAb7v4ToWYzR0nZYY07shLiCikvT6Lv")) # Priors is a small table
  expect_is(get.out, "response")
  expect_match(httr::headers(get.out)$status, "OK" )
  expect_match(get.out$url, betyurl)
})

test_that("table to property name matching works", {
  skip_on_cran()
  check_betydb()

  getprop <- function(name){
    txt <- betydb_http(
      makeurl(name, fmt = "json", betyurl = "https://www.betydb.org/", api_version = "beta"),
      args = list(limit = 1),
      key = NULL,
      user = NULL,
      pwd = NULL)
    names(jsonlite::fromJSON(txt, simplifyVector = TRUE, flatten = FALSE)$data)[[1]]
  }
  tablenames <- c("search", "species", "entities", "citations", "pfts")
  expected_propnames <- sapply(tablenames, makepropname, api_version = "beta")
  got_propnames <- sapply(tablenames, getprop)

  expect_equal(got_propnames, expected_propnames)
})

test_that("Basic search works", {
  skip_on_cran()
  check_betydb()

  acru <- betydb_search('Acer rubrum')
  acru_vcmax <- betydb_search('Acer rubrum Vcmax')
  expect_true(all(acru_vcmax$id %in% acru$id))

  expect_equal(unique(acru_vcmax$trait), "Vcmax")
})

test_that("Credentials work", {
  skip_on_cran()
  check_betydb()

  usrpwd <- betydb_search('Acer rubrum', user = "ropensci-traits", pwd = "ropensci")
  key <- betydb_search('Acer rubrum', key = "eI6TMmBl3IAb7v4ToWYzR0nZYY07shLiCikvT6Lv")
  expect_equal(usrpwd$id, key$id)

  prevkey <- options(betydb_key = "NOTVALID")
  on.exit(options(prevkey))
  # FIXME - should use v0 API for symmetry w/ other calls,
  # but v0 skips auth for search table
  options(betydb_key = 'NOT A KEY')
  expect_error(betydb_search("Acer rubrum", api_version = "beta"), "Unauthorized")
  options(betydb_key = "eI6TMmBl3IAb7v4ToWYzR0nZYY07shLiCikvT6Lv")
  optkey <- betydb_search('Acer rubrum')
  expect_equal(optkey$id, key$id)

  salix <- betydb_search('salix yield')
  expect_gte(min(salix$access_level), 4)

  ## Glopnet data are restricted
  expect_null(betydb_search('wright 2004'))
})

test_that("URL & version options work", {
  skip_on_cran()
  check_betydb()

  opts <- options()
  on.exit(reset_opts(opts))
  options(
    betydb_url = "https://www.betydb.org/",
    betydb_api_version = "v0")
  opt1 <- betydb_query(author = "Arundale", table = "citations")

  options(betydb_url = "http://example.com/", betydb_api_version = "beta")
  expect_error(betydb_query(author = "Arundale", table = "citations"), "Not Found")
  opt2 <- betydb_query(author = "Arundale", table = "citations",
    betyurl = "https://www.betydb.org/")
  opt3 <- betydb_query(author = "Arundale", table = "citations",
                       betyurl = "https://www.betydb.org/", api_version = "v0")

  expect_gt(ncol(opt2), ncol(opt3)) # new API returns more params
  expect_equal(opt2$id, opt3$id) # but both should find same IDs
  expect_equal(opt1, opt3)
})

test_that("betydb_query works", {
  skip_on_cran()
  check_betydb()

  np <- betydb_query(distn = "norm", table = "priors")
  expect_is(np, "data.frame")
  expect_is(np$distn, "character")
  expect_equal(length(unique(np$distn)), 1)
  expect_equal(unique(np$distn), "norm")

  np_grass <- betydb_query(distn = "norm", phylogeny = "grass", table = "priors")
  expect_true(all(np_grass$id %in% np$id))
})

test_that("paging works with betydb query and search functions",{
  skip_on_cran()
  check_betydb()
  opts <- options()
  on.exit(reset_opts(opts))
  options(
    betydb_url = "https://www.betydb.org/",
    betydb_api_version = "beta",
    betydb_key = "eI6TMmBl3IAb7v4ToWYzR0nZYY07shLiCikvT6Lv",
    warn=-1 ## suppress warnings that we did not get all data
  )

  # check paging much faster than default hardcoded limit of 5000
  per_call_limit <<- 10

  # return 200 records by default
  limit_default <- betydb_query(table = "traits")
  expect_equal(nrow(limit_default), 200)

  # check that paging returns correct # below and above default
  limit3 <- betydb_query(table = 'traits', limit = 3)
  expect_equal(nrow(limit3), 3)
  expect_equal(nrow(limit3), attributes(limit3)$metadata$count)

  limit30 <- betydb_query(table = "traits", limit = 30)
  expect_equal(nrow(limit30), 30)
  expect_equal(nrow(limit30), attributes(limit30)$metadata$count)

  limit401 <- betydb_query(table = 'traits', limit = 401)
  expect_equal(nrow(limit401), 401)
  expect_equal(nrow(limit401), attributes(limit401)$metadata$count)

})

test_that("betydb_record works", {
  skip_on_cran()
  check_betydb()

  rec <- betydb_record(id = 10, table = "traits")
  expect_is(rec, "list")
  expect_is(rec$id, "integer")
  expect_equal(rec$id, 10)
})

test_that("betydb_trait works", {
  skip_on_cran()
  check_betydb()

  aa <- betydb_trait(id = 10)
  expect_is(aa, "list")
  expect_is(aa$id, "integer")
  expect_equal(aa$id, 10)
})

test_that("betydb_specie works", {
  skip_on_cran()
  check_betydb()

  bb <- betydb_specie(id = 1)
  expect_is(bb, "list")
  expect_is(bb$id, "integer")
  expect_equal(bb$id, 1)
})

test_that("betydb_citation works", {
  skip_on_cran()
  check_betydb()

  cc <- betydb_citation(id = 1)
  expect_is(cc, "list")
  expect_is(cc$id, "integer")
  expect_equal(cc$id, 1)
})

test_that("betydb_site works", {
  skip_on_cran()
  check_betydb()

  dd <- betydb_site(id = 795)
  expect_is(dd, "list")
  expect_is(dd$city, "character")
})

test_that("include_unchecked works", {
  skip_on_cran()
  check_betydb()

  q1 <- betydb_search(query = "maple SLA")
  q2 <- betydb_search(query = "maple SLA", include_unchecked = TRUE)

  expect_gt(nrow(q2), nrow(q1))
  expect_true(all(q1$id %in% q2$id))
})

