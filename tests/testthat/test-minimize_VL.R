test_that("minimizeVL options behave as expected", {
  CM <- c(0, 4, 7)
  DM <- c(2, 6, 9)
  expect_equal(minimizeVL(CM, DM), matrix(c(2, -3, 2, -2, 2, -1), nrow=2))
  expect_equal(minimizeVL(CM, DM, no_ties=TRUE), c(2, 2, 2))
  expect_equal(minimizeVL(CM, DM, method="euclidean"), c(2, 2, 2))
  expect_equal(minimizeVL(CM, DM, edo=10), c(-1, -2, -1))
  expect_error(minimizeVL(CM, DM, method="badmethod"))
  expect_warning(minimizeVL(c(0,3,7), c(0,3,7,10)))
})

