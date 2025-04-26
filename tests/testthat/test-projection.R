test_that("independent_normals works", {
  expect_equal(independent_normals(integer(0), ineqmats[[3]]), integer(0))
  expect_equal(independent_normals(2, ineqmats[[3]]), 2)
  expect_equal(independent_normals(c(1, 4, 5, 9, 13, 14, 15), ineqmats[[5]]),
               c(1, 4, 9))
})