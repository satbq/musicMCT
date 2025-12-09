test_that("point_on_flat works with default params", {
  expect_equal(signvector(point_on_flat(1, 4))[1], 0)
  expect_equal(signvector(point_on_flat(2, 4))[2], 0)
  expect_equal(signvector(point_on_flat(3, 4))[3], 0)
  expect_equal(signvector(point_on_flat(4, 4))[4], 0)
  expect_equal(signvector(point_on_flat(5, 4))[5], 0)
  expect_equal(signvector(point_on_flat(6, 4))[6], 0)

  expect_equal(whichsvzeroes(point_on_flat(c(1, 6), 4)),
               c(1, 6, 8))
  expect_equal(whichsvzeroes(point_on_flat(c(1, 7), 4)),
               c(1, 7))
  expect_equal(whichsvzeroes(point_on_flat(c(2, 7), 4)),
               c(2, 5, 7, 8))

  expect_equal(startzero(point_on_flat(c(1, 2), 3), optic=""),
               edoo(3))
  expect_equal(startzero(point_on_flat(c(1, 2, 3), 3), optic=""),
               edoo(3))
})

test_that("point_on_flat works for other ineqmats", {
  expect_equal(point_on_flat(c(2, 4), card=4, ineqmat="black")[c(2, 4)],
               c(3, 9))
  expect_equal(point_on_flat(c(2, 4), card=4, ineqmat="black", edo=16)[c(2, 4)],
               c(4, 12))

  pastel_trichord <- point_on_flat(4, card=3, ineqmat="pastel")
  expect_equal(pastel_trichord[2]-pastel_trichord[1], 4)

  roth_trichord <- point_on_flat(c(2, 3), card=3, ineqmat="roth")
  expect_equal(whichsvzeroes(roth_trichord, ineqmat="roth"), 
               c(2, 3, 6))

  expect_warning(point_on_flat(c(1, 2, 3), card=3, ineqmat="roth"))
  expect_equal(suppressWarnings(point_on_flat(c(1, 2, 3), card=3, ineqmat="roth")),
               rep(NA, 3))
})

test_that("independent_normals works", {
  expect_equal(independent_normals(integer(0), ineqmats[[3]]), integer(0))
  expect_equal(independent_normals(2, ineqmats[[3]]), 2)
  expect_equal(independent_normals(c(1, 4, 5, 9, 13, 14, 15), ineqmats[[5]]),
               c(1, 4, 9))
})


test_that("project_onto works with explicit ineqmat", {
  trimat <- matrix(c(-1, 2, -1, 0,
                     -2, 1, 1, -1,
                     -1, -1, 2, -1), nrow=3, byrow=TRUE)
  expect_equal(project_onto(c(0, 3, 7), 1, ineqmat=trimat), c(0, 3.5, 7))
  expect_equal(project_onto(c(0, 3, 7), 2, ineqmat=trimat), c(0, 4, 8))
  expect_equal(project_onto(c(0, 3, 7), 3, ineqmat=trimat), c(0, 3, 7.5))
  expect_equal(project_onto(c(0, 3, 7), c(1, 3), ineqmat=trimat), c(0, 4, 8)) 
  expect_equal(project_onto(c(0, 1, 6), 1, ineqmat=trimat), c(0, 3, 6))
  expect_equal(project_onto(c(0, 1, 7), 1, ineqmat=trimat), c(0, 3.5, 7))
})

test_that("project_onto start_zero param works", {
  trimat <- matrix(c(-1, 2, -1, 0,
                     -2, 1, 1, -1,
                     -1, -1, 2, -1), nrow=3, byrow=TRUE)
  expect_equal(project_onto(c(0, 3, 7), 1, ineqmat=trimat, start_zero=FALSE), 
               c(-1/6, 3+(1/3), 7-(1/6)))
  expect_equal(project_onto(c(0, 1, 7), 1, ineqmat=trimat, start_zero=FALSE), 
               c((1/6)-1, 3-(1/3), 6+(1/6)))
})

test_that("project_onto works with default ineqmat", {
  expect_equal(project_onto(c(0, 2, 4), integer(0)), c(0, 2, 4))
  expect_equal(project_onto(c(0, 1, 4, 6), 2), c(0, 1.5, 4.5, 6))
})

test_that("project_onto works with custom edo", {
  expect_equal(project_onto(c(0, 2, 6, 9), 2, edo=17), c(0, 2.5, 6.5, 9))
  expect_equal(project_onto(c(0, 2, 6, 9), c(2,3), edo=17), c(0, 3.1, 6.2, 9.3))
})

test_that("project_onto works with named ineqmats", {
  expect_equal(suppressWarnings(project_onto(c(0, 5, 6), 
                                             c(1, 2, 3), 
                                             ineqmat="roth")), 
               rep(NA, 3))

  expect_equal(project_onto(j(1, 3, 5), 4, ineqmat="pastel")[2], 4)
})

test_that("match_flat works", {
  expect_equal(match_flat(c(0, 4, 7, 10), c(0, 2, 6, 8)), c(0, 3.5, 6, 9.5))
  expect_equal(match_flat(c(0, 4, 7, 10), c(0, 2, 6, 8), start_zero=FALSE),
               c(0.5, 4, 6.5, 10))
  expect_equal(match_flat(c(0, 6, 11), c(0, 6, 12), edo=19), c(0, 5.5, 11))
  expect_equal(match_flat(c(0, 6, 11), c(0, 6, 12), edo=19, start_zero=FALSE), 
               c(1/6, 5+(2/3), 11+(1/6)))

  expect_error(match_flat(c(0, 2, 5), c(0, 2, 4, 6, 8)))
})

test_that("populate_flat works with null target", {
  maj7ish <- c(0,7,11)
  random_sets <- populate_flat(maj7ish, magnitude=.5)
  dists_to_set <- apply(random_sets, 2, vl_dist, set_2=maj7ish, method="euclidean")
  expect_true(min(dists_to_set) > 0)
  expect_true(max(dists_to_set) < 4.25)
  expect_equal(dim(random_sets)[2], 9)

  just_pent <- 12 * log2(c(1, 9/8, 5/4, 3/2, 5/3))
  random_pents <- populate_flat(just_pent, magnitude=0)
  random_pent_svs <- apply(random_pents, 2, whichsvzeroes)
  unique_svs <- as.numeric(unique(random_pent_svs, MARGIN=2))
  expect_equal(unique_svs, c(5, 9, 13))
})

test_that("populate_flat responds to target scale", {
  origin_pent <- convert(c(0, 5, 6, 13, 16), 22, 12)
  just_pent <- 12 * log2(c(1, 9/8, 5/4, 3/2, 5/3))
  random_pents <- populate_flat(origin_pent, just_pent, magnitude=0)
  random_pent_svs <- apply(random_pents, 2, whichsvzeroes)
  unique_svs <- as.numeric(unique(random_pent_svs, MARGIN=2))
  expect_equal(unique_svs, c(5, 9, 13))
})

test_that("populate_flat responds to target rows", {
  origin_pent <- convert(c(0, 5, 6, 13, 16), 22, 12)
  just_pent <- 12 * log2(c(1, 9/8, 5/4, 3/2, 5/3))
  random_pents <- populate_flat(origin_pent, just_pent, magnitude=0)
  random_pent_svs <- apply(random_pents, 2, whichsvzeroes)
  unique_svs <- as.numeric(unique(random_pent_svs, MARGIN=2))
  expect_equal(unique_svs, c(5, 9, 13))
})

test_that("populate_flat responds to target rows", {
  origin_pent <- convert(c(0, 5, 6, 13, 16), 22, 12)
  target_rows <- c(2, 5, 7)
  random_pents <- populate_flat(origin_pent, target_rows=c(2, 5, 7), magnitude=0)
  random_pent_svs <- apply(random_pents, 2, whichsvzeroes)
  unique_svs <- as.numeric(unique(random_pent_svs, MARGIN=2))
  expect_equal(unique_svs, c(2, 5, 7, 9, 11, 12, 13))
})

