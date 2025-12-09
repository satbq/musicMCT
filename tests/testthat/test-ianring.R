test_that("ianring function calculates index value correctly", {
  expect_equal(ianring(c(0, 2, 4, 5, 7, 9, 11), is_interactive=FALSE), 
               2741)
})
