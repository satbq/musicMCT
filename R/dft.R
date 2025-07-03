#' Convert between pitch-class sets and distributions
#'
#' For applications of the Discrete Fourier Transform to pitch-class 
#' set theory, it's typically convenient to represent musical sets 
#' in terms of *distributions* rather than lists of their elements.
#' (See Chapter 1 of Amiot 2016, <doi:10.1007/978-3-319-45581-5>.)
#' These functions convert back and forth between those representations.
#' s2d() and d2s() are shorthands for set_to_distribution() and
#' distribution_to_set(), respectively.
#'
#' @inheritParams tnprime
#' @param set Numeric vector of pitch-classes in the set. May be a 
#'  multiset, in which case the result is different from the corresponding
#'  set with repetitions removed. Entries must be integers.
#' @param ... Arguments to be passed from s2d() or d2s() to unabbreviated
#'  functions.
#'
#' @returns set_to_distribution() returns a numeric vector with length
#'  `edo`, whose `i`th entry represents the weight assigned to pitch-class
#'  `i` in the distribution. distribution_to_set() returns a (multi)set
#'  represented by listing its elements. (Non-integer weights are rounded
#'  *up* to the next highest integer.)
#'
#' @examples
#' set_to_distribution(c(0, 4, 7))
#' s2d(c(0, 4, 7)) # Same result but quicker to type
#' s2d(c(0, 4, 4, 7)) # The doubled third is reflected by the value 2 in the result
#'
#' @export
set_to_distribution <- function(set, edo=12, rounder=10) {
  set <- set %% edo
  rounded_set <- round(set, 0)

  rounding_diff <- set - rounded_set
  if (max(abs(rounding_diff)) > 10^(-1 * rounder)) {
    stop("Non-integer values detected in ",
            deparse(substitute(set)),
            " but only ",
            edo,
            "-edo values were expected.")
  }

  distro <- rep(0, edo)
  set_counts <- table(rounded_set+1)
  set_values <- strtoi(names(set_counts))
  distro[set_values] <- set_counts
  distro
}

#' @rdname set_to_distribution
#' @export
s2d <- function(...) set_to_distribution(...)