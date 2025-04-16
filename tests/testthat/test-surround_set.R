test_that("surround_set samples sphere of correct distance", {
  eucl <- function(set, ref) sqrt(sum((set-ref)^2))
  base <- c(0, 3, 7)
  expect_equal(fpunique(apply(surround_set(base, 
                                           magnitude=0.5), 
                              2, eucl, ref=base)), 
               1)
  expect_equal(fpunique(apply(surround_set(base, 
                                           magnitude=0.5,
                                           distance=2/3), 
                              2, eucl, ref=base)), 
               2/3)
})

test_that("surround_set returns matrix of appropriate size", {
  expect_equal(dim(surround_set(c(0,2,6,9), magnitude=1))[1], 4)
  expect_equal(dim(surround_set(c(0,2,6,9), magnitude=1))[2], 40)
})