test_that("make_white_ineqmat works", {
  white_trichord_mat <- matrix(c(-3, 3, 0, -1,
                                 -1.5, 0, 1.5, -1,
                                 0, -3, 3, -1), 
                               byrow=TRUE, nrow=3)
  expect_equal(make_white_ineqmat(3), white_trichord_mat)
  expect_equal(dim(make_white_ineqmat(7))[1], 21)
  expect_equal(dim(make_white_ineqmat(10))[1], 45)

  expect_snapshot(make_white_ineqmat(12))
})
