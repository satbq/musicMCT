test_that("minimizeVL options behave as expected", {
  CM <- c(0, 4, 7)
  DM <- c(2, 6, 9)
  expect_equal(minimizeVL(CM, DM), matrix(c(2, -3, 2, -2, 2, -1), nrow=2))
  expect_equal(minimizeVL(CM, DM, no_ties=TRUE), c(2, 2, 2))
  expect_equal(minimizeVL(CM, DM, method="euclidean"), c(2, 2, 2))
  expect_equal(minimizeVL(CM, DM, edo=10), c(-1, -2, -1))
  expect_error(minimizeVL(CM, DM, method="badmethod"))
  expect_error(minimizeVL(c(0,3,7), c(0,3,7,10)))
})

test_that("whichmodebest words", {
  expect_equal(whichmodebest(c(0, 4, 7), c(7, 0, 4)), 2)
  expect_equal(whichmodebest(c(7, 0, 4), c(0, 4, 7)), 3)
  expect_equal(whichmodebest(c(0, 4, 7), c(2, 6, 9)), c(1, 3))
  expect_equal(whichmodebest(c(0, 4, 7), c(2, 6, 9),
                             method="euclidean"), 
               1)

  pyth_locrian <- 12 * log2(c(1, 256/243, 32/27, 4/3, 1024/729, 128/81, 16/9))
  pyth_lydian  <- 12 * log2(c(1, 9/8, 81/64, 729/512, 3/2, 27/16, 243/128))
  expect_equal(whichmodebest(pyth_locrian, pyth_lydian), 7)

  expect_equal(whichmodebest(c(0, 6, 11), c(6, 12, 17), edo=19), 3)
})
