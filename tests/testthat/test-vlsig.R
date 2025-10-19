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

  expect_equal(dim(vl_generators(c(0, 0, 6, 0))), c(2, 3))
})


test_that("vlsig works", {
  major_triad <- c(0, 4, 7)
  maj_triad_res <- matrix(c(0, 1, 2, 1, 0, 2), nrow=2, byrow=TRUE)
  expect_equal(vlsig(major_triad, index=1)$"vl", c(0, 1, 2))
  expect_equal(vlsig(major_triad, index=1)$"tn", 5)
  expect_equal(vlsig(major_triad, index=1)$"rotation", 1)
  expect_equal(vlsig(major_triad, index=NULL), maj_triad_res)

  expect_equal(vlsig(major_triad, index=2)$"vl", c(1, 0, 2))
  expect_equal(vlsig(major_triad, index=2)$"tn", 9)
  expect_equal(vlsig(major_triad, index=2)$"rotation", 2)

  expect_equal(vlsig(c(0, 6, 11), index=1, edo=19)$"vl", c(0, 2, 3))

  gh <- c(0, 2, 4, 5, 7, 9)
  expect_equal(vlsig(gh, index=1)$"vl", c(0, 1, 1, 2, 1, 1))

  expect_error(vlsig(c(0, 2, 4, 5, 7, 9, 11), index=2))
  expect_error(vlsig(major_triad, index=0))
})

test_that("inter_vlsig works", {
  jdia_matrix <- matrix(c(0, 0, 0, .92, 0, 0, 0,
                   .22, 0, .22, .22, .22, .22, .22,
                   .71, .71, 0, .71, .71, 0, 0),
                   nrow=3, byrow=TRUE)
  expect_equal(inter_vlsig(j(dia)), jdia_matrix)
  expect_equal(inter_vlsig(j(dia), index=1)$tni, j(7))
  expect_equal(inter_vlsig(j(dia), index=1)$rotation, 0)

  triad_matrix <- matrix(c(1, 0, 1, 0, 1, 1, 0, 0, 2), 
                         nrow=3, byrow=TRUE)
  expect_equal(inter_vlsig(c(0, 4, 7)), triad_matrix)

  hexachord <- c(0, 2, 7, 12, 16, 17)
  h_res1 <- list(vl=c(0, 2, 2, 2, 0, 6), tni=16, rotation=5)
  h_res2 <- list(vl=c(-2, 0, 0, 0, -2, 4), tni=14, rotation=5)
  expect_equal(inter_vlsig(hexachord, index=6, type="ascending", edo=24),
               h_res1)
  expect_equal(inter_vlsig(hexachord, index=6, type="commontone", edo=24),
               h_res2)  

  expect_error(inter_vlsig(c(0,2,7), c(0,1,5,7)))

  must_be_matrix <- matrix(c(2, 0, 1, 0, 3, 0), nrow=2, byrow=TRUE)
  expect_equal(inter_vlsig(c(0, 3, 7), c(0, 1, 6), index=1), 
               must_be_matrix)

  petrushka <- c(0, 1, 3, 6, 7, 9)
  petrushka_mat <- matrix(c(0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1), 
                          nrow=2, byrow=TRUE)
  expect_equal(inter_vlsig(petrushka), petrushka_mat)

  obverse_mat <- matrix(c(0, 1, 0, 1, 0, 0, 2, 2, 0), nrow=3, byrow=TRUE)
  expect_equal(inter_vlsig(c(0, 4, 7), type="obverse"), obverse_mat)
})
