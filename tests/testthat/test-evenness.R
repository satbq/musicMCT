test_that("evenness works", {
  expect_equal(evenness(c(0,3,6,9)), 0)
  expect_equal(evenness(c(0,1,2,3,5,7,8)), 2)
  expect_equal(evenness(c(0,3,6)), sqrt(2))

  expect_equal(evenness(c(0, 3, 7)), sqrt(2/3))

  expect_equal(evenness(c(0, 3, 7), method="taxicab"), 1)
  expect_equal(evenness(c(0, 4, 9), method="taxicab"), 1)
  expect_equal(evenness(c(0, 5, 8), method="taxicab"), 1)

  expect_equal(evenness(c(0, 3, 7, 9), method="hamming"), 1)
  expect_equal(evenness(c(0, 4, 7, 9), method="hamming"), 2)
  expect_equal(evenness(c(0, 6, 10), method="hamming", edo=15), 1)

  expect_error(evenness(c(0, 3, 7), method="chebyshev"))
})
