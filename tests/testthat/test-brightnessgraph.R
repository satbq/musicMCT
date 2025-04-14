test_that("bg_reduction works", {
  goal_matrix <- matrix(c(0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0), nrow=4)
  expect_equal(bg_reduction(c(0,1,2,7)), goal_matrix)
})

test_that("brightness graph images consistent", {
  c_major_19edo <- c(0,3,6,8,11,14,17)
  cmaj_bg <- function() brightnessgraph(c_major_19edo, edo=19)
  vdiffr::expect_doppelganger("Brightness Graph for C major in 19edo",
                               cmaj_bg)
})
