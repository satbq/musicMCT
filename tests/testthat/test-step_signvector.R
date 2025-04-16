test_that("step_signvector works", {
  expect_equal(step_signvector(c(0, 5, 8)), c(1, 1, -1))

  just_pent <- 12 * log2(c(1, 9/8, 5/4, 3/2, 5/3))
  expect_equal(step_signvector(just_pent), c(1, -1, -1, 1, 0, 1, -1, -1, 0, -1))
  expect_equal(step_signvector(just_pent, rounder=0),
               c(0, -1, -1, 0, 0, 1, -1, -1, 0, -1))


  custom_ineqmat <- matrix(c(-4, 4, 0, 0, -1,
                             -2, 0, 2, 0, -1,
                             -4/3, 0, 0, 4/3, -1,
                             0, -4, 4, 0, -1,
                             0, -2, 0, 2, -1,
                             0, 0, -4, 4, -1), 
                           nrow=6, byrow=TRUE)
  expect_equal(step_signvector(c(0, 3, 5, 8)), c(1, 0, -1, -1, -1, -1))
  expect_equal(step_signvector(c(0, 3, 5, 8), ineqmat=custom_ineqmat), c(0, -1, -1, 0))
})
