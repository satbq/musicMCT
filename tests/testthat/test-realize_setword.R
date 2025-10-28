test_that("realize_stepword works", {
  expect_equal(realize_stepword(3), 0)
  expect_equal(realize_stepword(c(1, 1)), c(0, 6))
  expect_equal(realize_stepword(c(2, 2)), c(0, 6))
  expect_equal(realize_stepword(c(1, 1), edo=16), c(0, 8))
  expect_equal(realize_stepword(c(1, 2, 3, 2)), c(0, 1.5, 4.5, 9))  
  expect_equal(realize_stepword(c(1, 4, 2, 3, 2, 1), reconvert=FALSE)$set, 
               c(0, 1, 5, 7, 10, 12))
})

test_that("realize_stepword warns for nonpositive entries", {
  expect_warning(realize_stepword(c(1, 2, -1)))
  expect_warning(realize_stepword(c(2, 1, 0, 3)))
})

test_that("realize_stepword warns for noninteger entries", {
  expect_warning(realize_stepword(c(3, 2, 1/3)))
})
