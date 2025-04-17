test_that("sim works", {
  goal_sim <- matrix(c(0, 0, 0, 0,
                       3, 1, 3, 5,
                       4, 4, 8, 8,
                       7, 9, 11, 9), 
                     nrow=4, byrow=TRUE)
  expect_equal(sim(c(0, 3, 4, 7)), goal_sim)

  mod7_sim <- matrix(c(0, 0, 0, 0, 
                       2, 2, 2, 1, 
                       4, 4, 3, 3,
                       6, 5, 5, 5),
                     nrow=4, byrow=TRUE)
  expect_equal(sim(c(0, 2, 4, 6), edo=7), mod7_sim)
})
