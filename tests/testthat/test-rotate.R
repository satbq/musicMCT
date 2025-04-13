test_that("rotate works", {
  expect_equal(rotate(c(1,2,3,4,5)), c(2,3,4,5,1))
  expect_equal(rotate(c(1,2,3,4,5), n=1), c(2,3,4,5,1))
  expect_equal(rotate(c(1,2,3,4,5), n=3), c(4,5,1,2,3))
  expect_equal(rotate(c(1,2,3,4,5), n=5), c(1,2,3,4,5))
  expect_equal(rotate(c(1,2,3,4,5), n=6), rotate(c(1,2,3,4,5), n=1))
  expect_equal(rotate(c(1,2,3,4,5), n=-1), rotate(c(1,2,3,4,5), n=4))
  expect_equal(rotate(c(1,2,3,4,5), n=-5), rotate(c(1,2,3,4,5), n=0))
})

test_that("rotate transpose_up works", {
  expect_equal(rotate(c(0,3,7), n=2, transpose_up=TRUE), c(7, 12, 15))
  expect_equal(rotate(c(0,3,7), n=2, transpose_up=TRUE, edo=13), c(7, 13, 16))
})

test_that("rotate warns for unusual parameter combinations", {
  expect_warning(rotate(c(0,4,7,10), n=-1, transpose_up=TRUE))
  expect_warning(rotate(c(0,4,7,10), n=5, transpose_up=TRUE))
})
