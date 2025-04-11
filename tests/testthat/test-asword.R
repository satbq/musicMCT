test_that("asword works in edos", {
  expect_equal(asword(c(0,2,3,5,7,9,11)), c(2,1,2,2,2,2,1))
  expect_equal(asword(c(0,3,5,7,10,13,15), edo=17), c(2,1,1,2,2,1,1))
})

test_that("asword works with irrationals", {
  jidia <- 12 * log2(c(1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8))
  expect_equal(asword(jidia), c(3, 2, 1, 3, 2, 3, 1))
})

test_that("asword responds to rounder", {
  jidia <- 12 * log2(c(1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8))
  nearly_wt <- c(0, 2+10e-15, 4, 6, 8, 10)
  expect_equal(asword(jidia, rounder=0), c(1, 1, 1, 1, 1, 1, 1))
  expect_equal(asword(nearly_wt, rounder=15), c(3, 1, 2, 2, 2, 2))
})