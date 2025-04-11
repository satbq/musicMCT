test_that("affected_generic_intervals works", {
  expect_equal(affected_generic_intervals(c(0, -2, 0, 1, 0, 1, -1), 6), 2)
})

test_that("get_relevant_rows gets relevant rows", {
  tetra_ineqmat <- matrix(c(-1, -1, 0, -2, -1, -1, -2, 0,
                            2, 1, -1, 1, -1, 0, 0, -2,
                            -1, 1, 2, 0, 1, -1, 2, 0,
                            0, -1, -1, 1, 1, 2, 0, 2,
                            0, 0, 0, -1, -1, -1, -1, -1), nrow=8)
  expect_equal(get_relevant_rows(2, tetra_ineqmat), c(2, 5, 7, 8))
})
