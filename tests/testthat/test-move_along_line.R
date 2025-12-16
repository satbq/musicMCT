test_that("move_to_hyperplane gives correct sets", {
  expect_equal(move_to_hyperplane(3, set=c(0, 4, 7), ineqmat="roth")$set,
               c(0, 4, 6))
  expect_equal(move_to_hyperplane(5, set=c(0, 4, 7, 10), ineqmat="roth")$set,
               c(0, 6, 9, 12))

  ionian19 <- c(0, 3, 6, 8, 11, 14, 17)
  proper_ionian <- convert(ionian19, 19, 12)
  expect_equal(move_to_hyperplane(175, proper_ionian, ineqmat="roth")$set,
               c(0, 2, 4, 5, 7, 9, 11))
  expect_equal(move_to_hyperplane(175, ionian19, ineqmat="roth", edo=19)$set,
               convert(c(0, 2, 4, 5, 7, 9, 11), 12, 19))

  expect_equal(move_to_hyperplane(1, point=c(0, 4, 7), direction=c(0, -1, 0))$set,
               c(0, 3.5, 7))
  expect_equal(move_to_hyperplane(1, point=c(0, 4, 7), direction=c(0, -1, 0))$sign,
               1)
  expect_equal(move_to_hyperplane(1, point=c(0, 3, 7), direction=c(0, -1, 0))$set,
               c(0, 3.5, 7))
  expect_equal(move_to_hyperplane(1, point=c(0, 3, 7), direction=c(0, -1, 0))$sign,
               -1)
  expect_equal(move_to_hyperplane(1, point=c(0, 3, 7), direction=c(0, 1, 0))$sign,
               1)

  expect_equal(move_to_hyperplane(1, set=c(0, 4, 7), direction=c(0, -1, 0))$set,
               c(0, 4, 8))

  cmaj <- c(0, 2, 4, 5, 7, 9, 11)
  cmmin <- c(0, 2, 3, 5, 7, 9, 11)
  expect_equal(move_to_hyperplane(3, point=cmaj, direction=cmmin-cmaj)$set,
               c(0, 2, 3.5, 5, 7, 9, 11))

  arbitrary_ineq <- matrix(c(0, 0, 1, 0, 0, 0, 0, -j(3)/12), nrow=1)
  expect_equal(move_to_hyperplane(1, set=cmaj, ineqmat=arbitrary_ineq)$set[3],
               j(3))
})

test_that("move_to_hyperplane warns and stops correctly", {
  expect_error(move_to_hyperplane(3, point=c(0, 4, 7), ineqmat="roth"))

  expect_warning(move_to_hyperplane(1, set=c(0, 4, 7, 10), ineqmat="roth"))
  expect_warning(move_to_hyperplane(3, set=c(0, 2, 7)))
})
