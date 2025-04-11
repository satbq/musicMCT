test_that("brightnessComps matrix has correct values", {
  test_comps <- brightnessComps(c(0, 3, 7))
  dimnames(test_comps) <- NULL
  expect_equal(test_comps, 
               matrix(c(0,1,1,-1,0,0,-1,0,0),nrow=3))
})

test_that("delta and eps work", {
  test_scale <- c(0,2,3,5,6,7)
  expect_equal(delta(test_scale), 12)
  expect_equal(eps(test_scale), 6)
})

test_that("brightness ratio works", {
  expect_equal(ratio(c(0,2,4,5,7,9,11)), 0)
  expect_equal(ratio(c(0, 4, 7)), 0)
  expect_equal(ratio(c(0, 2, 6)), 0)
  expect_equal(ratio(c(0,2,3,7,8)),1/3)
  expect_equal(ratio(c(0,1,4,9,11), edo=15), 0.5)
})
