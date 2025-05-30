test_that("iswellformed works", {
  expect_true(iswellformed(c(0, 2, 4, 6)))
  expect_false(iswellformed(c(0, 4, 6)))

  expect_true(iswellformed(c(0, 1, 3, 5, 6, 8, 10)))
  expect_false(iswellformed(c(0, 1, 3, 4, 6, 8, 10)))

  qcm_fifth <- meantone_fifth()
  qcm_dia <- sort(((0:6)*qcm_fifth)%%12)
  expect_true(iswellformed(qcm_dia))
  expect_false(iswellformed(qcm_dia, rounder=14))

  expect_true(iswellformed(c(0, 2, 4, 7, 9, 12, 14), edo=17))

  expect_false(iswellformed(3))
  expect_true(iswellformed(3, allow_de=TRUE))
  expect_false(iswellformed(c(0, 4, 8)))
  expect_true(iswellformed(c(0, 4, 8), allow_de=TRUE))
  expect_false(iswellformed(c(0, 1, 6, 7)))
  expect_true(iswellformed(c(0, 1, 6, 7), allow_de=TRUE))

  expect_true(iswellformed(NULL, c(1, 1, 2, 1, 2)))
  expect_false(iswellformed(c(0, 2, 3, 7, 8), c(1, 1, 2, 1, 2)))
  expect_false(iswellformed(NULL, c(2, 1, 3, 1, 3)))  
})

test_that("isgwf detects 12edo PWF scales correctly", {
  expect_true(isgwf(c(0, 2, 4, 7, 9)))
  expect_true(isgwf(c(0, 2, 3, 7, 8)))
  expect_false(isgwf(c(0, 2, 4, 7, 10)))
  expect_true(isgwf(c(0, 1, 2, 5, 6, 8, 9)))
})

test_that("isgwf handles irrational values correctly", {
  just_dia <- 12 * log2(c(1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8))
  just_dia_inv <- charm(just_dia)
  expect_true(isgwf(just_dia))
  expect_true(isgwf(just_dia_inv))
  expect_false(isgwf(just_dia, rounder=14))
})

test_that("isgwf allow_de parameter behaves", {
  expect_false(isgwf(c(0, 2, 4, 5, 7, 9)))
  expect_true(isgwf(c(0, 2, 4, 5, 7, 9), allow_de=TRUE))
})

test_that("isgwf correctly detects n-wise WF for n > 2", {
  expect_true(isgwf(c(0, 4, 6, 10, 13, 14, 18), edo=21))
  expect_true(isgwf(c(0, 1, 4, 9, 11), edo=15))
  expect_false(isgwf(c(0, 23, 33, 42, 48, 60, 62), edo=63))
})

test_that("isgwf setword parameter behaves", {
  expect_true(isgwf(NULL, c(2, 2, 1, 2, 2, 2, 1)))
  expect_true(isgwf(NULL, c(3, 2, 1, 3, 2, 3, 1)))
  expect_true(isgwf(NULL, c(1, 1, 3, 1, 2, 1, 3)))
  expect_false(isgwf(NULL, c(1, 1, 1, 3, 3, 1, 2)))
  expect_true(isgwf(NULL, c(1, 3, 5, 2, 4)))

  expect_false(isgwf(NULL, c(2, 2, 1, 2, 2, 3)))
  expect_true(isgwf(NULL, c(2, 2, 1, 2, 2, 3), allow_de=TRUE))

  expect_false(isgwf(NULL, c(1, NA, 3)))
})
