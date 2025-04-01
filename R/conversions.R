#' Convert between octave measurements
#'
#' By default the period of a scale (normally the octave)
#' has a size of 12 units (semitones). But it can be useful
#' to convert to a different measurement unit, e.g. to compare
#' a scale defined in 19-tone equal temperament (19edo) to the
#' size of its intervals when measured in normal 12edo semitones,
#' or vice versa.
#'
#' @param x The set to convert as a numeric vector.
#' @param edo1 The size of the period measured in the same units 
#'   as the input `x`. Numeric.
#' @param edo2 The period size to convert to. Numeric.
#' @returns A numeric vector the same length as `x`
#'   representing the input set converted to the desired cardinality (`edo2`).
#' @examples
#' maqam_rast <- c(0, 2, 3.5, 5, 7, 9, 10.5)
#' convert(maqam_rast, 12, 24)
#' 
#' perfect_fifth <- 12 * log(3/2)/log(2)
#' lydian_scale <- sort((perfect_fifth * (0:6)) %% 12)
#' convert(lydian_scale, 12, 53)
#' 
#' @export
convert <- function(x, edo1, edo2) x*(edo2/edo1)

#' @export
coord_to_edo <- function(set, edo=12) {
  card <- length(set)
  new_origin <- edoo(card, edo=edo)
  return(set-new_origin)
}

#' @export
coord_from_edo <- function(set, edo=12) {
  card <- length(set)
  new_origin <- edoo(card, edo=edo)
  return(set+new_origin)
}