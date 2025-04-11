test_that("makeineqmat works", {
  goal_matrix <- matrix(c(-1, -2, -1,
                          2, 1, -1,
                          -1, 1, 2,
                          0, -1, -1), nrow=3)
  expect_equal(makeineqmat(3), goal_matrix)
})

test_that("makeineqmat gives right dims", {
  random_size <- sample(2:20, 1)
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
