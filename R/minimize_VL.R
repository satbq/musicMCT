#' Smallest voice leading between two sets
#'
#' Given a `source` set and a `goal` to move to, find the "strongly
#' crossing-free" voice leading from `source` to `goal` with smallest size.
#' 
#' @param source Numeric vector, the pitch-class set at the start of your voice leading
#' @param goal Numeric vector, the pitch-class set at the end of your voice leading
#' @param method What distance metric should be used? Defaults to `"taxicab"` but can be `"euclidean"`.
#' @param no_ties If multiple VLs are equally small, should only one be returned? Defaults to `FALSE`, which
#'   is generally what a human user should want. Some functions that call `minimize_VL` need `TRUE` for predictable
#'   shapes of the returned value.
#' @inheritParams tnprime
#' 
#' @returns Numeric array. In most cases, a vector the same length as `source`;
#'    or a vector of `NA` the same length as `source` if `goal` and
#'   `source` have different lengths. If `no_ties=FALSE` and multiple voice leadings
#'   are equivalent, the array can be a matrix with `m` rows where `m` is the number
#'   of equally small voice leadings.
#' @examples
#' c_major <- c(0,4,7)
#' ab_minor <- c(8,11,3)
#' minimizeVL(c_major, ab_minor)
#'
#' diatonic_scale <- c(0,2,4,5,7,9,11)
#' minimizeVL(diatonic_scale, tn(diatonic_scale, 7))
#'
#' d_major <- c(2,6,9)
#' minimizeVL(c_major, d_major)
#' minimizeVL(c_major, d_major, no_ties=TRUE)
#' minimizeVL(c_major, d_major, method="euclidean", no_ties=FALSE)
#'
#' minimizeVL(c(0,4,7,10),c(7,7,11,2),method="euclidean")
#' minimizeVL(c(0,4,7,10),c(7,7,11,2),method="euclidean", no_ties=TRUE)
#' @export

minimizeVL <- function(source, goal, method="taxicab", no_ties=FALSE, edo=12) {
  card <- length(source)
  if (card != length(goal)) { 
    warning("Goals and source should have the same cardinality. 
  You might want to double notes in your smaller (multi)set.")
    return(rep(NA, card)) 
  }

  goal <- goal[order(source)] # Presumes P-equivalence; otherwise not much point

  modes <- sapply(0:(card-1), rotate, x=goal, edo=edo)
  voice_leadings <- t(t(modes)-source)
  voice_leadings[] <- sapply(voice_leadings, signed_interval_class, edo=edo)
  if (method == "taxicab") {
    vl_scores <- colSums(apply(voice_leadings, 1, abs))
  }
  if (method == "euclidean") {
    vl_scores <- sqrt(rowSums(voice_leadings^2))
  }
  index <- which(vl_scores == min(vl_scores))

  if (no_ties) { index <- index[1] }

  return(voice_leadings[index,])
}