#' Specify a scale's step pattern with a sign vector
#'
#' Rather than calculate the full sign vector from the "modal color" hyperplane
#' arrangement, sometimes it's advantageous to use a signvector that reflects
#' only the pairwise comparisons on a scale's steps. This function does that.
#'
#' @inheritParams signvector
#' @returns A vectors of signs, `-1`, `0`, and `1`, corresponding to the step-related
#'   hyperplanes in the defined `ineqmat`.
#' @examples
#' step_signvector(sc(7,35)) # Half the length of a full sign vector for heptachords:
#' signvector(sc(7,35))
#' @export
step_signvector <- function(set, ineqmat=NULL, edo=12, rounder=10) {
  card <- length(set)
  if (is.null(ineqmat)) {
    card <- length(set)
    ineqmat <- getineqmat(card)
  }

  step_rows <- ineqmat[get_relevant_rows(1, ineqmat=ineqmat),]
  signvector(set, ineqmat=step_rows, edo=edo, rounder=rounder)
}