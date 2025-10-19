#' Define hyperplanes for white arrangements
#'
#' @description
#' Although the hyperplane arrangements of Modal Color Theory determine most
#' scalar properties, there are some potentially interesting questions which
#' require different arrangements. This function makes "white" arrangements
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
#' Therefore, the function `make_pastel_ineqmat()` exists to give the result of combining
#' them with duplicates removed. (The moniker "pastel" is
#' meant to suggest combining the colors of MCT arrangements with a white pigment
#' from white arrangements.)
#'
#' Just as the MCT arrangements are concretized by the files "representative_scales"
#' and "representative_signvectors," the white and pastel arrangements are represented 
#' by [offwhite_scales](https://github.com/satbq/modalcolortheory/blob/main/offwhite_scales.rds), 
#' [offwhite_signvectors](https://github.com/satbq/modalcolortheory/blob/main/offwhite_signvectors.rds), 
#' [pastel_scales](https://github.com/satbq/modalcolortheory/blob/main/pastel_scales.rds), and
#' [pastel_signvectors](https://github.com/satbq/modalcolortheory/blob/main/pastel_signvectors.rds).
#' This data has not been as thoroughly vetted as the files for the MCT arrangements, and currently
#' white and pastel arrangements are only represented up through cardinality 6.
#' The files are hosted at the [modalcolortheory repo](https://github.com/satbq/modalcolortheory)
#' like representative_scales because they are too large to include in musicMCT.
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
  if (card < 2) {
    return(integer(0))
  }

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

#' @rdname make_white_ineqmat
#' @export
make_pastel_ineqmat <- function(card) {
  new_ineqmat <- rbind(getineqmat(card), make_white_ineqmat(card))
  unique(new_ineqmat, MARGIN=1)
}

#' Define hyperplanes for transposition-sensitive arrangements
#'
#' The "black" hyperplane arrangement compares a set's scale degrees
#' individually to the pitches of `edoo(card)` (where `card` is the 
#' number of notes in `set`). This primarily has the purpose of attending
#' to the overall transposition level of a set. Most applications of Modal
#' Color Theory assume transpositional equivalence, but occasionally it
#' is useful to relax that assumption. Sum class (Straus 2018, 
#' \doi{doi:10.1215/00222909-7127694}) is a natural way to track
#' this information, but the "black" arrangements do so qualitatively
#' in the spirit of modal color theory. `make_black_ineqmat()` returns only
#' the inequality matrix for the "black" arrangement, while `make_gray_ineqmat()`
#' for convenience combines the results of [make_white_ineqmat()] and `make_black_ineqmat()`.
#'
#' @inheritParams makeineqmat
#'
#' @returns A `card` by `card+1` inequality matrix (for `make_black_ineqmat()`) or
#'   the result of combining white and black inequality matrices (in that order) for
#'   `make_gray_ineqmat()`.
#'
#' @examples
#' # The set (1, 4, 7)'s elements are respectively below, equal to, and
#' # above the pitches of edoo(3).
#' test_set <- c(1, 4, 7)
#' signvector(test_set, ineqmat=make_black_ineqmat(3))
#'
#' # The result changes if you transpose test_set down a semitone:
#' signvector(test_set - 1, ineqmat=make_black_ineqmat(3))
#'
#' # The results from signvector(..., ineqmat=make_black_ineqmat) can
#' # also be calculated with coord_to_edo():
#' sign(coord_to_edo(test_set))
#' sign(coord_to_edo(test_set - 1))
#' @seealso [make_white_ineqmat()]
#' @export
make_black_ineqmat <- function(card) {
  if (card < 1) {
    return(integer(0))
  }
  sd_columns <- diag(card)
  last_column <- -1 * ((0:(card-1))/card)
  res <- cbind(sd_columns, last_column)
  colnames(res) <- NULL
  res
}

#' @rdname make_black_ineqmat
#' @export
make_gray_ineqmat <- function(card) {
  rbind(make_white_ineqmat(card), make_black_ineqmat(card))
}