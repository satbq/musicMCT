test_that("writeSCL then readSCL returns input scale", {
  test_scale <- c(0, 2, 4, 7)
  tempSCL <- withr::local_tempfile(
    pattern="scltest-",fileext=".scl")
  writeSCL(test_scale, tempSCL)
  expect_equal(readSCL(tempSCL), test_scale)
})

test_that("readSCL correctly reads cents-based .scl file", {
  test_scale <- readSCL(test_path("testdata", "test_temperament.scl"))
  expect_equal(test_scale[5], 12*log2(5/4))
  expect_equal(test_scale[8], 12*log2(3/2))
  expect_equal(length(test_scale), 12)
})

test_that("readSCL correctly reads ratio-based .scl file", {
  test_scale <- readSCL(test_path("testdata", "test_ratio_scale.scl"))
  expect_equal(length(test_scale), 7)
  expect_equal(test_scale[3], 12*log2(9/7))
  expect_equal(test_scale[4], 12*log2(10/7))
})

test_that("readSCL correctly reads file with mixed cents and ratios", {
  test_scale <- readSCL(test_path("testdata", "test_mixed_scale.scl"))
  expect_equal(test_scale[5], 12*log2(5/4))
  expect_equal(test_scale[8], 12*log2(3/2))
  expect_equal(length(test_scale), 12)
})

test_that("readSCL parameters scaleonly and edo work", {
  test_scale <- readSCL(test_path("testdata", "test_ratio_scale.scl"), scaleonly=FALSE)
  expect_equal(test_scale$length, 7)
  expect_equal(test_scale$period, 12)

  test_temperament <- readSCL(test_path("testdata", "test_temperament.scl"), edo=53)
  expect_equal(round(test_temperament[8], digits=2), 31)
})
