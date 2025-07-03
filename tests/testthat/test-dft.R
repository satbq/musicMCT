test_that("set_to_distribution works", {
  expect_equal(set_to_distribution(c(0, 4, 7)), 
               c(1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0))
  expect_equal(s2d(c(0, 4, 7)), 
               c(1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0))
  expect_equal(set_to_distribution(c(12, 7, 16)), 
               c(1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0))
  expect_equal(set_to_distribution(c(2, tn(edoo(4), 2))),
               c(0, 0, 2, 0, 0, 1, 0, 0, 1, 0, 0, 1))
  expect_equal(set_to_distribution(c(0, 1, 2), edo=4),
               c(1, 1, 1, 0))
  expect_error(set_to_distribution(c(0, 3.5, 7)))
})
