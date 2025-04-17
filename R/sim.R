#' Scalar interval matrix
#' 
#' As defined by Tymoczko 2008 ("Scale Theory, Serial Theory and Voice Leading")
#' <https://onlinelibrary.wiley.com/doi/10.1111/j.1468-2249.2008.00257.x>,
#' the **s**calar **i**nterval **m**atrix represents the "rotations" of a set,
#' transposed to begin on 0, in its columns. Its nth row represents the
#' specific intervals which represent its generic interval of size n.
#'
#' @inheritParams tnprime
#' @returns Numeric `n` by `n` matrix where `n` is the number of notes in `set`
#' @examples
#' diatonic_modes <- sim(c(0, 2, 4, 5, 7, 9, 11))
#' print(diatonic_modes)
#'
#' miyakobushi_modes <- sim(c(0, 1, 5, 7, 8)) # rows show trivalence
#' print(miyakobushi_modes)
#' @export
sim <- function(set, edo=12) {
  transpose_down <- function(set) set - set[1]

  res <- sapply(0:(length(set)-1), rotate, x=set, transpose_up=TRUE,edo=edo)
  apply(res, 2, transpose_down)
}