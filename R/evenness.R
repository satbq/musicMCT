#' How even is a scale?
#'
#' Calculates the Euclidean distance from a set to the nearest perfectly even
#' division of the octave, which will *not* be the one with a first entry
#' of 0, unlike almost every other usage in this package. That's because, for
#' most purposes, we do want to distinguish between different modes of a set,
#' but it seems counterintuitive to me to say that one mode of a scale is less
#' even than another. Since this value is a distance from the perfectly even
#' ("white") scale, lower values indicate more evenness.
#'
#' Note that the values this function returns depend on what measurement
#' unit you're using (i.e. are you in 12edo or 16edo?). Their absolute value
#' isn't terribly significant, but you should only make relative comparisons
#' between calculations done with the same value for `edo`.
#'
#' @inheritParams tnprime
#' @returns Single non-negative numeric value
#' 
#' @examples
#' evenness(c(0, 4, 8))
#' evenness(c(0, 4, 7)) < evenness(c(0,1,2))
#' 
#' dim_triad <- c(0,3,6)
#' sus_2 <- c(0,2,7)
#' coord_to_edo(dim_triad)
#' coord_to_edo(sus_2)
#' evenness(dim_triad) == evenness(sus_2)
#'
#' @export
evenness <- function(set, edo=12) {
  card <- length(set)
  edoozero <- edoo(card, edo) - (sum(edoo(card, edo))/card)
  setzero <- set - (sum(set)/card)
  return(sqrt(sum((setzero-edoozero)^2)))
}