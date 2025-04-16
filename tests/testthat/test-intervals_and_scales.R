test_that("meantone fifth works", {
  expect_equal(meantone_fifth(0), 12*log2(3/2))
  expect_true(abs(6.96578 - meantone_fifth()) < 1/10000)
  expect_true(abs(6.9581 - meantone_fifth(2/7)) < 1/10000)
})

test_that("carlos steps accurate", {
  expect_true(abs(.7797 - carlos_step("alpha")) < 1/10000)
  expect_true(abs(.6383 - carlos_step("beta")) < 1/10000)
  expect_true(abs(.351 - carlos_step("gamma")) < 1/10000)
  expect_true(abs(.1395 - carlos_step("delta")) < 1/10000)
})

test_that("edoo works", {
  expect_equal(edoo(4), c(0, 3, 6, 9))
  expect_equal(edoo(5, edo=10), c(0, 2, 4, 6, 8))
})

test_that("maxeven works", {
  expect_equal(maxeven(7,12), c(0,1,3,5,6,8,10))
  expect_equal(maxeven(7,14), c(0,2,4,6,8,10,12))
  expect_equal(maxeven(6,15), c(0,2,5,7,10,12))
  expect_equal(maxeven(6,15, floor=FALSE), c(0,2,4,7,9,12))
})

test_that("j intervals accurate", {
  expect_null(j())
  expect_equal(j(dia), 12*log2(c(1,9/8,5/4,4/3,3/2,5/3,15/8)))
  expect_equal(j(sept), 12*log2(8/7))
  expect_equal(j(synt), ((4*12*log2(1.5))%%12) - 12*log2(5/4))
  expect_equal(j(pyth), (144*log2(3/2))%%12)
  expect_equal(j(l, a, s, st, h, m2, mt, 2, t, w), 
               12*log2(c(256/243, 2187/2048, 16/15, 16/15, 16/15, 16/15,
                         10/9, 9/8, 9/8, 9/8)))
  expect_equal(j(m3, 3, M3, 4, utt, stt, jtt, 5, m6, 6, m7, 7, 8),
               12*log2(c(6/5, 5/4, 5/4, 4/3, 11/8, 7/5, 45/32, 3/2, 8/5, 5/3,
                         9/5, 15/8, 2)))
  expect_equal(j(wt, sdt, pm3, dt, pm7),
               12 * log2(c(9/8, 32/27, 32/27, 81/64, 16/9)))
})

test_that("j accepts varied inputs", {
  expect_equal(j(u), 0)
  expect_equal(j("u"), 0)
  expect_equal(j(1,"u"), c(0, 0))
})

test_that("j rejects nonstandard inputs", {
  expect_error(j(U))
})
