test_that("vl_rolodex sorts results correctly", {
  expect_equal(strtoi(names(vl_rolodex(c(0, 1, 6)))), 
               c(0, 1, 11, 5, 7, 2, 4, 6, 8, 10, 3, 9))
  expect_equal(strtoi(names(vl_rolodex(c(0, 1, 6), reorder=FALSE))), 
               c(1:11, 0))
  expect_equal(strtoi(names(vl_rolodex(c(0, 2, 4), edo=7))),
               c(0, 2, 5, 3, 4, 1, 6))
})

test_that("vl_rolodex handles ties correctly", {
  tie_matrix <- matrix(c(0, -3, 3, -3, 3, 0), ncol=3)
  expect_equal(vl_rolodex(c(0, 3, 6))$"6",
               tie_matrix)

  expect_true("matrix" %in% class(vl_rolodex(c(0, 3, 6))$"6"))
  expect_false("matrix" %in% class(vl_rolodex(c(0, 3, 6), no_ties=TRUE)$"6"))
})

test_that("vl_rolodex method param works", {
  tie_matrix <- matrix(c(-4, -3, 0, -1, -2, 3, 1, 2), byrow=TRUE, nrow=2)
  expect_equal(vl_rolodex(c(0, 1, 4, 6), method="taxicab")$"4", 
               tie_matrix)
  expect_equal(vl_rolodex(c(0, 1, 4, 6), method="euclidean")$"4", 
               c(-2, 3, 1, 2))
})

test_that("vl_rolodex output format as intended", {
  expect_snapshot(vl_rolodex(c(0, 2, 3, 5, 7, 9, 11)))
  expect_snapshot(vl_rolodex(c(0, 4, 7, 10), c(0, 0, 4, 7)))
})