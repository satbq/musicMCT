test_that("colornum gives 0 for edoo", {
  expect_equal(colornum(0), 0)
  expect_equal(colornum(c(0,3,6,9)), 0)
  expect_equal(colornum(c(0,2,4,6,8), edo=10), 0)
})

test_that("colornum works with explicit signvector list", {
  expect_equal(colornum(c(0,4),
               signvector_list=list(character(0),
                                    c("-1", "1"))),
               1)
  tiny_sv_list <- list(character(0), character(0),
                       c("-1, -1, -1", "-1, -1, 0", 
                         "-1, -1, 1", "-1, 0, -1",
                         "-1, 1, 1", "0, -1, -1",
                         "0, 1, 1", "1, -1, -1",
                         "1, 0, -1", "1, 1, -1", 
                         "1, 1, 0", "1, 1, 1"))
  expect_equal(colornum(c(0,7,11), signvector_list=tiny_sv_list),
               12)

  rs <- readRDS(test_path("testdata", "test_signvectors.rds"))
  expect_equal(colornum(c(0, 2, 6, 8), signvector_list=rs), 35)
  expect_equal(colornum(c(0, 1, 3, 7), signvector_list=rs, edo=10), 5)
})

test_that("colornum is OK without explicit signvector list", {
  if (exists("representative_signvectors")) {
    expect_equal(colornum(c(0,2,7)), 2)
  } else {
  expect_null(colornum(c(0,2,7)))
  }
})

test_that("colornum treats anaglyph card correctly", {
  dyad_svs <- c("-1, -1, -1, -1", "-1, -1, 0, -1",  "-1, -1, 1, -1",
                "-1, 0, -1, -1", "-1, 1, -1, -1", "-1, 1, -1, 0", 
                "-1, 1, -1, 1", "0, -1, 1, -1", "0, 1, -1, 1", "1, -1, 1, -1",
                "1, -1, 1, 0", "1, -1, 1, 1", "1, 0, 1, 1", "1, 1, -1, 1",
                "1, 1, 0, 1", "1, 1, 1, 1")
  temp_list <- list(NULL, dyad_svs)
  expect_equal(colornum(c(0, 5, 0, 7), ineqmat="anaglyph", signvector_list=temp_list),
               6)
})
