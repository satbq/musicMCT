test_that("convert works", {
  expect_equal(convert(c(0,1,3), 6, 12), c(0,2,6))
  expect_equal(convert(c(0,3,7), 12, 1), c(0, 1/4, 7/12))
})

test_that("coord-edo conversions work", {
  expect_equal(coord_to_edo(c(0, 1, 3, 5, 6, 8, 10)), 
               c(0, -5, -3, -1, -6, -4, -2)/7)
  expect_equal(coord_from_edo(c(0,0,1,1)), c(0,3,7,10))
})
