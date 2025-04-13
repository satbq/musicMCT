test_that("saturate works", {
  expect_equal(saturate(0, c(0,4,7)), c(0,4,8))
  expect_equal(saturate(1, c(0,4,7)), c(0,4,7))
  expect_equal(saturate(2, c(0,4,7)), c(0,4,6))
  expect_equal(saturate(-1, c(0,4,7)), c(0,4,9))

  expect_equal(saturate(2, c(0,4,7), edo=15), c(0,3,4))
})
