test_that("ineqsym works", {
  expect_equal(ineqsym(c(0, 2, 4, 6)), c(0, 2, 4, 6))
  expect_error(ineqsym(c(0, 2, 4, 6), a=2))
  expect_equal(ineqsym(c(0, 2, 4, 6), a=3), c(0, 0, 4, 8))
  expect_equal(ineqsym(c(0, 3, 6), 2), c(0, 2, 7))
  expect_equal(ineqsym(c(0, 3, 6), 1, 1), c(-2, 4, 7))

  penta_weitz <- seq(0, 12, by=3)
  penta_weitz[2] <- 2
  expect_equal(ineqsym(penta_weitz, a=2, b=3, edo=15), penta_weitz)

  expect_equal(ineqsym(c(0, 3, 6), a=2, involution=TRUE),
               c(0, 6, 9))
})
