test_that("make_ultraviolet_ineqmat works", {
  expect_equal(dim(make_ultraviolet_ineqmat(5)), 
               dim(make_white_ineqmat(5)))

  expect_snapshot(make_ultraviolet_ineqmat(8))
})
