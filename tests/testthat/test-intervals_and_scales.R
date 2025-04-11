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

test_that("makeMEscale works", {
  expect_equal(makeMEscale(7,12), c(0,1,3,5,6,8,10))
  expect_equal(makeMEscale(7,14), c(0,2,4,6,8,10,12))
  expect_equal(makeMEscale(6,15), c(0,2,5,7,10,12))
})

test_that("j intervals accurate", {
  expect_equal(j(dia), 12*log2(c(1,9/8,5/4,4/3,3/2,5/3,15/8)))
  expect_equal(j(sept), 12*log2(8/7))
  expect_equal(j(synt), ((4*12*log2(1.5))%%12) - 12*log2(5/4))
})

test_that("j accepts varied inputs", {
  expect_equal(j(u), 0)
  expect_equal(j("u"), 0)
  expect_equal(j(1,"u"), c(0, 0))
})

test_that("j rejects nonstandard inputs", {
  expect_error(j(U))
})
