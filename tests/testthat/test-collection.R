library(dplyr)

testthat::test_that("Read Collections", {
  df = bdr_collections()
  testthat::expect_is(df, "data.frame")
  testthat::expect_is(df, "tbl")
  coll_url = df %>%
    filter(grepl("Bactrian ", name)) %>%
    pull(json_uri)
  testthat::expect_silent({
    coll = bdr_collection(coll_url)
    })
  testthat::expect_is(coll, "data.frame")
  testthat::expect_is(coll, "tbl")
})
