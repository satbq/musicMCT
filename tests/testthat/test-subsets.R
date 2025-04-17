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

test_that("subset_varieties works", {
  expect_equal(subset_varieties(c(0, 2, 4), c(0, 2, 3, 5, 7, 9, 11)),
               matrix(c(0, 3, 7, 0, 4, 8, 0, 4, 7, 0, 3, 6), ncol=4))
  expect_equal(subset_varieties(c(0, 1, 2), c(0, 2, 3, 7, 8), unique=FALSE),
               matrix(c(0, 2, 3, 0, 1, 5, 0, 4, 5, 0, 1, 5, 0, 4, 6), ncol=5))
  expect_equal(subset_varieties(c(0, 1, 3), c(0, 2, 3, 4, 6, 8), edo=17),
               matrix(c(0, 2, 4, 0, 1, 4, 0, 1, 5, 0, 2, 13, 0, 9, 12), ncol=5))
})

test_that("subsetspectrum works with default params", {
  penta_result <- list(matrix(c(0, 2, 0, 3), ncol=2), 
                       matrix(c(0, 4, 0, 5), ncol=2))
  names(penta_result) <- c("0, 1", "0, 2")
  expect_equal(subsetspectrum(c(0, 2, 4, 7, 9), 2), penta_result)

  dim7_result <- list(matrix(c(0, 3, 6), ncol=1))
  names(dim7_result) <- "0, 1, 2"
  expect_equal(subsetspectrum(c(0, 3, 6, 9), 3),
               dim7_result)
})

test_that("subsetspectrum tni mode works", {
  hexa_result <- list(matrix(c(0, 1, 3, 0, 2, 4, 0, 2, 5, 0, 3, 4), ncol=4),
                      matrix(c(0, 1, 5, 0, 2, 6, 0, 2, 7, 0, 3, 6), ncol=4),
                      matrix(c(0, 3, 7, 0, 4, 8, 0, 4, 9, 0, 5, 8), ncol=4))
  names(hexa_result) <- c("0, 1, 2", "0, 1, 3", "0, 2, 4")
  expect_equal(subsetspectrum(c(0, 1, 3, 5, 7, 9), 3, mode="tni"),
               hexa_result)
})

test_that("subsetspectrum edo parameter works", {
  dia_result <- list(matrix(c(0, 3, 0, 2), nrow=2),
                     matrix(c(0, 6, 0, 5), nrow=2),
                     matrix(c(0, 8, 0, 9), nrow=2))
  names(dia_result) <- c("0, 1", "0, 2", "0, 3")
  expect_equal(subsetspectrum(c(0, 3, 6, 8, 11, 14, 17), 2, edo=19),
               dia_result)
})

test_that("subsetspectrum simplify can be turned off", {
  tetra_result <- list(matrix(c(0, 1, 0, 5), ncol=2),
                       matrix(c(0, 2, 0, 6, 0, 10), ncol=3),
                       matrix(c(0, 7, 0, 11), ncol=2))
  names(tetra_result) <- c("0, 1", "0, 2", "0, 3")
  expect_equal(subsetspectrum(c(0, 1, 2, 7), 2, simplify=FALSE), 
               tetra_result)
})