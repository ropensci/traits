context("BETYdb")

test_that("BETYdb API works", {
  ## gh-18
  get.out <- GET("https://www.betydb.org/priors.json") # Priors is a small table
  expect_is(get.out, "response")
})

test_that("Genus / Species queries work", {
  mxg <- betydb_traits(genus = 'Miscanthus', species = "giganteus", user = "ropensci-traits", pwd = "ropensci")
  pavi <- betydb_traits(genus = 'Panicum', species = "virgatum", user = "ropensci-traits", pwd = "ropensci")
  # expect_false(mxg == pavi)
}
)
