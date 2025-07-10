test_that("quantize_color basic functionality works", {
  just_dia <- 12 * log2(c(1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8))
  expect_equal(quantize_color(just_dia)$edo, 15)
  expect_equal(quantize_color(just_dia)$set, c(0, 3, 5, 6, 9, 11, 14))
  expect_equal(quantize_color(c(0,4,8,12),edo=14,reconvert=TRUE), c(0,4,8,12))
  expect_equal(quantize_color(convert(c(0,4,8,12),14,12),reconvert=TRUE), c(0,24,48,72)/7)
  expect_equal(round(quantize_color(c(0,3,7,9,12,13,16), edo=12, reconvert=TRUE), 2),
               c(0, 2.06, 4.46, 6.17, 8.23, 9.6, 11.66))
})

test_that("quantize_color nmax parameter behaves as expected", {
  difficult_to_quantize <- convert(c(0, 1, 4, 8, 13, 19, 32), 34, 12)
  expect_equal(sum(is.na(quantize_color(difficult_to_quantize, reconvert=TRUE))), 7)
  expect_equal(quantize_color(difficult_to_quantize, nmax=13)$set, c(0,1,4,8,13,19,32))
})

test_that("quantize_color accepts alternate ineqmats", {
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
  expect_equal(quantize_color(c(0,3,4,8))$set, c(0,2,3,6))
  expect_equal(quantize_color(c(0,3,4,8),ineqmat=novel_ineqmat)$set, c(0,3,4,8))
})

test_that("quantize_hue works", {
  triad_in_6 <- list(set=c(0,2,3), edo=6)
  expect_equal(quantize_hue(c(0, 4, 7)), triad_in_6)
  expect_equal(quantize_hue(c(0, 2, 3, 7), reconvert=TRUE), c(0, 2, 3, 7))
  expect_equal(quantize_hue(c(0, 4, 5, 10), reconvert=TRUE, edo=16),
               c(0, 4, 5, 10))

  pyth_dia <- sort((12*log2(1.5)*(0:6))%%12)
  just_dia <- 12 * log2(c(1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8))
  expect_equal(quantize_hue(pyth_dia)$"set", c(0, 2, 4, 6, 7, 9, 11))
  expect_equal(sum(is.na(quantize_hue(just_dia, reconvert=TRUE))), 7)
})

test_that("quantization param target_edo works", {
  test1_res <- list(set=c(0, 4, 7, 9, 13, 16, 20), edo=22)
  expect_equal(quantize_color(j(dia), target_edo=22), test1_res)

  test2_res <- list(set=c(0, 2, 6, 9), edo=16)
  expect_equal(quantize_hue(c(0, 1, 4, 6), target_edo=16), test2_res)

  expect_equal(quantize_color(j(dia), target_edo=12, reconvert=TRUE),
               rep(NA, 7))
})
