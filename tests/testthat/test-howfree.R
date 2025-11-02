test_that("howfree measures correctly", {
  expect_equal(howfree(5), 0)
  expect_equal(howfree(c(0,3,6,9)), 0)
  expect_equal(howfree(c(0,2,4,5,7,9,11)), 1)
})

test_that("howfree edo words", {
  expect_equal(howfree(convert(c(0,1,3,5,8),11,12)), 1)
  expect_equal(howfree(convert(c(0,1,3,5,8),11,12), edo=15), 3)
})

test_that("howfree rounder works", {
  just_dia <- 12*log2(c(1,9/8,5/4,4/3,3/2,5/3,15/8))
  expect_equal(howfree(just_dia, rounder=0), 1)
})

test_that("howfree accepts alternate ineqmats", {
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
  expect_equal(howfree(c(0,3,4,8)), 2)
  expect_equal(howfree(c(0,3,4,8), ineqmat=novel_ineqmat), 1)

  expect_equal(howfree(c(0, 3, 6), ineqmat="rosy"), 0)
  expect_equal(howfree(c(0, 2, 4, 5, 7, 9, 11), ineqmat="rosy"), 0)
  expect_equal(howfree(c(0, 4, 7), ineqmat="white"), 1)
})

test_that("howfree offset works", {
  expect_equal(howfree(c(0, 4, 7), ineqmat="black"), 1)
  expect_equal(howfree(c(1, 5, 8), ineqmat="black"), 2)
  expect_equal(howfree(c(1, 5, 8), ineqmat="gray"), 1)

  expect_equal(howfree(c(0, 3, 7, 10, 0, 4, 7, 11), ineqmat="anaglyph"),
               2)
})