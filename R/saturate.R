#' Hue, color, saturation
#'
#' @description
#' The central concepts in the visual conceit of "Modal Color Theory,"
#' classfiying scales at different levels of granularity according to their
#' voice-leading properties. See "Modal Color Theory," 19-23.
#'
#' Saturation paramterizes scale structures along a single degree of freedom
#' which corresponds to size of the vector from the "white" perfectly even
#' scale to the set in question. Variation in a scale's saturation minimally
#' affects the scale's structural properties. The function `saturate` takes
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
#' lydian <- c(0,2,4,6,7,9,11)
#' qcm_fifth <- meantone_fifth()
#' qcm_dia <- sort(((0:6)*qcm_fifth)%%12)
#' evenness_ratio <- evenness(qcm_dia) / evenness(lydian)
#' desaturated_lydian <- saturate(evenness_ratio, lydian)
#' desaturated_lydian
#' qcm_dia
#'
#' ionian <- c(0,2,4,5,7,9,11)
#' involution_of_ionian <- saturate(-2, ionian)
#' convert(involution_of_ionian, 12, 42)
#' asword(ionian)
#' asword(involution_of_ionian)
#'
#' @export
saturate <- function(r, set, edo=12) {
  card <- length(set)
  origin <- edoo(card, edo)
  vec <- origin + r*(set-origin)

  return(vec)
}