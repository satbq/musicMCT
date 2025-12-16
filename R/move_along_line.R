#' Intersection of a line with a hyperplane
#'
#' @description
#' Navigate scale space by finding the point where a given line intersects with
#' a given hyperplane. Hyperplanes are specified by the `row` and `ineqmat` parameters.
#' That is, the hyperplane is given by the `row`th row of the specified `ineqmat`. An
#' arbitrary hyperplane can be specified by entering `row=1` with the desired hyperplane
#' as a 1-row matrix as the input to `ineqmat`.
#' 
#' For the line, two different use cases are available. In the first, `set` is specified.
#' In this case, the line in question is the given `set`'s "hue" (i.e., the line which runs
#' from [edoo()] to `set`). This is useful when exploring non-central arrangements such as
#' the Rothenberg arrangements ([make_roth_ineqmat()]); for an arrangement centered on [edoo()],
#' it will simply return [edoo()]. In the second, `set` is left `NULL` and both `point` and
#' `direction` must be specified. Here, the given line is the one which runs through `point` parallel
#' to the vector specified by `direction`.
#'
#' @param row Integer specifying the hyperplane to be intersected as a row of `ineqmat`.
#' @param set Numeric vector representing a scale. Defaults to `NULL`; if specified, will 
#'   give the intersecting line as the scale's "hue."
#' @param point Numeric vector representing a point on the line. Overridden by `set`.
#' @param direction Numeric vector representing the direction of the line. Overridden by `set`.
#' @inheritParams signvector
#' @inheritParams minimize_vl
#'
#' @returns A list with three entries: `set`, `dist`, and `sign`. `set` is a numeric vector with the
#'   intersection point of the given line and hyperplane. `dist` gives the voice-leading distance
#'   (as measured using `method`) from input `set` or `point` to the result `set`. `sign` indicates
#'   whether the intersection point lies along the given `direction` or opposite it. (For instance,
#'   when a hue is specified by input `set`, a positive `sign` indicates that the intersection belongs
#'   to the same color as input `set`, whereas a negative `sign` indicates that the intersection is a
#'   scalar involution of the input.)
#'
#'   If the line lies entirely on the given hyperplane, the returned `set` simply matches the input,
#'   while `dist` and `sign` are 0. If the line and hyperplane do not intersect, the result `set` is
#'   a vector of `NA`s the same length as the input `set` or `point`; `dist` is `Inf` and `sign` is `NA`.
#'   In both of these cases, a warning is given.
#'
#' @examples
#' major_triad <- c(0, 4, 7)
#' # Let's find where the major triad's hue first intersects a Rothenberg hyperplane:
#' move_to_hyperplane(3, set=major_triad, ineqmat="roth")
#' same_hue(major_triad, c(0, 4, 6))
#' strictly_proper(major_triad)
#' strictly_proper(c(0, 4, 6))
#'
#' # But the major triad's hue intersects every MCT hyperplane at the center of the space:
#' move_to_hyperplane(3, set=major_triad, ineqmat="mct")
#'
#' # Let's move away from the major triad in other directions than its hue:
#' lower_third <- c(0, -1, 0)
#' move_to_hyperplane(1, point=major_triad, direction=lower_third)
#' move_to_hyperplane(2, point=major_triad, direction=lower_third)
#' move_to_hyperplane(3, point=major_triad, direction=lower_third)
#'
#' @export
move_to_hyperplane <- function(row,
                               set=NULL, 
                               point=NULL, 
                               direction=NULL, 
                               ineqmat=NULL, 
                               method = c("taxicab", "euclidean", "chebyshev", "hamming"),
                               edo=12, 
                               rounder=10) {
  set_given <- !is.null(set)
  if (set_given) {
    card <- length(set)
    point <- edoo(card, edo=edo)
    direction <- coord_to_edo(set, edo=edo)
  } else {
    if (is.null(point) || is.null(direction)) {
      stop("If set is not given, both point and direction must be specified.")
    }
    card <- length(point)
    set <- point
  }

  tiny <- 10^(-1 * rounder)

  ineqmat <- choose_ineqmat(point, ineqmat)
  ineq_dim <- dim(ineqmat)[2] - 1

  normal_vec <- ineqmat[row, 1:ineq_dim]
  hyperplane_constant <- ineqmat[row, ineq_dim+1] * edo

  denom_prod <- as.numeric(direction %*% normal_vec)
  numerator_prod <- as.numeric(normal_vec %*% point)
  numerator_difference <- numerator_prod + hyperplane_constant

  if (abs(denom_prod) < tiny) {
    if (abs(numerator_difference) < tiny) {
      warning("The given line lies directly on the given hyperplane.")
      result_set <- set 
      result_dist <- 0
      result_sign <- 0
    } else {
      warning("The given line and hyperplane do not intersect.")
      result_set <- rep(NA, card)
      result_dist <- Inf
      result_sign <- NA
    }
  } else {
    line_parameter <- -1 * numerator_difference / denom_prod
    result_set <- point + (rep(line_parameter, card) * direction)
    result_dist <- dist_func(result_set-set, method=method)
    result_sign <- sign(round(line_parameter, digits=rounder))
  }

  res <- list(set=result_set, 
              dist=result_dist,
              sign=result_sign)
  res
}
