context("NCBI tests")

test_one_species <- "Acer rubrum"
test_three_species <- c("Colletes similis", "Halictus ligatus", "Perdita californica")
test_genes <- c("coi", "co1")
test_that("ncbi_byname gets seq for single species", {
  skip_on_cran()
  result <- ncbi_byname("Acer rubrum")
  expect_equal(ncol(result), 7)
  expect_equal(nrow(result), 1)
  expect_true(!is.na(result$taxon))
  expect_true(!is.na(result$sequence))
})

test_that("ncbi_byname gets seq for multiple species", {
  skip_on_cran()
  result <- ncbi_byname(test_three_species)
  expect_equal(ncol(result), 7)
  expect_gte(nrow(result), 3)
  expect_true(all(!is.na(result$taxon)))
  expect_true(all(!is.na(result$sequence)))
})

test_that("ncbi_byname handles cases with no results", {
  skip_on_cran()
  result <- ncbi_byname("This is not a species")
  expect_equal(ncol(result), 7)
  expect_equal(nrow(result), 1)
  expect_true(all(is.na(result[,2:7])))
})

test_that("ncbi_byname gets seq for single gene", {
  skip_on_cran()
  result <- ncbi_byname(test_one_species, gene = "coi")
  expect_equal(ncol(result), 7)
  expect_gte(nrow(result), 1)
  expect_true(all(!is.na(result$taxon)))
  expect_true(all(!is.na(result$sequence)))
})

## regression tests for https://github.com/ropensci/traits/issues/126

test_that("ncbi_byname works under subset of conditions from issue #126", {
  skip_on_cran()

  res <- ncbi_byname(taxa = "Coryphaena hippurus", gene = c("Coi"), seqrange = "1:2000")
  expect_true(is.data.frame(res))
  res2 <- ncbi_byname(taxa = "Coryphaena hippurus", gene = c("Coi"), seqrange = "500:750")
  expect_true(is.data.frame(res2))
  
  res3 <- ncbi_byname(taxa = "Sardinops melanostictus", gene = c("12s"), seqrange = "1:2000")
  expect_true(is.data.frame(res3))

})