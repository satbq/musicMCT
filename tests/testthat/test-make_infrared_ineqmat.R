test_that("make_infrared_ineqmat works", {
  trichord_with_false_mat <- matrix(c(-1, 2, -1, 0,
                                      -3, 3, 0, -1,
                                      -1.5, 0, 1.5, -1,
                                      0, -3, 3, -1),
                                    byrow=TRUE, nrow=4)
  expect_equal(make_infrared_ineqmat(3, include_wraparound=FALSE), 
               trichord_with_false_mat)
  expect_snapshot(make_infrared_ineqmat(5, include_wraparound=TRUE))
  expect_snapshot(make_infrared_ineqmat(6))
})
