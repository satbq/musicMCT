test_that("sc works", {
  expect_equal(sc(1,1), 0)
  expect_equal(sc(2,4), c(0, 4))
  expect_equal(sc(3, 5), c(0, 1, 6))
  expect_equal(sc(7, 34), c(0, 1, 3, 4, 6, 8, 10))
  expect_equal(sc(11, 1), 0:10)

  expect_error(sc(5, -1))
  expect_error(sc(5, 50))
  expect_error(sc(3, 0))

  expect_error(sc(0,1))
  expect_error(sc(13,5))
})

test_that("fortenum works", {
  expect_equal(fortenum(3), "1-1")
  expect_equal(fortenum(c(0, 7)), "2-5")
  expect_equal(fortenum(c(0,8,16)), "3-12")
  expect_equal(fortenum(c(0, 4, 7, 10, 12)), "4-27")
  expect_equal(fortenum(setdiff(0:11,6)), "11-1")

  expect_warning(fortenum(c(0,2.5, 6)))
})

test_that("tnprime works", {
  expect_equal(tnprime(NULL), integer(0))
  expect_equal(tnprime(5), 0)
  expect_equal(tnprime(c(0, 3*pi)), c(0, 12-(3*pi)))
  expect_equal(tnprime(c(0, 3, 0)), c(0, 0, 3))
  expect_equal(tnprime(c(0, 1, 7)), c(0, 5, 6))
  expect_equal(tnprime(c(0, 6, 9, 15)), c(0, 3, 6, 9))

  expect_equal(tnprime(c(0, 4, 8), edo=9), c(0, 1, 5))

  just_dia <- 12 * log2(c(1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8))
  just_tnprime <- 12 * log2(c(1, 16/15, 6/5, 4/3, 64/45, 8/5, 16/9))
  expect_equal(tnprime(just_dia), just_tnprime)
})

test_that("tn works", {
  tetra <- c(0, 2, 3, 6)
  expect_equal(tn(tetra, 1), c(1, 3, 4, 7))
  expect_equal(tn(tetra, 8), c(2, 8, 10, 11))
  expect_equal(tn(tetra, -6), c(0, 6, 8, 9))
  expect_equal(tn(tetra, 8, sorted=FALSE), c(8, 10, 11, 2))
  expect_equal(tn(tetra, 8, edo=31), c(8, 10, 11, 14))
})

test_that("tni works", {
  tetra <- c(0, 2, 3, 6)
  expect_equal(tni(tetra, 6), c(0, 3, 4, 6))
  expect_equal(tni(tetra, 0), c(0, 6, 9, 10))
  expect_equal(tni(tetra, -11), c(1, 7, 10, 11))
  expect_equal(tni(tetra, 8, sorted=FALSE), c(8, 6, 5, 2))
  expect_equal(tni(tetra, 3, edo=19), c(0, 1, 3, 16))
})

test_that("startzero works", {
  expect_equal(startzero(c(1, 6)), c(0, 5))
  expect_equal(startzero(c(6, 1)), c(0, 7))
  expect_equal(startzero(c(2, 9, 6), sorted=FALSE), c(0, 7, 4))
  expect_equal(startzero(c(1, 3, 9), edo=7), c(0, 1, 2))
})

test_that("charm works", {
  expect_equal(charm(c(2, 6, 9)), c(0, 3, 7))
  expect_equal(charm(c(1, 3, 6, 9)), c(0, 3, 6, 8))
  expect_equal(charm(c(0, 6, 11), edo=19), c(0, 5, 11))
})

test_that("primeform works", {
  expect_equal(primeform(c(0,1,7)), c(0,1,6))
  expect_equal(primeform(c(0,3,4,8)), c(0,1,4,8))
  expect_equal(primeform(c(4,6,9,10,1)), c(0,1,4,6,9))
  expect_equal(primeform(c(10,4,6,9,1)), c(0,1,4,6,9))  
  expect_equal(primeform(c(0,1,2,4,5,7,9,10)), c(0,1,3,4,5,7,8,10))
  expect_equal(primeform(c(3, 14, 0, 2, 6, 12, 9, 11, 17), edo=19), 
                         c(0, 1, 3, 5, 8, 10, 11, 13, 16))

  just_dia <- 12 * log2(c(1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8))
  just_prime <- 12 * log2(c(1, 16/15, 32/27, 4/3, 64/45, 8/5, 16/9))
  expect_equal(primeform(just_dia), just_prime)
})

test_that("isym works", {
  expect_true(isym(3))
  expect_true(isym(c(0,4)))
  expect_true(isym(c(0,3,6)))
  expect_false(isym(c(0,3,7)))
  expect_true(isym(c(0,3.5,7)))
  
  just_dia <- 12 * log2(c(1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8))
  expect_false(isym(just_dia))

  qcm_mmin <- sort((c(0,2,3,4,5,6,8) * meantone_fifth())%%12)
  expect_true(isym(qcm_mmin))
  expect_false(isym(qcm_mmin, rounder=15))

  expect_true(isym(c(0,1,2,4), edo=6))
})

test_that("tsym works", {
  expect_false(tsym(NULL))
  expect_false(tsym(1))

  expect_true(tsym(c(0, 1, 6, 7)))
  expect_true(tsym(c(0, 3, 6, 9)))
  expect_false(tsym(c(0, 1, 4, 8)))

  s <- 12 * log2(213/199)
  expect_true(tsym(c(0, s, 4, 4+s, 8, 8+s)))
 
  expect_true(tsym(c(0, 4, 8, 12), edo=16))
  expect_false(tsym(c(0, 4, 8, 12)))
  expect_true(tsym(c(0, 1, 3, 6, 7, 9)))
})

test_that("ivec works", {
  expect_equal(ivec(c(0, 1, 2, 4, 6, 8, 10)), c(2, 6, 2, 6, 2, 3))
  expect_equal(ivec(c(0, 2, 4, 7, 9), edo=13), c(0, 3, 1, 2, 2, 2))
})

test_that("tc works", {
  expect_equal(tc(c(0, 4, 7), c(0, 1)),
               c(0, 1, 4, 5, 7, 8))
  expect_equal(tc(c(0, 6, 11), c(0, 3, 9), edo=19),
               c(0, 1, 3, 6, 9, 11, 14, 15))
  expect_equal(tc(c(0, 2, 7)), 
               c(0, 2, 4, 7, 9))
})

