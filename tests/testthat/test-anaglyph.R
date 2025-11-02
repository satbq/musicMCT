test_that("anaglyph ineqmat works", {
  expect_equal(make_anaglyph_ineqmat(1), integer(0))
  expect_snapshot(make_anaglyph_ineqmat(2))
  expect_snapshot(make_anaglyph_ineqmat(4))
})

test_that("anazero_fingerprint works", {
  expect_equal(anazero_fingerprint(c(0, 4, 7, 0, 2, 7)),
               c(0, 1, 2))
  expect_equal(anazero_fingerprint(c(0, 6, 11, 0, 5, 7), edo=19),
               c(0, 0, 1))
})
