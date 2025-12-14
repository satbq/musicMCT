test_that("coprime_to_edo works", {
  expect_true(coprime_to_edo(5,12))
})

test_that("multiset_diff works", {
  set_a <- c(0, 0, 3, 5, 4)
  set_b <- c(0, 3, 4, 4, 6)
  expect_equal(multiset_diff(set_a, set_b), c(0, 5))
  expect_equal(multiset_diff(set_b, set_a), c(4, 6))
})

test_that("pivot_columns works", {
  test_matrix <- matrix(c(1, 1, 0, 0, 0,
                          0, 0, 1, 3, 0,
                          0, 0, 0, 1, 0,
                          0, 0, 0, 0, 0),
                        nrow=4,
                        byrow=TRUE)
  expect_equal(pivot_columns(test_matrix), c(1, 3, 4))
})
