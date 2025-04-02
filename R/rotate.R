#' Circular rotation of an ordered tuple
#' 
#' Changes which element of a circularly-ordered series is in the first
#' position without otherwise changing the order. Used primarily to generate
#' the modes of a scale. Single application moves one element from the 
#' beginning of a tuple to the end.
#'
#' @param x Vector to be rotated
#' @param n Number of positions the vector should be rotated left.
#'   Defaults to `1`. May be negative.
#' @param transpose_up Boolean, defaults to `FALSE` which leaves entires 
#'   unchanged. If set to `TRUE`, elements moved from the head to the tail
#'   of the vector are increased in value by `edo`.
#' @inheritParams edoo
#' @returns (Rotated) vector of same length as x
#' @examples
#' rotate(c(0, 2, 4, 5, 7, 9, 11), n=2)
#' rotate(c(0, 2, 4, 5, 7, 9, 11), n=-2)
#' rotate(c(0, 2, 4, 5, 7, 9, 11), n=2, transpose_up=TRUE)
#' rotate(c(0, 2, 4, 5, 7, 9, 11), n=2, transpose_up=TRUE, edo=15)
#' rotate(c("father", "charles", "goes", "down", "and", "ends", "battle"),
#'   n=4)
#' @export
rotate <- function(x, n=1, transpose_up=FALSE, edo=12) {
  len <- length(x)
  n <- n %% length(x)

  if (transpose_up==TRUE && n != 0) {
    x[1:n] <- x[1:n] + edo
  }

  res <- c( utils::tail(x,len-n), utils::head(x,n) )

  return(res)
}