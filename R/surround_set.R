random_sphere_points <- function(card, numpoints, distance=1) {
  points <- replicate(numpoints, stats::rnorm(card))
  normalize <- function(vec) {
    z <- sqrt(sum(vec^2))
    vec * (distance/z)
  }

  apply(points, 2, normalize)
}

#' Random scales uniformly distributed on a hypersphere around an input
#'
#' @description
#' Sometimes you want to explore what other scale structures a given scale
#' is *close* to. This can be done by studying the network of color adjacencies
#' in suitably low cardinalities (see "Modal Color Theory," 31-37), but it can
#' also be rewarding simply to randomly sample scales that are suitably close
#' to the one you started with.
#'
#' The larger your starting scale, the more complicated is the geometry of the
#' color space it lives in. Therefore this function generates a larger number
#' of random scales for larger cardinalities: by default, if the length of
#' the input `set` is `card`, `surround_set` gives `card * 100` output scales.
#' The parameter `magnitude` controls the order of magnitude of your sample 
#' (i.e. if you want ~1000 scales rather than ~100, set `magnitude=3`).
#'
#' The size of the hypersphere which the function samples is, by default, 1.
#' When we're working with a unit of 12 semitones per octave, 1 semitone of
#' voice leading work can get you pretty far away from the original set,
#' especially in higher cardinalities. (For instance, C major to C melodic
#' minor is just 1 semitone of motion, but there are 3 other colors that 
#' intervene between these two scales along a direct path.) Depending on your
#' goals, you might want to try a couple different orders of magnitude for
#' `distance`.
#'
#' @inheritParams signvector
#' @param magnitude Numeric value specifying how many sets to return. Defaults
#'   to `2`.
#' @param distance How far (in units of voice leading work, using the 
#'   Euclidean metric) should the sampled scales be from the input `set`?
#'
#' @returns a Matrix with `length(set)` rows and `10^magnitude` columns,
#'   representing `10^magnitude` different scales
#' 
#' @examples
#' # First we sample 30 trichords surrounding the minor triad 037.
#' chords_near_minor <- surround_set(c(0,3,7), magnitude=1, distance=.5)
#' chords_near_minor
#' 
#' # The next two commands will plot the sampled trichords on an x-y plane as
#' # circles; the minor triad that they surround is marked with a "+" sign.
#' plot(chords_near_minor[2,], chords_near_minor[3,], xlab="Third", ylab="Fifth")
#' points(3, 7, pch="+")
#'
#' # The following two commands will plot the two lines (i.e. hyperplanes) that
#' # demarcate the boundaries of the minor triad's color. Most but not all
#' # of our randomly generated points should fall in the space between the 
#' # two lines, in the same region as the "+" representing 037.
#' abline(0, 2)
#' abline(6, 1/2)
#' @export
surround_set <- function(set, magnitude=2, distance=1) {
  card <- length(set)
  num_sets <- card * 10^magnitude

  offsets <- random_sphere_points(card-1, num_sets, distance=distance)
  leading_zeroes <- rep(0, num_sets)
  res <- offsets + set[2:card]
  res <- rbind(leading_zeroes, res)
  rownames(res) <- NULL
  res
}