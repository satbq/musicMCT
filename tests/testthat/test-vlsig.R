test_that("vl_generators works", {
  expect_error(vl_generators(c(0, 4, 8)))

  generic_intervals <- c(1, 2)
  specific_intervals <- c(5, 9)
  triad_matrix <- rbind(generic_intervals, specific_intervals)
  expect_equal(vl_generators(c(0, 4, 7)), triad_matrix)

  dia <- c(0, 2, 4, 5, 7, 9, 11)
  dia_matrix <- matrix(c(4, 7), nrow=2)
  rownames(dia_matrix) <- c("generic_intervals", "specific_intervals")
  expect_equal(vl_generators(dia), dia_matrix)
  
  qj_dia <- c(0, 3, 5, 6, 9, 11, 14)
  qj_dia_matrix <- matrix(c(2, 4, 5, 9), byrow=TRUE, nrow=2)
  rownames(qj_dia_matrix) <- c("generic_intervals", "specific_intervals")
  expect_equal(vl_generators(qj_dia, edo=15), qj_dia_matrix)

  chrom_genus <- c(0, 1, 2, 5, 7, 8, 9)
  cg_matrix <- matrix(c(6, 3, 4, 1, 11, 6, 8, 3), byrow=TRUE, nrow=2)
  rownames(cg_matrix) <- c("generic_intervals", "specific_intervals")
  expect_equal(vl_generators(chrom_genus), cg_matrix)

  maj7 <- c(0, 4, 7, 11)
  maj7_mat_t <-  matrix(c(1, 2, 4, 7), byrow=TRUE, nrow=2)
  maj7_mat_e <-  matrix(c(2, 1, 7, 4), byrow=TRUE, nrow=2)
  rownames(maj7_mat_t) <- c("generic_intervals", "specific_intervals")
  rownames(maj7_mat_e) <- c("generic_intervals", "specific_intervals")
  expect_equal(vl_generators(maj7), maj7_mat_t)
  expect_equal(vl_generators(maj7, method="euclidean"), maj7_mat_e)
})

