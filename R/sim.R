#' Scalar (and interscalar) interval matrix
#' 
#' As defined by Tymoczko 2008 ("Scale Theory, Serial Theory and Voice Leading")
#' \doi{doi:10.1111/j.1468-2249.2008.00257.x},
#' the **s**calar **i**nterval **m**atrix represents the "rotations" of a set,
#' transposed to begin on 0, in its columns. Its nth row represents the
#' specific intervals which represent its generic interval of size n. If changed
#' from its default (`NULL`), the parameter `goal` calculates Tymoczko's 
#' *interscalar* interval matrix from `set` to `goal`.
#'
#' @inheritParams tnprime
#' @param goal Numeric vector of same length as set. Defaults to `NULL`.
#' @returns Numeric `n` by `n` matrix where `n` is the number of notes in `set`
#' @examples
#' diatonic_modes <- sim(c(0, 2, 4, 5, 7, 9, 11))
#' print(diatonic_modes)
#'
#' miyakobushi_modes <- sim(c(0, 1, 5, 7, 8)) # rows show trivalence
#' print(miyakobushi_modes)
#'
#' # Interscalar Interval Matrix:
#' sim(c(0, 3, 6, 10), c(0, 4, 7, 10))
#'
#' # Note that the interscalar matrices factor out transposition:
#' minor <- c(0, 3, 7)
#' major <- c(0, 4, 7)
#' sim(minor, major)
#' sim(minor-1, major)
#' sim(minor, major+2)
#'
#' # But not permutation:
#' major_64 <- c(0, 5, 9)
#' major_open <- c(0, 7, 4)
#' sim(minor, major_64)
#' sim(minor, major_open)
#'
#' @export
sim <- function(set, goal=NULL, edo=12, rounder=10) {
  card <- length(set)
  transpose_down <- function(set) set - set[1]

  if (!is.null(goal)) {
    goal <- startzero(goal, sorted=FALSE, edo=edo, rounder=rounder)
    set <- startzero(set, sorted=FALSE, edo=edo, rounder=rounder)
    temp <- set
    set <- goal
    goal <- temp
  }

  res <- sapply(0:(card-1), rotate, x=set, transpose_up=TRUE, edo=edo)
  if (is.null(goal)) { 
    apply(res, 2, transpose_down)
  } else {
    res - t(replicate(card, goal))
  }
}

#' Sum brightness
#'
#' ["Modal Color Theory"](https://doi.org/10.1215/00222909-11595194) (p. 6) describes 
#' two ways to measure the brightness of a scale.
#' Sum brightness is the simpler of the two. It simply adds together the heights of all
#' scale degrees above the tonic. See also Section 3.2 of "Bright notes, dark scales."
#'
#' @inheritParams tnprime
#' @param mode Which mode of the scale is desired? Integer, defaults to 0. Zero-indexed,
#'   so that the default is to return the sum brightness of the entered `set`.
#' @returns Single numeric value: the sum brightness of the specified mode.
#' @examples
#' c_major <- c(0, 2, 4, 5, 7, 9, 11)
#' d_major <- tn(c_major, 2, optic="p") # NB octave equivalent must NOT be used
#' c_dorian <- c(0, 2, 3, 5, 7, 9, 10)
#'
#' sum_brightness(c_major)
#' sum_brightness(d_major)
#' sum_brightness(c_major, mode=1)
#' sum_brightness(c_dorian)
#'
#' @export
sum_brightness <- function(set, mode=0, edo=12, rounder=10) {
  colSums(sim(set, goal=NULL, edo=edo, rounder=rounder))[quasimod(mode+1, length(set))]
}