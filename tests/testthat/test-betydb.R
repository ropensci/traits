context("BETYdb tests")

test_that("Broken Function", {
  skip_on_cran()

  expect_error(betydb_traits(genus = "Miscanthus", author = "Arundale", trait = "yield"))
})

test_that("BETYdb API works", {
  skip_on_cran()
  check_betydb()

  ## gh-18
  priors_url <- makeurl("priors", fmt = "json")
  expect_equal(priors_url, paste0(betyurl(), "priors.json"))

  get.out <- GET(priors_url) # Priors is a small table
  expect_is(get.out, "response")
  ## FIXME - this fails for me, gives `401 Unauthorized` (scott here)
  # expect_true(grepl("OK", get.out[["headers"]]$status))
  expect_true(grepl(betyurl(), get.out[["url"]]))
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
  salix <- betydb_search('salix yield')
  expect_true(min(salix$access_level) >= 4, info = "please report to betydb@gmail.com")

  ## Glopnet data are restricted
  expect_null(betydb_search('wright 2004'))
})

test_that("betydb_trait works", {
  skip_on_cran()
  check_betydb()

  aa <- betydb_trait(id = 10)
  expect_is(aa, "data.frame")
  expect_is(aa$id, "integer")
  expect_equal(aa$id, 10)
})

test_that("betydb_specie works", {
  skip_on_cran()
  check_betydb()

  bb <- betydb_specie(id = 1)
  expect_is(bb, "data.frame")
  expect_is(bb$id, "integer")
  expect_equal(bb$id, 1)
})

test_that("betydb_citation works", {
  skip_on_cran()
  check_betydb()

  cc <- betydb_citation(id = 1)
  expect_is(cc, "data.frame")
  expect_is(cc$id, "integer")
  expect_equal(cc$id, 1)
})

test_that("betydb_site works", {
  skip_on_cran()
  check_betydb()

  dd <- betydb_site(id = 795)
  expect_is(dd, "data.frame")
  expect_is(dd$city, "character")
})
