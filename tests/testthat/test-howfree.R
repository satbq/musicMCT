test_that("howfree measures correctly", {
  expect_equal(howfree(c(0,3,6,9)), 0)
  expect_equal(howfree(c(0,2,4,5,7,9,11)), 1)
})