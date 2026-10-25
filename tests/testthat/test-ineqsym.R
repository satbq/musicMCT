test_that("ineqsym works", {
  expect_equal(ineqsym(c(0, 2, 4, 6)), c(0, 2, 4, 6))
  expect_error(ineqsym(c(0, 3, 7), a=0))
  expect_error(ineqsym(c(0, 2, 4, 6), a=2))
  expect_equal(ineqsym(c(0, 2, 4, 6), a=3), c(0, 0, 4, 8))
  expect_equal(ineqsym(c(0, 3, 6), 2), c(0, 2, 7))
  expect_equal(ineqsym(c(0, 3, 6), 1, 1), c(-2, 4, 7))

  penta_weitz <- seq(0, 12, by=3)
  penta_weitz[2] <- 2
  expect_equal(ineqsym(penta_weitz, a=3, b=3, edo=15), penta_weitz)

  expect_equal(ineqsym(c(0, 3, 6), a=2, involution=TRUE),
               c(0, 6, 9))

  blackkey <- c(0, 2, 4, 7, 9)
  expect_equal(ineqsym(blackkey, a=2, b=0),
               c(0, 2.2, 4.4, 6.6, 8.8))
  expect_equal(ineqsym(blackkey, a=2, b=1),
               c(-0.8, 2.4, 4.6, 6.8, 9))

  dorian <- c(0, 2, 3, 5, 7, 9, 10)
  expect_equal(ineqsym(dorian, a=6, b=0, involution=TRUE),
               dorian)
})

test_that("ineqsym generates good permutation matrices", {
  p_theta <- matrix(c(1, 0, 0, 0, 0,
                      0, 0, 0, 1, 0,
                      0, 1, 0, 0, 0,
                      0, 0, 0, 0, 1,
                      0, 0, 1, 0, 0), 
                    nrow=5, byrow=TRUE)
  p_psi <- matrix(c(0, 0, 1, 0, 0,
                    1, 0, 0, 0, 0,
                    0, 0, 0, 1, 0,
                    0, 1, 0, 0, 0,
                    0, 0, 0, 0, 1), 
                  nrow=5, byrow=TRUE)

  expect_equal(ineqsym(a=2, b=0, card=5), p_theta)
  expect_equal(ineqsym(a=2, b=1, card=5), p_psi)
})

test_that("ineqsym_index and _degree work", {
  jm <- j(1,3,5)
  cmaj <- c(0, 2, 4, 5, 7, 9, 11)
  golomb <- c(0, 1, 4, 9, 11)

  expect_equal(ineqsym_degree(jm), 1)
  expect_equal(ineqsym_degree(jm, type="color"), 2)
  
  cmaj_symmetries <- ineqsym_index(cmaj)
  expect_equal(cmaj_symmetries[2, 1], 6)
  expect_equal(cmaj_symmetries[2, 2], 2)
  expect_equal(cmaj_symmetries[2, 3], TRUE)
  expect_equal(ineqsym_index(sc(7,35))$'b', c(0, 4))

  expect_equal(ineqsym_degree(golomb, edo=15), 4)
})
