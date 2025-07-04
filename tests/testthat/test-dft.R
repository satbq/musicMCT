test_that("set_to_distribution works", {
  expect_equal(set_to_distribution(c(0, 4, 7)), 
               c(1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0))
  expect_equal(s2d(c(0, 4, 7)), 
               c(1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0))
  expect_equal(set_to_distribution(c(12, 7, 16)), 
               c(1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0))
  expect_equal(set_to_distribution(c(2, tn(edoo(4), 2))),
               c(0, 0, 2, 0, 0, 1, 0, 0, 1, 0, 0, 1))
  expect_equal(set_to_distribution(c(0, 1, 2), edo=4),
               c(1, 1, 1, 0))
  expect_error(set_to_distribution(c(0, 3.5, 7)))
})

test_that("distribution_to_set works", {
  test_list <- list(set=c(0, 2), edo=3)
  expect_equal(distribution_to_set(c(1, 0, 1), reconvert=FALSE), 
               test_list)

  expect_equal(d2s(c(1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0)), c(0, 3, 7))
  expect_equal(d2s(s2d(c(0, 3, 6, 9))), c(0, 3, 6, 9))

  param_test <- c(1, 0, 1.01, 0)
  expect_equal(d2s(param_test), c(0, 6, 6))
  expect_equal(d2s(param_test, multiset=FALSE), c(0, 6))
  expect_equal(d2s(param_test, rounder=1), c(0, 6))
})

test_that("dft works", {
  ait_dft <- dft(c(0, 1, 4, 6))
  nameless_ait_dft <- ait_dft
  colnames(nameless_ait_dft) <- NULL
  ait_distro <- c(1, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0)
  expect_equal(nameless_ait_dft[1,], 
               c(4, sqrt(2), 2, sqrt(2), 2, sqrt(2), 2))
  expect_equal(nameless_ait_dft[2,], 
               c(0, 2.5, 0, 1.5, 2, 6.5, 0))
  expect_equal(dft(distro=ait_distro), ait_dft)

  aug9_dft <- dft(c(0, 3, 6), edo=9)[1,]
  names(aug9_dft) <- NULL
  expect_equal(aug9_dft, c(3, 0, 0, 3, 0))

})
