test_that("iswellformed works", {
  expect_true(iswellformed(c(0, 2, 4, 6)))
  expect_true(iswellformed(c(0, 1, 3, 5, 6, 8, 10)))
})
