test_that("bg_reduction works", {
  goal_matrix <- matrix(c(0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0), nrow=4)
  expect_equal(bg_reduction(c(0,1,2,7)), goal_matrix)
})
