test_that("fpunique works", {
  just_dia <- 12 * log2(c(1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8))
  semitone <- 12 * log2(16/15)
  just_atonal <- c(0, semitone, 6, 6+semitone+1e-13)

  expect_length(fpunique(sort(sim(just_dia))), 19)
  expect_length(fpunique(sort(sim(just_dia)), rounder=0), 12)
  expect_equal(dim(fpunique(sim(just_atonal), MARGIN=2))[2], 2)
})
