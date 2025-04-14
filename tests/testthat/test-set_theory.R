test_that("primeform works", {
  expect_equal(primeform(c(0,1,7)), c(0,1,6))
  expect_equal(primeform(c(0,3,4,8)), c(0,1,4,8))
  expect_equal(primeform(c(4,6,9,10,1)), c(0,1,4,6,9))
  expect_equal(primeform(c(10,4,6,9,1)), c(0,1,4,6,9))  
  expect_equal(primeform(c(0,1,2,4,5,7,9,10)), c(0,1,3,4,5,7,8,10))
  expect_equal(primeform(c(3, 14, 0, 2, 6, 12, 9, 11, 17), edo=19), 
                         c(0, 1, 3, 5, 8, 10, 11, 13, 16))

  just_dia <- 12 * log2(c(1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8))
  just_prime <- 12 * log2(c(1, 16/15, 32/27, 4/3, 64/45, 8/5, 16/9))
  expect_equal(primeform(just_dia), just_prime)
})
