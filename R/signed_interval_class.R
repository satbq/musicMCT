#' Ordered pitch-class interval represented as interval class with sign
#'
#' Represents an ordered interval between two pitch-classes as a value between
#' `-edo/2` and `edo/2`, i.e. with an absolute value that matches its 
#' interval class as well as a sign (plus or minus) that disambiguates
#' between the two OPCIs included in the interval-class. That is, C->D is 
#' `2` whereas C->Bb is `-2`. Exactly half the octave is represented as a 
#' positive value.
#'
#' @param x Single numeric value, representing an ordered pitch-class interval
#' @inheritParams tnprime
#' @returns Single numeric value
#' @examples
#' signed_interval_class(8)
#' signed_interval_class(6)
#' signed_interval_class(-6)
#' signed_interval_class(3*pi)
#' @export
signed_interval_class <- function(x, edo=12) {
  y <- x %% edo
  if (y > (edo/2)) { return(y-edo) }
  return(y)
}