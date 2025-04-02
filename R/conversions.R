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

#' Coordinate systems for scale representation
#'
#' Usually, it is most intuitive to music theorists to represent
#' a scale as a vector of the pitch-classes it contains. However, for certain
#' computations in the setting of Modal Color Theory, it is more convenient
#' to use a coordinate system with the "white" perfectly even scale as the
#' origin (because this is the point where all of the hyperplanes
#' in the arrangement defining scalar "colors" intersect). Therefore, these
#' two functions convert between the two coordinate systems: `coord_to_edo`
#' takes in a scale represented by its pitch classes and returns its 
#' displacement vector from "white" and `coord_from_edo` does the reverse.
#'
#' It should be noted that the representative "white" scale used is not
#' necessarily the *closeset* one to the scale in question. Instead, it is
#' the unique transposition of white that has 0 as its first coordinate.
#' This is natural in the context of Modal Color Theory, which essentially
#' always assumes transpositional equivalence with \eqn{x_0 = 0}. The closest
#' transposition of "white" to `set` will be the one that has the same sum
#' class as `set`, guaranteeing that the voice leading between them is
#' "pure contrary" (Tymoczko 2011, 81ff; explored further in Straus 2018
#' <https://doi.org/10.1215/00222909-7127694>).
#' 
#' @inheritParams tnprime
#' @returns Numeric vector of same length as `set`. Same scale,
#'   new coordinate system.
#' @examples
#' dominant_seventh_chord <- c(0, 2, 6, 9)
#' coord_to_edo(dominant_seventh_chord)
#' 
#' ait1 <- c(0, 1, 4, 6)
#' ait2 <- c(0, 1, 3, 7)
#' coord_to_edo(ait1)
#' coord_to_edo(ait2) # !
#'
#' weitzmann_pentachord <- coord_from_edo(c(0, -1, 0, 0, 0)) # See note 53 of "Modal Color Theory"
#' convert(weitzmann_pentachord, 12, 60)
#' coord_to_edo(weitzmann_pentachord)
#' @export
coord_to_edo <- function(set, edo=12) {
  card <- length(set)
  new_origin <- edoo(card, edo=edo)
  return(set-new_origin)
}

#' @rdname coord_to_edo
#' @export
coord_from_edo <- function(set, edo=12) {
  card <- length(set)
  new_origin <- edoo(card, edo=edo)
  return(set+new_origin)
}