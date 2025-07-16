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

test_that("sim interscalar functionality works", {
  goal_1 <- matrix(c(0, 1, 0,
                     4, 4, 5,
                     7, 9, 9),
                   nrow=3, byrow=TRUE)
  goal_2 <- matrix(c(0, 2, 2,
                     5, 6, 5,
                     9, 9, 10),
                   nrow=3, byrow=TRUE)
  goal_3 <- matrix(c(0, 4, -3,
                     7, 1, 5,
                     4, 9, 12),
                   nrow=3, byrow=TRUE)
  minor <- c(0, 3, 7)
  major <- c(0, 4, 7)
  major_64 <- c(0, 5, 9)
  major_open <- c(0, 7, 4)

  expect_equal(sim(minor, major), goal_1)
  expect_equal(sim(minor, major+2), goal_1)
  expect_equal(sim(minor, major_64), goal_2)
  expect_equal(sim(minor, major_open), goal_3)
})