test_that("ifunc works", {
  first_ifunc <- c(0, 0, 2, 4, 2, 0, 0, 0, 2, 4, 2, 0)
  names(first_ifunc) <- 0:11

  second_ifunc <- c(1, 2, 1, 3, 1, 2, 2, 2, 3, 1, 2, 1)
  names(second_ifunc) <- 0:11

  third_ifunc <- c(3, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0)
  names(third_ifunc) <- 0:11

  fourth_ifunc <- c(3, 2, 1, 1, 2)
  names(fourth_ifunc) <- c("0", "3.5", "5", "7", "8.5")

  expect_equal(ifunc(c(9, 2, 3, 8), c(0, 5, 6, 11)),
               first_ifunc)
  expect_equal(ifunc(c(8, 10, 3), c(11, 5, 4, 1, 3, 2, 6)),
               second_ifunc)
  expect_equal(ifunc(c(0,3,7)), third_ifunc)

  expect_equal(ifunc(c(0, 3.5, 7)), fourth_ifunc)
})

test_that("ifunc display settings work", {
  triad <- 12 * log2(c(1, 5/4, 3/2))
  expected_ifunc_1 <- c(3, 1, 1, 1, 1, 1, 1)
  expected_ifunc_2 <- expected_ifunc_1
  expected_ifunc_3 <- expected_ifunc_1
  names(expected_ifunc_1) <- c("0", "3.15", "3.86", "4.98", 
                               "7.01", "8.13", "8.84")
  names(expected_ifunc_2) <- c("0", "3.156", "3.863", "4.980",
                               "7.019", "8.136", "8.843")
  names(expected_ifunc_3) <- c("0", "3", "4", "5", "7", "8", "9")

  expect_equal(ifunc(triad, display_digits=2), expected_ifunc_1)
  expect_equal(ifunc(triad, display_digits=3), expected_ifunc_2)
  expect_equal(ifunc(c(0,3,7), show_zeroes=FALSE), expected_ifunc_3)
})

test_that("ifunc edo param works", {
  expected_ifunc <- c(3, 0, 0, 0, 2, 1, 0, 0, 1, 2, 0, 0, 0)
  names(expected_ifunc) <- 0:12

  expect_equal(ifunc(c(0, 4, 8), edo=13), expected_ifunc)
})