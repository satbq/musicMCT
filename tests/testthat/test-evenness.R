test_that("evenness works", {
  expect_equal(evenness(c(0,3,6,9)), 0)
  expect_equal(evenness(c(0,1,2,3,5,7,8)), 2)
  expect_equal(evenness(c(0,3,6)), sqrt(2))
})
