#' Translate a hyperplane arrangement to a new center
#'
#' By default, the various hyperplane arrangements of musicMCT treat
#' the "white" perfectly even scale as their center. (It is the point
#' where all the hyperplanes of the MCT, white, and black arrangements
#' intersect, and although the Rothenberg arrangements do not pass through
#' the scale by definition, it is still a center of symmetry for them.)
#' This function let you construct hyperplane arrangements that have been
#' shifted to treat any other set as their center. (Details on why you might
#' want this to come.)
#'
#' @param set Numeric vector of pitch-classes in the set intended to be the
#'   center of the new arrangement
#' @inheritParams colornum
#'
#' @returns A matrix with the same shape as the ones that define the standard
#'   arrangement of type `ineqmat`
#'
#' @examples
#' # When used for the sign vector with any central arrangement, the
#' # input `set` will have a sign vector of all 0s:
#' viennese_trichord <- c(0, 1, 6)
#' signvector(viennese_trichord, ineqmat=make_offset_ineqmat(viennese_trichord))
#'
#' # Where does melodic minor lie in relation to major?
#' major <- c(0, 2, 4, 5, 7, 9, 11)
#' melmin <- c(0, 2, 3, 5, 7, 9, 11)
#' signvector(melmin, ineqmat=make_offset_ineqmat(major, ineqmat="white"))
#' 
#' @seealso [makeineqmat()] for modal color theory arrangements; [make_white_ineqmat()],
#'   [make_black_ineqmat()], and [make_roth_ineqmat()] for other relevant arrangements.
#' @export
make_offset_ineqmat <- function(set, ineqmat=NULL, edo=12) {
  card <- length(set)
  if (card < 2) {
    warning("Input set too small. Did you mistakenly enter a cardinality rather than a set?")
    return(integer(0))
  }

  set <- set/edo
  ineqmat <- choose_ineqmat(set, ineqmat)
  ineqmat <- ineqmat[, -(card+1)]

  if (!inherits(ineqmat, "matrix")) {
    ineqmat <- t(ineqmat)
  }

  constants <- ineqmat %*% set
  constants <- -1 * constants

  cbind(ineqmat, constants)  
}