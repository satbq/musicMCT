#' Look up a scale at Ian Ring's *Exciting Universe of Music Theory*
#'
#' Ian Ring's website [*The Exciting Universe 
#' of Music Theory*](https://ianring.com/musictheory/) is a
#' comprehensive and useful compilation of information about pitch-class
#' sets in twelve-tone equal temperament. It tracks many properties that
#' musicMCT is unlikely to duplicate, so this function opens the corresponding
#' page for a pc-set in your browser. This only works for sets in 12-edo which
#' include pitch-class 0.
#'
#' @inheritParams tnprime
#'
#' @returns Invisibly, the integer which Ring's site uses to index the
#'  input `set`. The main purpose of the function is its side effect of
#'  opening a page of Ring's site in a browser.
#'
#' @examples
#' c_major <- c(0, 2, 4, 5, 7, 9, 11)
#' c_major_value <- ianring(c_major)
#' print(c_major_value)
#' # And indeed you should find information about the major scale
#' # at https://ianring.com/musictheory/scales/2741
#'
#' @examplesIf interactive()
#' ianring(c(0, 2, 3, 7, 8))
#'
#' @export
ianring <- function(set) {
  set_as_distro <- sign(set_to_distribution(set, edo=12, rounder=10))
  weights <- 2^(0:11)
  value <- as.integer(sum(set_as_distro %*% weights))

  if (interactive()) {
    ring_url <- paste0("https://ianring.com/musictheory/scales/", value)
    utils::browseURL(ring_url)
  }

  invisible(value)
}
