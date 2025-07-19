test_that("make_offset_ineqmat works", {
  v <- c(0, 1, 6)
  expect_equal(signvector(v, ineqmat=make_offset_ineqmat(v, ineqmat="pastel")),
               c(0, 0, 0, 0, 0, 0))

  jd <- j(dia)
  expect_equal(signvector(jd, ineqmat=make_offset_ineqmat(jd)), 
               rep(0, 42))

  goal_dyad_ineqmat <- matrix(c(-2, 2, -2/3), nrow=1)
  expect_equal(make_offset_ineqmat(c(0, 4)), goal_dyad_ineqmat)

  expect_warning(make_offset_ineqmat(4))
})
