#' Define hyperplanes for quasi-white arrangements
#'
#' Although the hyperplane arrangements of Modal Color Theory determine most
#' scalar properties, there are some potentially interesting questions which
#' require different arrangements. This function makes "quasi-white" arrangements
#' which consider how many of a scale's intervals correspond exactly to the 
#' "white" or perfectly even color for their generic size. That is, for an 
#' interval `x` belonging to generic size `g` in an `n` note scale, does
#' \eqn{x = g \cdot \frac{edo}{n}}? This may be relevant, for instance, because
#' two modes have identical sum brightnesses when the interval that separates
#' their tonics is "white" in this way. Mostly you will want to use these
#' matrices as inputs to functions with an `ineqmat` parameter.
#'
#' In many cases, it is desirable to use a combination of the MCT `ineqmat` from
#' [makeineqmat()] and the quasi-white `ineqmat` from `make_white_ineqmat()`. Generally
#' these are distinct, but they do have some shared hyperplanes in even cardinalities
#' related to formal tritones (intervals that divide the scale exactly in half).
#' Therefore it's normally a good idea to use something along the lines of:
#' ```
#' my_ineqmat <- unique(rbind(makeineqmat(card), make_white_ineqmat(card)), MARGIN=1)
#' ```
#' to get rid of the duplicated hyerplanes.
#'
#' @inheritParams makeineqmat
#'
#' @returns A matrix with `card+1` columns and k rows, where k is the nth triangular number
#'
#' @examples
#' major_triad <- c(0, 4, 7)
#' howfree(major_triad)
#' howfree(major_triad, ineqmat=make_white_ineqmat(3))
#' # Because it's now constrained to preserve its step of exactly 1/3 the octave.
#'
#' just_major_triad <- j(1, 3, 5)
#' howfree(just_major_triad)
#' howfree(just_major_triad, ineqmat=make_white_ineqmat(3))
#' # Because this triad's major third isn't identical to 400 cents which equally
#' # divide the octave.
#'
#' ait1 <- c(0, 1, 4, 6)
#' quantize_color(ait1, reconvert=TRUE)
#' # quantize_color() doesn't match (0146) exactly because it's only looking for
#' # any set in the same 3-dimensional color as 0146.
#'
#' quantize_color(ait1, ineqmat=make_white_ineqmat(4), reconvert=TRUE)
#' # Now that it's constrained to respect ait1's minor third from 1 to 4, the set 0146
#' # is now the first satisfactory result that quantize_color() finds.
#'
#' @export
make_white_ineqmat <- function(card) {
  index_pairs <- utils::combn(card, 2)
  generic_sizes <- index_pairs[2,] - index_pairs[1,]
  pairs_and_sizes <- rbind(index_pairs, generic_sizes)

  generate_row <- function(column_vector) {
    res <- rep(0, card+1)
    res[column_vector[1]] <- 1
    res[column_vector[2]] <- -1
    res[card+1] <- column_vector[3]/card
    res
  }

  ineqmat <- t(apply(pairs_and_sizes, 2, generate_row))

  # Scale each row so the constant column is -1
  # for comparison with original makeineqmat() results.
  ineqmat/-ineqmat[,card+1]  
}