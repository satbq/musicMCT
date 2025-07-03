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
#' @param distro Numeric vector representing a pitch-class distribution.
#' @param multiset Boolean. Should distribution_to_set() return a multiset if 
#'  element weights are greater than 1? Defaults to `TRUE`.
#' @param reconvert Boolean. Should the scale be converted to the input edo? 
#'  Defaults to `TRUE`.
#' @param ... Arguments to be passed from s2d() or d2s() to unabbreviated
#'  functions.
#'
#' @returns set_to_distribution() returns a numeric vector with length
#'  `edo`, whose `i`th entry represents the weight assigned to pitch-class
#'  `i` in the distribution. distribution_to_set() returns a (multi)set
#'  represented by listing its elements in a vector. (Non-integer weights are rounded
#'  *up* to the next highest integer if `multiset` is `TRUE`.)
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
distribution_to_set <- function(distro, 
                                multiset=TRUE, 
                                reconvert=TRUE, 
                                edo=12, 
                                rounder=10) {
  d_edo <- length(distro)
  rounded_distro <- round(distro, digits=rounder)
  if (multiset) { get_counts <- ceiling } else { get_counts <- sign }

  counts <- get_counts(rounded_distro)
  values <- 0:(length(distro)-1)

  set <- unlist(mapply(rep, x=values, times=counts))
 
  if (reconvert) {
    res <- convert(set, d_edo, edo)
  } else {
    res <- list(set=set, edo=d_edo)
  }

  res
}

#' @rdname set_to_distribution
#' @export
s2d <- function(...) set_to_distribution(...)

#' @rdname set_to_distribution
#' @export
d2s <- function(...) distribution_to_set(...)


dft <- function(set, distro=NULL, edo=12, rounder=10) {
  num_components <- floor(edo/2) + 1

  if (is.null(distro)) distro <- set_to_distribution(set, edo, rounder)
  
  complex_vals <- stats::fft(distro)
  complex_vals <- complex_vals[1:num_components]
  magnitude <- Mod(complex_vals)
  phase <- Arg(complex_vals)
  phase <- (edo/(2*pi)) * phase

  res <- rbind(magnitude, phase)

  fs <- rep("f", num_components)
  nums <- 0:(num_components-1)
  f_num <- cbind(fs, nums) |> apply(MARGIN=1, FUN=paste, collapse="")
  colnames(res) <- f_num

  res
}