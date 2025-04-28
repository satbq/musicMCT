#' Are two integers coprime?
#'
#' Tests whether gcd(num, edo)=1
#'
#' @param num The integer to test
#' @param edo The other integer to test (notionally representing a scale size)
#'
#' @returns Boolean: are the inputs coprime?
#'
#' @noRd
coprime_to_edo <- function(num, edo=12) {
  residues <- 1:edo
  prods <- num * residues
  zeroes <- which(prods %% edo == 0)
  length(zeroes) == 1
}

#' Distance between two points
#'
#' In music theory, different contexts sometimes suggest different ways
#' of measuring distance as most appropriate. Several functions call 
#' `dist_func()` to let a common set of `method`s be available for user
#' choice.
#'
#' @param x A vector which represents the difference between two scales
#' @inheritParams minimize_vl
#'
#' @returns Single numeric value representing a distance
#' 
#' @noRd
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

#' Ensure that an object is a matrix
#'
#' Some functions usually return a matrix but give a vector when there's
#' only one result. This makes sure that even an errant vector is formatted
#' as a matrix with a single column.
#'
#' @param x Any object that you expect to be a matrix
#'
#' @returns Matrix containing the values of x; just x if it was already
#'   a matrix.
#'
#' @noRd
insist_matrix <- function(x) {
  if (!(inherits(x, "matrix"))) x <- as.matrix(x)
  x
}

#' Find all the multiplicative units mod edo
#'
#' For ineqsym (and potentially some other functions, like the classic
#' set theory M operation) you want to find all the multiplicative units
#' in Z/nZ. This does so.
#'
#' @param edo Integer to treat as the modulus
#'
#' @returns Vectors of integers which are invertible mod edo
#'
#' @noRd
units_mod <- function(edo) which(sapply(1:edo, coprime_to_edo, edo=edo)==TRUE)



