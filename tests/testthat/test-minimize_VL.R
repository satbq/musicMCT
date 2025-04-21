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

test_that("whichmodebest works", {
  expect_equal(whichmodebest(c(0, 4, 7), c(7, 0, 4)), 2)
  expect_equal(whichmodebest(c(7, 0, 4), c(0, 4, 7)), 3)
  expect_equal(whichmodebest(c(0, 4, 7), c(2, 6, 9)), c(1, 3))
  expect_equal(whichmodebest(c(0, 4, 7), c(2, 6, 9), no_ties=TRUE), 1)
  expect_equal(whichmodebest(c(0, 4, 7), c(2, 6, 9),
                             method="euclidean"), 
               1)
  expect_equal(whichmodebest(c(0, 4, 6), c(10, 0, 4),
                             method="chebyshev"),
               c(1, 2))


  pyth_locrian <- 12 * log2(c(1, 256/243, 32/27, 4/3, 1024/729, 128/81, 16/9))
  pyth_lydian  <- 12 * log2(c(1, 9/8, 81/64, 729/512, 3/2, 27/16, 243/128))
  expect_equal(whichmodebest(pyth_locrian, pyth_lydian), 7)
  expect_equal(whichmodebest(pyth_locrian, pyth_lydian, method="hamming"), 1)

  expect_equal(whichmodebest(c(0, 6, 11), c(6, 12, 17), edo=19), 3)
})

test_that("flex_points works", {
  expect_equal(flex_points(c(0, 4, 7)), c(2, 6, 10))
  expect_equal(flex_points(c(0, 1, 6)), c(2.5, 6, 9.5))
  expect_equal(flex_points(c(0, 4, 7), method="euclidean"), 
               c(2.08, 6.00, 9.91))
  expect_equal(flex_points(c(0, 3, 6, 10, 13), edo=17),
               c(1.7, 5.1, 8.5, 11.9, 15.3))
  expect_equal(flex_points(c(0, 2, 3, 5, 7, 9, 11), subdivide=2),
               c(0.5, 2.5, 4.5, 6.0, 7.5, 9.5, 11.0))
})

test_that("tndists works", {
  m7_tndists <- function() tndists(c(0, 3, 5, 8))
  vdiffr::expect_doppelganger("tndists plot for minor 7th chord",
                              m7_tndists)
})

