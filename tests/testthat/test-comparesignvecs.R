test_that("comparesignvecs works", {
 dia_sv <- c(0, 1, 1, 0, 0, -1, 0, 0, -1, 0, 0, 0, -1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, -1, 0, -1, -1, 1, 0, 0, 1, 0, 0, 1, 1, -1, 0, 0, 0, 0, 0, 1)
 jdia_sv <- c(1, 1, 1, 0, -1, -1, 1, 0, -1, 1, 0, -1, -1, 0, -1, 1, 1, 0, 1, 1, 1, 1, 0, -1, 0, -1, -1, 1, -1, 0, 1, -1, 0, 1, 1, -1, 0, 0, -1, -1, 0, 1)
 mmin_sv <- c(1, 0, -1, 0, -1, 0, 0, -1, 0, 0, 0, -1, 0, 0, 0, 1, 0, 1, 1, 1, 1, -1, -1, -1, -1, -1, 0, 0, 0, 1, 1, 0, 1, 1, 1, -1, 0, 0, 0, 1, 1, 1)
 expect_equal(comparesignvecs(dia_sv, jdia_sv), 1)
 expect_equal(comparesignvecs(jdia_sv, dia_sv), 1)
 expect_equal(comparesignvecs(dia_sv, mmin_sv), -1)
})
