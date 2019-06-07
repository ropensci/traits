test_that("traitbank", {
  skip_on_cran()

  aa <- traitbank(query = "MATCH (n:Trait) RETURN n LIMIT 1;")

  expect_is(aa, "list")
  expect_named(aa, c("columns", "data"))
  expect_is(aa$data, "list")
  expect_is(aa$data[[1]], "data.frame")

  # pagination works
  aa <- traitbank(query = "MATCH (n:Trait) RETURN n LIMIT 10;")

  expect_is(aa, "list")
  expect_named(aa, c("columns", "data"))
  expect_is(aa$data, "list")
  expect_equal(length(aa$data), 10)
})

test_that("traitbank: fails well", {
  skip_on_cran()
  
  expect_error(traitbank(), "\"query\" is missing", class = "error")
  expect_error(traitbank("asfasfd"), "Forbidden", class = "error")
})
