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

test_that("make_pastel_ineqmat works", {
  expect_equal(dim(make_pastel_ineqmat(4)), c(12, 5))
  expect_snapshot(make_pastel_ineqmat(6))
})

test_that("black and gray ineqmats work", {
  expect_equal(dim(make_black_ineqmat(53)), c(53, 54))
  expect_snapshot(make_black_ineqmat(7))
  expect_equal(make_gray_ineqmat(5), 
               rbind(make_white_ineqmat(5), make_black_ineqmat(5)))

  expect_equal(signvector(c(0, 4, 7), ineqmat="black"), c(0, 0, -1))
  expect_equal(signvector(c(1, 5, 8), ineqmat="black"), c(1, 1, 0))
})

