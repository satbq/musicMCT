test_that("saturate works", {
  expect_equal(saturate(0, c(0,4,7)), c(0,4,8))
  expect_equal(saturate(1, c(0,4,7)), c(0,4,7))
  expect_equal(saturate(2, c(0,4,7)), c(0,4,6))
  expect_equal(saturate(-1, c(0,4,7)), c(0,4,9))

  expect_equal(saturate(2, c(0,4,7), edo=15), c(0,3,4))
})

test_that("same_hue works", {
  expect_true(same_hue(c(0, 4, 7), c(0, 4, 5)))
  expect_true(same_hue(c(0, 3, 6, 8, 12), c(0, 3, 6, 7, 12), edo=15))
  expect_true(same_hue(edoo(4), edoo(4)))
  expect_false(same_hue(c(0, 3, 6), c(0, 5, 10)))
  expect_false(same_hue(edoo(7), c(0, 1, 4, 5, 7, 8, 11)))
  expect_false(same_hue(c(0, 4, 7), c(0, 5, 6)))

  expect_error(same_hue(c(0, 2, 7), c(0, 3, 5, 8)))
  expect_error(same_hue(integer(0), edoo(4)))
})
