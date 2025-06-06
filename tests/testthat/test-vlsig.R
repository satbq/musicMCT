test_that("vl_generators works", {
  expect_warning(vlgen_dim <- dim(vl_generators(c(0, 4, 8))))
  expect_equal(vlgen_dim, c(2, 0))

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
  cg_matrix <- matrix(c(1, 3, 4, 6, 3, 6, 8, 11), byrow=TRUE, nrow=2)
  rownames(cg_matrix) <- c("generic_intervals", "specific_intervals")
  expect_equal(vl_generators(chrom_genus), cg_matrix)

  maj7 <- c(0, 4, 7, 11)
  maj7_mat <-  matrix(c(1, 2, 4, 7), byrow=TRUE, nrow=2)
  rownames(maj7_mat) <- c("generic_intervals", "specific_intervals")
  expect_equal(vl_generators(maj7), maj7_mat)
})


test_that("vlsig works", {
  major_triad <- c(0, 4, 7)
  expect_equal(vlsig(major_triad)$"vl", c(0, 1, 2))
  expect_equal(vlsig(major_triad)$"tn", 5)
  expect_equal(vlsig(major_triad)$"rotation", 1)

  expect_equal(vlsig(major_triad, 2)$"vl", c(1, 0, 2))
  expect_equal(vlsig(major_triad, 2)$"tn", 9)
  expect_equal(vlsig(major_triad, 2)$"rotation", 2)

  expect_equal(vlsig(c(0, 6, 11), edo=19)$"vl", c(0, 2, 3))

  gh <- c(0, 2, 4, 5, 7, 9)
  expect_equal(vlsig(gh, 1)$"vl", c(0, 1, 1, 2, 1, 1))

  expect_error(vlsig(c(0, 2, 4, 5, 7, 9, 11), 2))
  expect_error(vlsig(major_triad, 0))
})
