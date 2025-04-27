test_that("simplify_scale works", {
  rep_svs <- readRDS(test_path("testdata", "test_signvectors.rds"))
  col_adj <- readRDS(test_path("testdata", "test_adjacencies.rds"))
  rep_scl <- readRDS(test_path("testdata", "test_scales.rds"))

  simplified_0237 <- simplify_scale(c(0, 2, 3, 7), 
                                    scales=rep_scl,
                                    signvector_list=rep_svs,
                                    adjlist=col_adj,
                                    display_digits=NULL)
  simple_scales <- matrix(c(0,   0, 0,       0,       0,   0,   0,
                            1.5, 3, 2+(1/6), 1.5,     2.2, 3.8, 3,
                            3,   6, 3,       3,       4.4, 4.4, 4,
                            7.5, 9, 7.5,     7-(1/6), 6.6, 8.2, 7), 
                            nrow=4, byrow=TRUE)  
  rownames(simple_scales) <- c("sd 1", "sd 2", "sd 3", "sd 4")                                  
  
  expect_equal(simplified_0237[1:4, ], simple_scales)
  expect_equal(as.numeric(simplified_0237[5,] ),
               c(55, 0, 71, 54, 61, 86, 85))
  expect_equal(as.numeric(simplified_0237[6,] ),
               c(1, 0, 2, 2, 1, 1, 2))
  expect_equal(as.numeric(simplified_0237[8,] ),
               c(3, 8, 1, 1, 3, 3, 1))
  expect_equal(as.numeric(simplified_0237[7,]),
               c(sqrt(1/2), sqrt(5), sqrt(1/6), sqrt(1/6), sqrt(1.8), sqrt(1.8), 1))

  expect_equal(best_simplification(c(0, 2, 3, 6), scales=rep_scl,
                                   signvector_list=rep_svs, adjlist=col_adj),
               c(0, 1.9, 3.8, 5.7))
})

test_that("simplify_scale works in other edos", {
  rep_svs <- readRDS(test_path("testdata", "test_signvectors.rds"))
  col_adj <- readRDS(test_path("testdata", "test_adjacencies.rds"))
  rep_scl <- readRDS(test_path("testdata", "test_scales.rds"))

  simplified_x <- simplify_scale(c(0, 12, 18, 42), 
                                 scales=rep_scl,
                                 signvector_list=rep_svs,
                                 adjlist=col_adj,
                                 display_digits=NULL,
                                 edo=72)
  simple_scales <- matrix(c(0,  0,  0,  0,  0,    0,    0,
                            9,  18, 13, 9,  22.8, 13.2, 18,
                            18, 36, 18, 18, 26.4, 26.4, 24, 
                            45, 54, 45, 41, 49.2, 39.6, 42),
                            nrow=4, byrow=TRUE)  
  rownames(simple_scales) <- c("sd 1", "sd 2", "sd 3", "sd 4") 
  expect_equal(simplified_x[1:4, ], simple_scales)
  expect_equal(as.numeric(simplified_x[5,] ),
               c(55, 0, 71, 54, 86, 61, 85))
  expect_equal(as.numeric(simplified_x[7,] ),
               c(sqrt(18), sqrt(180), sqrt(6), sqrt(6), sqrt(64.8), sqrt(64.8), 6))
})

test_that("simplify scale gives error w/o signvector data", {
  expect_error(simplify_scale(c(0, 2, 3, 7), display_digits=NULL))
})

test_that("simplify scale gives error w/o scale data", {
  rep_svs <- readRDS(test_path("testdata", "test_signvectors.rds"))
  expect_error(simplify_scale(c(0, 2, 3, 7), signvector_list=rep_svs, display_digits=NULL))
})

test_that("simplify scale gives error w/o adjacency data", {
  rep_svs <- readRDS(test_path("testdata", "test_signvectors.rds"))
  rep_scl <- readRDS(test_path("testdata", "test_scales.rds"))
  expect_error(simplify_scale(c(0, 2, 3, 7), , display_digits=NULL,
                              scales=rep_scl, signvector_list=rep_svs))
})
