test_that("makeineqmat works", {
  goal_matrix <- matrix(c(-1, -2, -1,
                          2, 1, -1,
                          -1, 1, 2,
                          0, -1, -1), nrow=3)
  expect_equal(makeineqmat(3), goal_matrix)

  expect_identical(makeineqmat(1), integer(0))

  dyad_ineqmat <- matrix(c(-2, 2, -1), nrow=1)
  expect_equal(makeineqmat(2), dyad_ineqmat)
})

test_that("makeineqmat gives right dims", {
  random_size <- sample(3:20, 1)
  random_ineqmat <- makeineqmat(random_size)
  num_rows <- function(n) {
    if (n%%2 == 0) { return((n^3)/8)
    } else {
      return((n^3 - n)/8)
    }
  }
  expect_equal(dim(random_ineqmat)[2], random_size+1)
  expect_equal(dim(random_ineqmat)[1], num_rows(random_size))
})
