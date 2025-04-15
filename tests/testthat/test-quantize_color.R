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
  expect_equal(sum(is.na(quantize_color(difficult_to_quantize))), 7)
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