approximate_from_signvector <- function(signvec, ineqmat=NULL, card=NULL, edo=12, rounder=10) {
  if (is.null(ineqmat)) {
    if (is.null(card)) { warning("Either cardinality or inequality matrix must be specified.") } else {
      ineqmat <- getineqmat(card) }
  }

  res <- qr.solve(ineqmat[, 2:(dim(ineqmat)[2]-1)], signvec) # this assumes T equivalence and a central arrangement
  res <- coord_from_edo(c(0, res), edo=edo)
  return(res)
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
#'   to 12-tone equal tempered semitones. May also return a vector
#'   of `NA`s of length `card` if no suitable scale was found beneath the limit given by
#'   `nmax`.
#'
#' @examples
#' # This first command produces a real tetrachord:
#' set_from_signvector(c(-1, 1, 1, -1, -1, -1, 0, -1), 4)
#'
#' # But this one, which changes only the last entry of the previous sign vector
#' # has no solution so will return a string of `NA` values.
#' set_from_signvector(c(-1, 1, 1, -1, -1, -1, 0, 1), 4)
#'   
#' @export
set_from_signvector <- function(signvec, card, nmax=12, reconvert=FALSE, ineqmat=NULL,
                                edo=12, rounder=10) {
  usual_ineqmat <- getineqmat(card)
  if (is.null(ineqmat)) { ineqmat <- usual_ineqmat }

  # Note that for this step we use the usual "Modal Color Theory" ineqmat, not any custom-input ineqmat,
  # because using an ineqmat with extra rows may make it impossible for approximate_from_signvector to generate
  # a scale with the right step-word.
  set_from_word <- approximate_from_signvector(signvec[get_relevant_rows(1, ineqmat=usual_ineqmat)],
                                               ineqmat=usual_ineqmat[get_relevant_rows(1, ineqmat=usual_ineqmat),])
  implied_word <- asword(set_from_word, edo=edo, rounder=rounder)

  # From here we reuse code from quantize_color:
  letters <- sort(unique(implied_word), decreasing=FALSE)

  startedo <- sum(implied_word)
  current_set <- cumsum(c(0, implied_word))[1:card]

  if (isTRUE(all.equal(signvector(current_set, ineqmat=ineqmat, edo=startedo, rounder=rounder), signvec))) {
    result_list <- list(set=current_set, edo=startedo)
    if (reconvert==TRUE) {
      return(convert(result_list$"set", result_list$"edo", edo))
    } else {
      return(result_list)
    }
  }

  options <- utils::combn(nmax,length(letters))
  stop <- dim(options)[2]

  for (i in 1:stop) {
      newletters <- options[,i]
      res <- implied_word

    for (j in seq_along(letters)) {
      res <- replace(res, which(implied_word==letters[j]), newletters[j])
    }

    current_edo <- sum(res)
    current_set <- cumsum(c(0,res))[1:card]

    current_signvec <- signvector(current_set, ineqmat=ineqmat, edo=current_edo, rounder=rounder)

    if (isTRUE(all.equal(current_signvec, signvec))) {
          result_list <- list(set=current_set, edo=current_edo)
          if (reconvert==TRUE) {
            return(convert(result_list$"set", result_list$"edo", edo))
          } else {
            return(result_list)
          }
    }
  }
  return(rep(NA,card))

}
