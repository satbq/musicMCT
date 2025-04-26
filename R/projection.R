#' Closest point on a given flat
#'
#' Projects a scale onto the nearest point that lies on a target flat
#' of the hyperplane arrangment. `project_onto()` determines the target  
#' flat from a list of linearly independent rows in `ineqmat` which define 
#' the flat. `match_flat()` determines the target by extrapolating from a 
#' given scale on that flat. Note that while the projection lies on
#' the desired flat (i.e. it will have all of the necessary `0`s in its
#' sign vector), it will not necessarily belong to any particular *color*
#' (i.e. projection doesn't give you control over the `1`s and `-1`s of
#' the sign vector.
#'
#' @inheritParams tnprime
#' @inheritParams signvector
#' @param target_rows An integer vector: each integer specifies a row
#'   of `ineqmat` which helps to determine the target flat. The
#'   rows must be linearly independent.
#' @param target_scale A numeric vector which represents a scale
#'   on the target flat.
#'
#' @returns A numeric vector of same length as `set`, representing
#'   the projection of `set` onto the flat determined by `target_rows` or 
#'   `target_scale`.
#'
#' @examples
#' minor_triad <- c(0, 3, 7)
#' project_onto(minor_triad, 3)
#' project_onto(minor_triad, 1)
#' project_onto(minor_triad, c(1, 3))
#' # This last projection results in the perfectly even scale
#' # because that's the only scale on both hyperplanes 1 and 3.
#'
#' major_scale <- c(0, 2, 4, 5, 7, 9, 11)
#' projected_just_dia <- match_flat(j(dia), major_scale)
#' print(projected_just_dia)
#' 
#' # This is very close to fifth-comma meantone:
#' fifth_comma_meantone <- sim(sort(((0:6) * meantone_fifth(1/5))%%12))[,5]
#' vl_dist(projected_just_dia, fifth_comma_meantone)
#' @export
project_onto <- function(set, target_rows, ineqmat=NULL, edo=12, rounder=10) {
  if (length(target_rows)==0) {
    return(set)
  }
  card <- length(set)
  if (is.null(ineqmat)) ineqmat <- getineqmat(card)

  central_set <- coord_to_edo(set, edo=edo)[-1]

  A <- t(ineqmat[target_rows, 2:card])
  if (dim(A)[1] == 1) A <- t(A)

  projection_matrix <- solve(t(A) %*% A)
  projection_matrix <- A %*% projection_matrix %*% t(A)
  n <- dim(projection_matrix)[1]
  projection_matrix <- diag(n) - projection_matrix

  res <- projection_matrix %*% central_set
  res <- coord_from_edo(c(0, res), edo=edo)
  as.numeric(res)
}

independent_normals <- function(zeroes, ineqmat) {
  if (length(zeroes)==0) { 
    return(integer(0))
  }

  if (length(zeroes)==1) {
    return(zeroes)
  }

  getrank <- function(vec, ineqmat) qr(ineqmat[vec,])$rank
  goal_rank <- getrank(zeroes, ineqmat)
  attempts <- utils::combn(zeroes[2:length(zeroes)], goal_rank-1)
  num_attempts <- dim(attempts)[2]
  attempts <- rbind(rep(zeroes[1], num_attempts), attempts)

  for (i in 1:num_attempts) {
    if (getrank(attempts[,i], ineqmat) == goal_rank) {
      return(attempts[,i])
    } 
  }
} 

#' @rdname project_onto
#' @export
match_flat <- function(set, target_scale, ineqmat=NULL, edo=12, rounder=10) {
  card <- length(set)
  if (is.null(ineqmat)) ineqmat <- getineqmat(card)
  
  if (length(target_scale) != card) {
    stop("set and target_scale must have the same number of notes!")
  }

  target_zeroes <- whichsvzeroes(target_scale, ineqmat=ineqmat, edo=edo, rounder=rounder)
  independent_zeroes <- independent_normals(target_zeroes, ineqmat)
  project_onto(set, independent_zeroes, ineqmat=ineqmat, edo=12, rounder=rounder)  
}

#' Randomly generate scales on a flat
#'
#' Sometimes it's useful to explore a flat or a color by testing
#' small differences that result from different positions within the
#' flat. This function generates random points on the desired flat
#' to test, similar to [surround_set()] but constrained to lie on
#' a target flat. Requires a base `set` that serves as an "origin"
#' around which the random scales are to be generated (before being
#' projected onto the target flat).
#'
#' The target flat can be specified by naming the `target_rows` that 
#' determine the flat (in the manner of [project_onto()]) or by
#' naming a `target_scale` on the desired flat. Both parameters default
#' to `NULL`, in which case the function populates the flat that `set`
#' itself lies on.
#' 
#' @inheritParams project_onto
#' @inheritParams match_flat
#' @inheritParams surround_set
#'
#' @returns A matrix whose columns represent scales on the desired flat.
#'   The matrix has n rows (where n is the number of notes in `set`) and
#'   `n * 10^magnitude` columns.
#'
#' @examples
#' # Let's sample several scales on the same flat as j(dia):
#' major <- c(0, 2, 4, 5, 7, 9, 11)
#' jdia_flat_scales <- populate_flat(major, j(dia))
#' unique(apply(jdia_flat_scales, 2, whichsvzeroes), MARGIN=2)
#' 
#' # So all the scales do lie on one flat, but they may be different colors.
#' # Let's plot them using different characters to represent the colors.
#' jdia_flat_svs <- apply(apply(jdia_flat_scales, 2, signvector), 2, toString)
#' unique_svs <- sort(unique(jdia_flat_svs))
#' match_sv <- function(sv) which(unique_svs == sv)
#' characters_for_plotting <- sapply(jdia_flat_svs, match_sv) + 9
#' plot(jdia_flat_scales[2,], jdia_flat_scales[3,], pch=letters[characters_for_plotting],
#'   xlab = "Height of scale degree 2", ylab = "Height of scale degree 3")
#'
#' # Mostly we have sampled two colors on this flat, the ones represented by the letters
#' # "k" and "m". But we've also got a few instances of "j" and "l" on the left and bottom
#' # fringes of the plot.
#'
#' @export
populate_flat <- function(set, 
                          target_scale=NULL, 
                          target_rows=NULL, 
                          ineqmat=NULL,
                          edo=12, 
                          rounder=10, 
                          magnitude=2,
                          distance=1) {
  card <- length(set)
  if (is.null(ineqmat)) ineqmat <- getineqmat(card)
  vary_distance <- FALSE
  if (is.null(target_scale) && is.null(target_rows)) {
    target_scale <- set
    vary_distance <- TRUE
    dists <- stats::runif(card * 10^magnitude, 
                          0, 
                          vl_dist(set, edoo(card), method="euclidean"))
  }
  if (is.null(target_scale)) {
    projection_func <- function(set) {
      project_onto(set, target_rows, ineqmat=ineqmat, edo=edo, rounder=rounder)
    } 
  } else {
    projection_func <- function(set) {
      match_flat(set, target_scale, ineqmat=ineqmat, edo=edo, rounder=rounder)
    }
  }

  if (vary_distance) {
    sampled_sets <- sapply(dists, surround_set, set=set, magnitude=log10(1/card))
  } else {
    sampled_sets <- surround_set(set, magnitude=magnitude, distance=distance)
  }
  apply(sampled_sets, 2, projection_func)
}