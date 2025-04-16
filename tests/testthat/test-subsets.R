test_that("intervalspectrum works", {
  spectrum_for_0235 <- list(c(1, 2, 7), c(3, 9), c(5, 10, 11))
  spectrum_in_13edo <- list(c(1, 2, 8), c(3, 10), c(5, 11, 12))
  expect_equal(intervalspectrum(c(0, 2, 3, 5)), spectrum_for_0235)
  expect_equal(intervalspectrum(c(0, 2, 3, 5), edo=13), spectrum_in_13edo)

  expect_equal(intervalspectrum(c(0, 2)), list(c(2, 10)))
  expect_equal(intervalspectrum(0), list())
})

test_that("spectrumcount works", {
  expect_equal(spectrumcount(0), list())

  just_dia <- 12 * log2(c(1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8))
  expect_equal(spectrumcount(just_dia), c(3, 3, 3, 3, 3, 3))
  expect_equal(spectrumcount(just_dia, rounder=0), c(2, 2, 2, 2, 2, 2))

  expect_equal(spectrumcount(c(0, 2, 4, 7, 9, 12, 14), edo=17),
                             c(2, 2, 2, 2, 2, 2))
})