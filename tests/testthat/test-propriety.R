test_that("isproper works", {
  pyth_dia <- sort(((0:6)*12*log2(1.5))%%12)
  just_dia <- 12 * log2(c(1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8))
  expect_false(isproper(c(0, 2, 4, 5, 7, 9, 11)))
  expect_true(isproper(c(0, 2, 4, 5, 7,9 ,11), strict=FALSE))
  expect_false(isproper(pyth_dia))
  expect_true(isproper(pyth_dia, rounder=0, strict=FALSE))
  expect_true(isproper(just_dia))

  expect_false(isproper(c(0, 7, 9), edo=19))
  expect_true(isproper(c(0, 7, 10), edo=19))
})
