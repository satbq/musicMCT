test_that("brightness_comparisons matrix has correct values", {
  test_comps <- brightness_comparisons(c(0, 3, 7))
  dimnames(test_comps) <- NULL
  expect_equal(test_comps, 
               matrix(c(0, 1, 1, -1, 0, 0, -1, 0, 0),nrow=3))
})

test_that("brightness_comparisons goal param works", {
  torb <- c(0, 4, 7, 14, 15)
  brig <- c(0, 1, 8, 11, 15)
  test_comps <- brightness_comparisons(torb, brig, edo=23)
  dimnames(test_comps) <- NULL
  result <- matrix(c(0, 0, -1, 0, -1, 0, -1, 0, 0, -1,
                     0, 0, 0, 0, -1, 1, -1, 0, -1, 0,
                     1, 0, 0, 0, 0, 1, 0, 1, 0, 0,
                     0, 0, 0, 0, -1, 1, -1, 0, -1, -1,
                     1, 1, 0, 1, 0, 1, 1, 1, 1, 0,
                     0, -1, -1, -1, -1, 0, -1, 0, -1, -1,
                     1, 1, 0, 1, -1, 1, 0, 0, 0, 0,
                     0, 0, -1, 0, -1, 0, 0, 0, 0, -1,
                     0, 1, 0, 1, -1, 1, 0, 0, 0, 0,
                     1, 0, 0, 1, 0, 1, 0, 1, 0, 0),
                     byrow=TRUE, nrow=10)
  expect_equal(test_comps, result)
})

test_that("delta and eps work", {
  test_scale <- c(0, 2, 3, 5, 6, 7)
  expect_equal(delta(test_scale), 12)
  expect_equal(eps(test_scale), 6)
})

test_that("brightness ratio works", {
  expect_equal(ratio(c(0, 2, 4, 5, 7, 9, 11)), 0)
  expect_equal(ratio(c(0, 4, 7)), 0)
  expect_equal(ratio(c(0, 2, 6)), 0)
  expect_equal(ratio(c(0, 2, 3, 7, 8)), 1/3)
  expect_equal(ratio(c(0, 1, 4, 9, 11), edo=15), 0.5)
})

test_that("delta, eps, ratio handle small sets well", {
  expect_true(is.na(delta(NA)))
  expect_true(is.na(delta(1)))
  expect_true(is.na(delta(NULL)))
  expect_true(is.na(delta(integer(0))))

  expect_true(is.na(eps(NA)))
  expect_true(is.na(eps(1)))
  expect_true(is.na(eps(NULL)))
  expect_true(is.na(eps(integer(0))))

  expect_true(is.na(ratio(NA)))
  expect_true(is.na(ratio(1)))
  expect_true(is.na(ratio(NULL)))
  expect_true(is.na(ratio(integer(0))))
})
