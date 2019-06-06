# tbtest_df <- data.frame(
#   sciname = c("Balaenoptera musculus", "Poa annua", "Closterocerus formosus"),
#   pageid = c(328574, 1114594, 846827))
# tbtest_n <- dim(tbtest_df)[1]

# test_that("Traitbank API works", {
#   skip_on_cran()
#   # check_traitbank()

#   for (k in seq_len(tbtest_n)) {
#     get.out <- traitbank_GET(paste0(tburl(), tbtest_df[k, "pageid"]))
#     expect_is(get.out, "list", info = tbtest_df[k, "sciname"])
#     expect_true("item" %in% names(get.out), info = tbtest_df[k, "sciname"])
#     expect_true("@context" %in% names(get.out), info = tbtest_df[k, "sciname"])
#     expect_true("traits" %in% names(get.out$item), info = tbtest_df[k, "sciname"])
#   }
# })

# test_that("Basic search works", {
#   skip_on_cran()
#   # check_traitbank()

#   for (k in seq_len(tbtest_n)) {
#     get.out <- traitbank_GET(paste0(tburl(), tbtest_df[k, "pageid"]))
#     expect_equal(get.out$item$`@id`, tbtest_df[k, "pageid"],
#       info = tbtest_df[k, "sciname"])
#     expect_equal(get.out$item$`dwc:taxonRank`, "species",
#       info = tbtest_df[k, "sciname"])
#     expect_true(grepl(tbtest_df[k, "sciname"], get.out$item$scientificName),
#       info = tbtest_df[k, "sciname"])
#   }
# })

test_that("traitbank", {
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
  expect_error(traitbank(), "\"query\" is missing", class = "error")
  expect_error(traitbank("asfasfd"), "Forbidden", class = "error")
})

# rm(tbtest_df, tbtest_n)
