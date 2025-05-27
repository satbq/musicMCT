test_that("signvector works with default ineqmat", {
  expect_length(signvector(pi), 0)
  expect_equal(signvector(c(0, 7)),1)
  expect_equal(signvector(c(0, 3, 7)), c(-1, -1, -1))
  expect_equal(signvector(c(0, 2, 7, 9)),
               c(-1, 0, 1, -1, 1, -1, 1, 1))
  expect_equal(signvector(c(0,2,4,5), edo=6),
               c(0, 1, 1, 1, 1, 0, 1, 0))
})

test_that("signvector accepts non-default ineqmats", {
  novel_ineqmat <- matrix(c(-1, 2, -1, 0, 0,
                            -1, 1, 1, -1, 0,
                            0, -1, 2, -1, 0,
                            -2, 1, 0, 1, -1,
                            -1, -1, 1, 1, -1,
                            -1, 0, -1, 2, -1,
                            -2, 0, 2, 0, -1,
                            0, -2, 0, 2, -1,
                            -1, 1, 0, 0, -0.25), 
                          byrow=TRUE, nrow=9)
  expect_equal(signvector(c(0,3,4,7), ineqmat=novel_ineqmat),
               c(1, 0, -1, -1, -1, -1, -1, -1, 0))
})

test_that("count and whichsvzeroes work", {
  expect_equal(countsvzeroes(c(0, 2, 4, 5, 7, 9, 11)), 22)
  expect_equal(countsvzeroes(c(0, 4, 8)), 3)
  expect_equal(countsvzeroes(c(0, 4, 8), ineqmat="white"), 3)
  expect_equal(countsvzeroes(c(0, 4, 8), ineqmat="roth"), 0)
  expect_equal(countsvzeroes(c(0, 4, 8), ineqmat="pastel"), 6)

  expect_equal(whichsvzeroes(c(0, 2, 5, 7)), 2)
  expect_equal(whichsvzeroes(c(0, 2, 5, 7), ineqmat="roth"), c(4, 7))
})

test_that("svzero_fingerprint works", {
  expect_equal(svzero_fingerprint(c(0, 1, 3, 5, 7, 9)),
                                  c(4, 6, 2))
  expect_equal(svzero_fingerprint(c(0, 3, 6, 9)),
                                  c(2, 4, 2))
})

test_that("svzero_fingerprint accepts non-default ineqmats", {
  novel_ineqmat <- matrix(c(-1, 2, -1, 0, 0,
                            -1, 1, 1, -1, 0,
                            0, -1, 2, -1, 0,
                            -2, 1, 0, 1, -1,
                            -1, -1, 1, 1, -1,
                            -1, 0, -1, 2, -1,
                            -2, 0, 2, 0, -1,
                            0, -2, 0, 2, -1,
                            -1, 1, 0, 0, -0.25), 
                          byrow=TRUE, nrow=9)
  expect_equal(svzero_fingerprint(c(0, 3, 4, 7), ineqmat=novel_ineqmat),
               c(2, 0 ,0))
})