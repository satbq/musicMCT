get_adjacent_sizes <- function(set, edo=12) {
  sorted_generic_intervals <- apply(sim(set, edo), 1, sort)
  all_intervals <- as.numeric(sorted_generic_intervals)
  diff(all_intervals)
}

#' Rothenberg propriety
#'
#' [Rothenberg (1978)](https://doi.org/10.1007/BF01768477) identifies a potentially 
#' desirable trait for scales which he calls "propriety." Loosely speaking,
#' a scale is proper if its specific intervals are well sorted in terms of the 
#' generic intervals they belong to. A scale is *strictly* proper if, given
#' two generic sizes g and h such that g < h, every specific size corresponding
#' to g is smaller than every specific size corresponding to h. A scale if
#' improper if any specific size of g is larger than any specific size of h.
#' An *ambiguity* occurs if any size of g equals any size of h: scales with
#' ambiguities are weakly but not strictly proper.
#'
#' @inheritParams tnprime
#' @param strict Boolean: should only strictly proper scales pass?
#'
#' @returns Boolean which answers whether the input satisfies the property named by the 
#'   function
#'
#' @examples
#' c_major <- c(0, 2, 4, 5, 7, 9, 11)
#' has_contradiction(c_major)
#' strictly_proper(c_major)
#' isproper(c_major)
#' isproper(c_major, strict=FALSE)
#'
#' just_major <- 12 * log2(c(1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8))
#' isproper(just_major)
#'
#' pythagorean_diatonic <- sort(((0:6)*12*log2(1.5))%%12)
#' isproper(pythagorean_diatonic)
#' has_contradiction(pythagorean_diatonic)
#'
#' @export
isproper <- function(set, edo=12, rounder=10, strict=TRUE) {
  no_contradictions <- !has_contradiction(set, edo, rounder)
  is_strict <- strictly_proper(set, edo, rounder)

  if (strict==FALSE) {
    return(no_contradictions)
  }

  no_contradictions && is_strict
}

#' @rdname isproper
#' @export
has_contradiction <- function(set, edo=12, rounder=10) {
  tiny <- 10^(-1*rounder)
  adjacent_sizes <- get_adjacent_sizes(set, edo)

  !as.logical(prod(adjacent_sizes > -1 * tiny))
}

#' @rdname isproper
#' @export
strictly_proper <- function(set, edo=12, rounder=10) {
  tiny <- 10^(-1*rounder)
  card <- length(set)
  adjacent_sizes <- get_adjacent_sizes(set, edo)

  crossing_between_generics <- ((1:(card-1))*card)
  is_strict <- adjacent_sizes[crossing_between_generics] > tiny
  as.logical(prod(is_strict))
}

