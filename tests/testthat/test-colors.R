test_that("palette works", {
  triad_palette <- matrix(c(0, 0, 0, 0, 0, 0,
                            3, 4, 5, 5, 4, 3,
                            7, 9, 8, 9, 7, 8), 
                          byrow=TRUE, nrow=3)

  triad_19_palette <- matrix(c(0, 0, 0,
                               6, 5, 8,
                              11, 13, 14),
                             byrow=TRUE, nrow=3) 

  expect_equal(scale_palette(c(0, 3, 7)), triad_palette)
  expect_equal(scale_palette(c(0, 3, 7), include_involution=FALSE),
               triad_palette[,1:3])
  expect_equal(scale_palette(c(0, 6, 11), edo=19, include_involution=FALSE),
               triad_19_palette)

  just_dia <- 12 * log2(c(1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8))
  expect_equal(dim(scale_palette(just_dia)), c(7, 84))
  expect_equal(dim(scale_palette(c(0,2,4,5,7,9,11))), c(7, 42))

  tetra_palette <- matrix(c(0, 0, 0, 0,
                            2, 2, 4, 4,
                            4, 6, 8, 6,
                            8, 10, 10, 8),
                          byrow=TRUE, nrow=4)
  expect_equal(scale_palette(c(0, 2, 4, 8)), tetra_palette)

  expect_equal(scale_palette(c(0, 4, 8)), matrix(c(0, 4, 8), ncol=1))
})

test_that("primary_hue works", {
  expect_equal(primary_hue(c(0, 5, 9)), c(0, 3, 7))
  expect_equal(primary_hue(c(0, 5, 9), type="modes"), c(0, 3, 8))

  sc723 <- c(0, 2, 3, 4, 5, 7, 9)
  half_primary <- c(0, 1, 9, 31, 46, 47, 62)/7
  expect_equal(primary_hue(sc723, type="half"), half_primary)
  expect_equal(primary_hue(sc723, type="modes"), c(0, 1, 3, 5, 8, 10, 11))

  expect_equal(primary_hue(c(0, 6)), c(0, 6))
  expect_equal(primary_hue(c(0, 4, 8)), c(0, 4, 8))
})

test_that("other primary color functions work", {
  expect_equal(primary_signvector(c(0, 6, 9)), c(-1, -1, 0))
  expect_equal(primary_color(c(0, 6, 9), reconvert=TRUE), c(0, 2.4, 7.2))

  expect_equal(primary_signvector(c(0, 6, 9), type="modes"), c(-1, 0, 1))
  expect_equal(primary_color(c(0, 6, 9), reconvert=TRUE, type="modes"), 
               c(0, 3, 9))

  expect_true(is.null(primary_colornum(c(0, 4, 7, 10))))
})

