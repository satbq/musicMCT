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

test_that("emb works", {
  expect_equal(emb(c(0, 4, 7), c(0, 2, 4, 5, 7, 9, 11), canon="tn"), 3)
  expect_equal(emb(c(0, 4, 7), c(0, 2, 4, 5, 7, 9, 11), canon="tni"), 6)
  expect_equal(emb(c(2, 6, 9), c(0, 3, 6, 7), canon="tni"), 1)
  expect_equal(emb(c(0, 3, 7), c(0, 0.1, 4, 4.1, 7, 7.1), canon="tni"), 2)
  expect_equal(emb(c(0, 3, 7), c(0, 0.1, 4, 4.1, 7, 7.1), canon="tn"), 0)

  expect_equal(emb(c(0, 6, 10), c(0, 1, 4, 7, 8, 11, 14), edo=17), 6)

  expect_equal(emb(c(0, 2, 4, 7, 9), c(0, 2, 5, 7, 9)), 1)
  expect_equal(emb(c(0, 2, 4, 5), c(0, 2, 4)), 0)

  expect_equal(emb(0, c(0,2,4,7,9)), 5)
  expect_equal(emb(integer(0), c(0,2,4,7,9)), 0)
  expect_true(is.null(emb(NULL, c(0, 3, 7))))
  expect_true(is.null(emb(c(0, 3, 7), NULL)))
})

test_that("cover works", {
  expect_equal(cover(c(0, 4, 7), c(0, 2, 3, 5, 7, 8, 11), canon="tn"), 2)
  expect_equal(cover(c(0, 4, 8), c(0, 2, 3, 5, 7, 9, 11)), 3)
  expect_equal(cover(c(0, 4), c(0, 4, 8)), 1)
  expect_equal(cover(c(0, 5), c(0, 5, 10), edo=15), 1)

  just_triad <- 12 * log2(c(1, 5/4, 3/2))
  just_dia <- 12 * log2(c(1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8))
  expect_equal(cover(just_triad, just_dia), 5)
  expect_equal(cover(just_triad, just_dia, canon="tn"), 3)
  expect_equal(cover(charm(just_triad), just_dia, canon="tn"), 2) 
  expect_equal(cover(charm(just_triad), just_dia, canon="tni"), 5)

  expect_equal(cover(c(0, 6), c(0, 1, 6)), 4)
  expect_equal(cover(c(0, 6), c(0, 1, 6), canon="tn"), 2)
  expect_equal(cover(c(0, 1, 6), c(0, 1, 6, 7), canon="tni"), 1)
  expect_equal(cover(c(0, 1, 6), c(0, 1, 6, 7), canon="tn"), 1)

  harmonic_minor <- c(0, 2, 3, 5, 7, 8, 11)
  aug_triad <- c(0, 4, 8)
  expect_equal(cover(aug_triad, harmonic_minor, canon="tni"), 6)
  expect_equal(cover(aug_triad, harmonic_minor, canon="tn"), 3)

  expect_equal(cover(c(0, 2, 4), c(0, 2, 4, 8), canon="tni"), 1)
  expect_equal(cover(c(0, 2, 4), c(0, 2, 4, 8), canon="tn"), 1)
})

