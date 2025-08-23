test_that("fpunique works", {
  just_dia <- 12 * log2(c(1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8))
  semitone <- 12 * log2(16/15)
  just_atonal <- c(0, semitone, 6, 6+semitone+1e-13)

  expect_length(fpunique(sort(sim(just_dia))), 19)
  expect_length(fpunique(sort(sim(just_dia)), rounder=0), 12)
  expect_equal(dim(fpunique(sim(just_atonal), MARGIN=2))[2], 2)
  expect_equal(dim(fpunique(t(sim(just_atonal)), MARGIN=1))[1], 2)
})

test_that("fpmod works", {
  pretty_small <- 1e-9
  satb_maj <- c(0, 4, 7, 12-pretty_small)
  satb_maj_19 <- c(0, 6, 11, 19-pretty_small)

  expect_equal(fpmod(satb_maj), satb_maj)
  expect_equal(fpmod(satb_maj, rounder=8), c(0, 4, 7, 0))
  expect_equal(fpmod(satb_maj_19, edo=19), satb_maj_19)
  expect_equal(fpmod(satb_maj_19, edo=19, rounder=8), c(0, 6, 11, 0))
})