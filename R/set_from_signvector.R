#' Try to use linear algebra to generate a scale from a sign vector
#'
#' Often sign vectors don't provide enough information to reconstruct
#' a specific scale that might have generated them. (Moreoever, not 
#' all potential sign vectors are created by real scales.) However, 
#' sometimes it's useful to start from a "rough draft" that gets 
#' *close* to the desired result. This is more likely to be 
#' completely successful in simpler hyperplane arrangements. For 
#' instance, set_from_signvector() doesn't use the whole MCT arrangement
#' but instead only the hyperplanes that affect step sizes.
#'
#' @param signvec The signvector of a scale you'd like to generate
#' @inheritParams signvector
#' @param card The number of notes in the desired scale
#' 
#' @returns A numeric vector of length `card` that should have a similar sign vector 
#'   to the input `signvec`
#'
#' @noRd
approximate_from_signvector <- function(signvec, ineqmat=NULL, card=NULL, edo=12, rounder=10) {
  if (is.null(ineqmat)) {
    if (is.null(card)) { 
      stop("Either cardinality or inequality matrix must be specified.") 
    } else {
      ineqmat <- getineqmat(card) 
    }
  }

  res <- qr.solve(ineqmat[, 2:(dim(ineqmat)[2]-1)], signvec) # this assumes T equivalence and a central arrangement
  coord_from_edo(c(0, res), edo=edo)
}

#' Create a scale from a sign vector
#'
#' This function attempts to take in a sign vector (and associated cardinality
#' and `ineqmat`) and create a scale whose sign vector matches the input.
#' This is not always possible because not all sign vectors correspond to
#' colors that actually exist (just like there is no Fortean set class with
#' the interval-class vector `<1 1 0 1 0 0>`). The function will do its best
#' but may eventually time out, using a similar process as [quantize_color()].
#' You can increase the search time by increasing `nmax`, but in some cases
#' you could search forever and still find nothing. I don't advise trying to
#' use this function on many sign vectors at the same time.
#'
#' @inheritParams quantize_color
#' @param signvec Vector of `0`, `-1`, and `1`s: the sign vector that 
#'   you want to realize.
#' @param card Integer: the number of notes in your desired scale.
#'
#' @returns If `reconvert=FALSE`, a list of two elements: element 1 is `set` with a vector of integers
#'   representing the realized scale; element 2 is `edo` representing the number k of unit steps in the
#'   mod k universe. If `reconvert=TRUE`, returns a single numeric vector converted to measurement relative
#'   to 12-tone equal tempered semitones. Values may be `NA` if no suitable quantization was found beneath 
#'   the limit given by nmax or in target_edo (if specified). 
#'
#' @examples
#' # This first command produces a real tetrachord:
#' set_from_signvector(c(-1, 1, 1, -1, -1, -1, 0, -1), 4)
#'
#' # But this one, which changes only the last entry of the previous sign vector
#' # has no solution so will return only `NA`s.
#' set_from_signvector(c(-1, 1, 1, -1, -1, -1, 0, 1), 4)
#'   
#' @export
set_from_signvector <- function(signvec, 
                                card, 
                                nmax=12, 
                                reconvert=FALSE, 
                                ineqmat=NULL,
                                target_edo=NULL,
                                edo=12, 
                                rounder=10) {

  ineqmat <- choose_ineqmat(edoo(card), ineqmat)

  ineqmat_step_rows <- get_relevant_rows(1, ineqmat=ineqmat)
  step_ineqmat <- ineqmat[ineqmat_step_rows,]
  set_from_word <- approximate_from_signvector(signvec[ineqmat_step_rows], ineqmat=step_ineqmat)
  implied_word <- asword(set_from_word, edo=edo, rounder=rounder)

  # See quantize_color.r for try_scale_from_word()
  try_scale_from_word(signvec=signvec, 
                      word=implied_word,
                      nmax=nmax, 
                      reconvert=reconvert, 
                      ineqmat=ineqmat, 
                      target_edo=target_edo,
                      edo=edo, 
                      rounder=rounder)
}
