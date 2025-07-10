test_that("set_from_signvector works", {
  expected_tri <- list(c(0, 2, 4), 5)
  names(expected_tri) <- c("set", "edo")
  expect_equal(set_from_signvector(c(0, 1, 1), card=3), expected_tri)

  expect_equal(sum(is.na(set_from_signvector(c(0, 1, -1), card=3, reconvert=TRUE))), 
               3)

  expect_equal(set_from_signvector(c(1, -1, -1), card=3, target_edo=12, reconvert=TRUE), 
               c(0, 2, 3))
  expect_equal(set_from_signvector(c(1, -1, -1), card=3, target_edo=NULL, reconvert=TRUE), 
               c(0, 4, 6))
})

test_that("approximate_from_signvector requires card or ineqmat", {
  expect_error(approximate_from_signvector(c(-1, -1, -1)))
})