test_that("zmate works", {
  expect_equal(zmate(c(0,1,4,6)), c(0,1,3,7))
  expect_equal(zmate(c(2,4,5,10)), c(0,1,4,6))
  expect_equal(zmate(c(0,1,3,5,6)), c(0,1,2,4,7))
  expect_equal(zmate(c(0,3,4,5,8)), c(0,1,3,4,8))
  expect_equal(zmate(c(0,1,2,4,5,7,8)), c(0,1,4,5,6,7,9))
})
