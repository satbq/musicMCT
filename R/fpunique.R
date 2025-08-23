#' Unique real values up to some tolerance
#'
#' Working with scales in continuous pitch space, many pitches and intervals
#' are irrationals represented as **f**loating **p**oint numbers. This can cause
#' arithmetic and rounding errors, leading to it looking like there are 
#' more distinct pitches/intervals in the set than there really are. Use
#' `fpunique` rather than [base::unique()] whenever you handle scales in continuous
#' pitch space.
#'
#' Sometimes you may need to adjust the tolerance (`rounder`) to get correct
#' results, especially if you have done several operations in a row which
#' may have introduced rounding errors.
#'
#' @param x Numeric array whose unique elements are to be determined
#' @param MARGIN Numeric `0`, `1`, or `2` depending on whether you want
#'   unique individual numbers, unique rows, or unique columns, respectively.
#'   Defaults to `0`.
#' @param rounder Numeric (expected integer), defaults to `10`:
#'   number of decimal places to round to when testing for equality.
#' @returns Numeric array of unique elements (vector if `MARGIN` is 0;
#'   matrix otherwise)
#' @examples
#' just_dia <- j(dia)
#' intervals_in_just_dia <- sort(as.vector(sim(just_dia)))
#' failed_unique_intervals <- unique(intervals_in_just_dia)
#' fpunique_intervals <- fpunique(intervals_in_just_dia)
#' length(failed_unique_intervals)
#' length(fpunique_intervals)
#' @export
fpunique <- function(x, MARGIN=0, rounder=10) {
  if (MARGIN == 0) {
    return(x[!duplicated( round(x, rounder) ) ] )
  }

  if (MARGIN == 1) {
    return(x[!duplicated( round(x, rounder), MARGIN=1 ) , ] )
  }

  if (MARGIN == 2) {
    return(x[ , !duplicated( round(x, rounder), MARGIN=2 ) ] )
  }
}


#' Modulo division with rounding
#'
#' When working with sets in continuous pitch-class spaces (i.e., where
#' octave equivalence is needed), R's normal operator for modulo division
#' `%%` does not always give ideal results. Values that are very close to
#' (but below) the octave appear to be far from 0. This function uses 
#' rounding to give octave-equivalent results that music theorists expect.
#'
#' @inheritParams tnprime
#'
#' @returns Numeric vector the same length as `set`
#'
#' @examples
#' really_small <- 1e-13
#' c_major <- c(0, 4, 7, 12-really_small)
#' c_major %% 12
#' fpmod(c_major, 12)
#'
#' @export
fpmod <- function(set, edo=12, rounder=10) {
  tiny <- 10^(-1 * rounder)
  res <- set %% edo
  close_to_edo <- which(abs(res - edo) < tiny)
  res[close_to_edo] <- 0
  res
}
