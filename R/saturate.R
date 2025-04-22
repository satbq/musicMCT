#' Modify evenness without changing hue
#'
#' @description
#' Saturation parameterizes scale structures along a single degree of freedom
#' which corresponds to size of the vector from the "white" perfectly even
#' scale to the scale in question. Variation in a scale's saturation minimally
#' affects its structural properties. The function `saturate()` takes
#' in a scale and a saturation parameter (`r`) and returns another scale
#' along the same line (i.e. including the scale's hue and its scalar
#' involution--see "Modal Color Theory," 32).
#'
#' @inheritParams tnprime
#' @param r Numeric: the relative proportion to (de)saturate the set by. 
#'   If r is set to 0, returns white;
#'   if r = 1, returns the input set. If 0 < r < 1,
#'   the saturation is decreased. If r > 1, the saturation is increased, 
#'   potentially to the point where the set moves past some OPTIC boundary.
#'   If r < 0, the result is an "involution" of the set.
#'
#' @returns `saturate` returns another scale (a numeric vector of 
#'   same length as set).
#' 
#' @examples
#' lydian <- c(0, 2, 4, 6, 7, 9, 11)
#' qcm_fifth <- meantone_fifth()
#' qcm_dia <- sort(((0:6)*qcm_fifth)%%12)
#' evenness_ratio <- evenness(qcm_dia) / evenness(lydian)
#' desaturated_lydian <- saturate(evenness_ratio, lydian)
#' desaturated_lydian
#' qcm_dia
#'
#' ionian <- c(0, 2, 4, 5, 7, 9, 11)
#' involution_of_ionian <- saturate(-2, ionian)
#' convert(involution_of_ionian, 12, 42)
#' asword(ionian)
#' asword(involution_of_ionian)
#'
#' @export
saturate <- function(r, set, edo=12) {
  card <- length(set)
  origin <- edoo(card, edo)
  origin + r*(set-origin)
}

#' Do two scales lie on the same ray?
#'
#' Two scales which lie on the same ray from [edoo()] (the perfectly even
#' scale) differ only in their saturation and are said to belong to the same
#' "hue." They are not only members of a large "color" but also a much more
#' specific structure which preserves properties such as [ratio()] and the
#' precise shape of [brightnessgraph()]. `same_hue()` tests whether two
#' scales have this close relationship.
#'
#' @inheritParams tnprime
#' @param set_1,set_2 Numeric vectors of pitch-classes in the sets. Must be
#'   of same length.
#'
#' @returns Boolean: are the sets of the same hue? NB: `TRUE` for identical
#'   sets (even perfectly even scales); `FALSE` for scales which are
#'   related by "involution."
#'
#' @examples
#' set39 <- c(0, 5, 9, 10, 14, 16, 21)
#' set53 <- c(0, 7, 13, 16, 22 ,26, 33)
#' set39 <- convert(set39, 39, 12)
#' set53 <- convert(set53, 53, 12)
#' same_hue(set39, set53)
#' # Since they have the same hue, we can resaturate one to become the other:
#' relative_evenness <- evenness(set53)/evenness(set39)
#' set53
#' saturate(relative_evenness, set39)
#' 
#' # These two hexachords belong to the same quasi-pairwise well formed 
#' # color (see "Modal Color Theory," p. 37), but not to the same hue: 
#' guidonian_1 <- c(0, 2, 4, 5, 7, 9)
#' guidonian_2 <- convert(guidonian_1, 13, 12)
#' isTRUE(all.equal(signvector(guidonian_1), signvector(guidonian_2)))
#' same_hue(guidonian_1, guidonian_2)
#'
#' @export
same_hue <- function(set_1, set_2, edo=12, rounder=10) {
  if (length(set_1) != length(set_2)) {
    stop("set_1 and set_2 must be of the same size")
  }

  tiny <- 10^(-1 * rounder)
  set_1_is_white <- (evenness(set_1, edo=edo) < tiny)
  set_2_is_white <- (evenness(set_2, edo=edo) < tiny)
  if (set_1_is_white || set_2_is_white) {
    return(set_1_is_white && set_2_is_white)
  }

  central_sets <- apply(cbind(set_1, set_2), 2, coord_to_edo, edo=edo)
  rank_of_pair <- qr(central_sets)$rank
  if (rank_of_pair != 1) {
    return(FALSE)
  }

  as.logical((central_sets[, 1] %*% central_sets[, 2]) > 0)
}