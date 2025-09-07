test_that("utils work", {
  expect_true(coprime_to_edo(5,12))
})

test_that("multiset_diff works", {
  set_a <- c(0, 0, 3, 5, 4)
  set_b <- c(0, 3, 4, 4, 6)
  expect_equal(multiset_diff(set_a, set_b), c(0, 5))
  expect_equal(multiset_diff(set_b, set_a), c(4, 6))
})
