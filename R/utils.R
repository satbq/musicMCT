coprime_to_edo <- function(num, edo=12) {
  residues <- 1:edo
  prods <- num * residues
  zeroes <- which(prods %% edo == 0)
  length(zeroes) == 1
}

dist_func <- function(x, 
                      method=c("taxicab", "euclidean", "chebyshev", "hamming"),
                      rounder=10) {
  method <- match.arg(method)
  tiny <- 10^(-1 * rounder)
  switch(method,
         taxicab = sum(abs(x)),
         euclidean = sqrt(sum(x^2)),
         chebyshev = max(abs(x)),
         hamming = sum(abs(x) > tiny))
}

insist_matrix <- function(x) {
  if (!(inherits(x, "matrix"))) x <- as.matrix(x)
  x
}

units_mod <- function(edo) which(sapply(1:edo, coprime_to_edo, edo=edo)==TRUE)



