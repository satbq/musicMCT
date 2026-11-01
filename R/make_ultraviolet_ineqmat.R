#' Define hyperplanes for ultraviolet arrangements
#'
#' Named to draw a parallel with the the "infrared" arrangements (see
#' [make_infrared_ineqmat()]), the "ultraviolet" arrangements are also primarily
#' intended to study voice leadings in conjunction with [vl_signvector()].
#' They evaluate whether a voice leading involves contrary motion in 
#' equal but opposite amounts, such as when the soprano rises two semitones
#' while the bass falls 2 semitones. In this, the ultraviolet arrangements
#' are complementary to the white arrangements of [make_white_ineqmat()].
#' Unlike many hyperplane arrangements in musicMCT, the ultraviolet arrangements
#' do not reflect transpositional equivalence.
#'
#' Combinatorial features of these arrangements are described in Richard 
#' Stanley, "A Zonotope Associated with Graphical Degree Sequences," in
#' *Applied Geometry and Discrete Mathematics: The Victor Klee Festschrift*,
#' 555-570, edited by Peter Gritzmann and Bernd Sturmfels (American
#' Mathematical Society, 1990).
#'
#' @inheritParams makeineqmat
#'
#' @returns A matrix with `card+1` columns and k rows, where k is the nth triangular number
#'
#' @seealso [make_infrared_ineqmat()] and [make_white_ineqmat()] for related
#' hyperplane arrangements.
#'
#' @examples
#' uv_trichord_ineqmat <- make_ultraviolet_ineqmat(3)
#' voice_leading_1 <- c(-1, 1, 0)
#' vl_signvector(voice_leading_1, ineqmat=uv_trichord_ineqmat)
#' 
#' # The first entry of the sign vector is 0 because the bass and alto voices
#' # move in a perfectly counterbalanced wedge. The second entry of the sign vector
#' # compares bass and soprano; the third entry compares alto and soprano:
#' print(uv_trichord_ineqmat)
#'
#' # If this voice leading is transposed ("Tinctoris transformed") up a semitone,
#' # then it will lie on no ultraviolet hyperplanes.
#' voice_leading_2 <- voice_leading_1 + 1
#' vl_signvector(voice_leading_2, ineqmat=uv_trichord_ineqmat)
#'
#' @export
make_ultraviolet_ineqmat <- function(card) {
  if (card < 2) {
    return(integer(0))
  }
  sd_pairs <- utils::combn(1:card, 2)
  origin <- edoo(card, edo=1)

  make_delta <- function(pair) -1*(origin[pair[1]] + origin[pair[2]])
  deltas <- apply(sd_pairs, 2, make_delta)
  make_row <- function(pair) {
    new_row <- rep(0, card)
    new_row[pair] <- 1
    return(new_row)
  }

  res <- t(apply(sd_pairs, 2, make_row))
  res <- cbind(res, deltas)
  colnames(res) <- NULL
  res
}
