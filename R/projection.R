#' Generate one point on arbitrary combination of hyperplanes
#'
#' Given a hyperplane arrangement (specified by `ineqmat`) and a subset
#' of those hyperplanes (specified numerically as the `rows` of `ineqmat`),
#' determine some point that lies on the intersection of those hyperplanes.
#' If the chosen hyperplanes do not all intersect in at least one point,
#' returns `NA`s and throws a warning. This function exists mostly for the
#' sake of calculations about a hyperplane arrangement itself, not for
#' musical applications: its results are often not very scale-like (e.g.,
#' they often fail [optc_test()]).
#'
#' @param rows Integer vector: which rows of `ineqmat` should be taken
#'   as hyperplanes defining the target flat?
#' @inheritParams set_from_signvector
#'
#' @returns Numeric vector of length `card` which lies on the specified
#'   hyperplanes. If the intersection of the hyperplanes is empty, 
#'   throws a warning and returns a vector of `NA`s with length `card`.
#'
#' @examples
#' # Works essentially like an inverse of whichsvzeroes():
#' test_set <- sc(5, 32)
#' whichsvzeroes(test_set)
#' generated_point <- point_on_flat(c(5, 8, 10), card=5)
#' whichsvzeroes(generated_point)
#'
#' # But note that the given point might lie on any face of the flat:
#' signvector(test_set)
#' signvector(generated_point)
#'
#' # Works for other hyperplane arrangements:
#' point_on_flat(c(2, 3, 6), card=3, ineqmat="roth")
#' point_on_flat(c(2, 4), card=4, ineqmat="black")
#'
#' # Not all combinations of hyperplanes admit a solution:
#' try(point_on_flat(c(1, 2, 3), card=3, ineqmat="roth"))
#'
#' @seealso [match_flat()] and [populate_flat()] are intended for more 
#'   concretely musical applications, returning a set on the chosen flat
#'   which is similar to an input set.
#' @export
point_on_flat <- function(rows, card, ineqmat=NULL, edo=12, rounder=10) {
  num_rows <- length(rows)
  if (num_rows==0) {
    return(stats::runif(card, 0, edo))
  }
  single_row <- num_rows == 1

  ineqmat <- choose_ineqmat(edoo(card, edo=edo), ineqmat)
  chosen_matrix <- ineqmat[rows, ]
  if (single_row) chosen_matrix <- matrix(chosen_matrix, nrow=1)

  flat_matrix <- chosen_matrix[, 1:card]
  if (single_row) flat_matrix <- matrix(flat_matrix, nrow=1)

  const_matrix <- edo * chosen_matrix[, card+1]

  if (single_row) {
    ech <- cbind(flat_matrix, const_matrix)
    first_nonzero <- which(abs(ech) > 10^(-1*rounder))[1]
    ech <- ech/ech[first_nonzero]
  } else {
    ech <- pracma::rref(cbind(flat_matrix, const_matrix))
  }

  cur_rank <- qr(ech)$rank
  num_free_vars <- card-cur_rank

  if (num_free_vars > 0) {
    fixed_var_index <- pivot_columns(ech, rounder=rounder)
    free_var_index <- setdiff(1:card, fixed_var_index)
  } else {
    free_var_index <- integer(0)
    fixed_var_index <- 1:card
  }

  if (num_free_vars > 1) {
    free_vars <- stats::runif(num_free_vars, 0, 1)
    new_consts <- ech[, free_var_index] %*% free_vars
    new_consts <- (-1 * ech[, card+1]) - new_consts
  } else {
    free_vars <- rep(0, num_free_vars)
    new_consts <- -1 * ech[, card+1]
  }
  new_consts <- new_consts[1:cur_rank]

  inverse_mat <- tryCatch(
    solve(ech[1:cur_rank, fixed_var_index[1:cur_rank]]),
    error = function(e) {
      warning("Intersection of specified hyperplanes is empty.", call.=FALSE)
      return("No solution")
    }
  )

  res <- rep(NA, card)
  if (!inherits(inverse_mat, "matrix") && inverse_mat == "No solution") {
    return(res)
  }

  fixed_vars <- inverse_mat %*% new_consts

  res[fixed_var_index] <- fixed_vars
  res[free_var_index] <- free_vars
  res
}

#' Closest point on a given flat
#'
#' Projects a scale onto the nearest point that lies on a target flat
#' of the hyperplane arrangement. `project_onto()` determines the target  
#' flat from a list of linearly independent rows in `ineqmat` which define 
#' the flat. `match_flat()` determines the target by extrapolating from a 
#' given scale on that flat. Note that while the projection lies on
#' the desired flat (i.e. it will have all of the necessary `0`s in its
#' sign vector), it will not necessarily belong to any particular *color*.
#' (That is, projection doesn't give you control over the `1`s and `-1`s of
#' the sign vector.)
#'
#' @inheritParams tnprime
#' @inheritParams signvector
#' @param target_rows An integer vector: each integer specifies a row
#'   of `ineqmat` which helps to determine the target flat. The
#'   rows must be linearly independent.
#' @param start_zero Boolean: should the result be transposed so that its pitch
#'   initial is zero? Defaults to `TRUE`.
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
project_onto <- function(set, 
                         target_rows, 
                         ineqmat=NULL, 
                         start_zero=TRUE,
                         edo=12, 
                         rounder=10) {
    if (length(target_rows) == 0) {
        return(set)
    }
    card <- length(set)
    ineqmat <- choose_ineqmat(set, ineqmat)

    offset_vector <- point_on_flat(rows=target_rows, 
                                   card=card, 
                                   ineqmat=ineqmat, 
                                   edo=edo, 
                                   rounder=rounder)
    if (is.na(sum(offset_vector))) {
      return(offset_vector)
    }

    displaced_set <- set - offset_vector

    A <- t(ineqmat[target_rows, 1:card])
    if (dim(A)[1] == 1) 
        A <- t(A)
    projection_matrix <- solve(t(A) %*% A)
    projection_matrix <- A %*% projection_matrix %*% t(A)
    n <- dim(projection_matrix)[1]
    projection_matrix <- diag(n) - projection_matrix
    res <- projection_matrix %*% displaced_set
    res <- as.vector(res + offset_vector)

    if (start_zero) res <- startzero(res, edo = edo, optic="")
    res
}

#' Find a basis for a flat's orthogonal complement
#'
#' Many flats in the MCT spaces are intersections of more hyperplanes
#' than you'd expect in a general arrangement. When projecting onto such
#' a flat using `project_onto()`, we need to define it using a linearly
#' independent spanning set for the flat's orthogonal complement--not *all* the
#' vectors that we could use. Unfortunately not just any collection of
#' normals with the right size will do. So this function goes systematically
#' through all correct-size subsets of the flat's normals until it finds 
#' the first one that has the right rank.
#'
#' @param zeroes Integer vector identifying all the "zeroes" in a sign
#'   vector that lies on the flat (i.e. all the normal vectors to the flat)
#'   by which row they are in `ineqmat`.
#' @param ineqmat The matrix of normal vectors defining the hyperplane
#'   arrangement you're working in.
#'
#' @returns A subset of `zeroes` which is a basis for the flat defined
#'   by all the vectors in `zeroes`.
#' @noRd
independent_normals <- function(zeroes, ineqmat) {
  if (length(zeroes)==0) { 
    return(integer(0))
  }

  if (length(zeroes)==1) {
    return(zeroes)
  }

  getrank <- function(vec, ineqmat) qr(ineqmat[vec,])$rank
  goal_rank <- getrank(zeroes, ineqmat)
  if (goal_rank == 2) {
    return(zeroes[1:2])
  }

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
match_flat <- function(set, 
                       target_scale, 
                       start_zero=TRUE,
                       ineqmat=NULL, 
                       edo=12, 
                       rounder=10) {
  card <- length(set)
  ineqmat <- choose_ineqmat(set, ineqmat)
  
  if (length(target_scale) != card) {
    stop("set and target_scale must have the same number of notes!")
  }

  target_zeroes <- whichsvzeroes(target_scale, ineqmat=ineqmat, edo=edo, rounder=rounder)
  independent_zeroes <- independent_normals(target_zeroes, ineqmat)
  project_onto(set, 
               independent_zeroes,
               start_zero=start_zero, 
               ineqmat=ineqmat,  
               edo=edo, 
               rounder=rounder)  
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
#' # Let's plot them using different literal colors to represent the scalar "colors."
#' jdia_flat_svs <- apply(apply(jdia_flat_scales, 2, signvector), 2, toString)
#' unique_svs <- sort(unique(jdia_flat_svs))
#' match_sv <- function(sv) which(unique_svs == sv)
#' sv_colors <- grDevices::hcl.colors(length(unique_svs), 
#'                                    palette="Green-Orange")[sapply(jdia_flat_svs, match_sv)]
#' plot(jdia_flat_scales[2,], jdia_flat_scales[3,], pch=20, col=sv_colors,
#'   xlab = "Height of scale degree 2", ylab = "Height of scale degree 3",
#'   asp=1)
#' abline(0, 2, lty="dashed", lwd=2)
#' points(j(2), j(3), cex=2, pch="x")
#' points(2, 4, cex=2, pch="o")
#'
#' # Most of our sampled sets belong to two colors separated by the dashed
#' # line on the plot. The dashed line represents the inequality that determines 
#' # the size of a scale's second step in relation to its first step. This is
#' # hyperplane #1 in the space, so it corresponds to the first entry in each 
#' # scale's sign vector. The point labeled "x" represents the just diatonic scale 
#' # itself, which has a larger first step than second step. The point labeled 
#' # "o" represents the 12-equal diatonic, whose whole steps are all equal and which 
#' # therefore lies directly on hyperplane #1. Finally, note that our sampled scales
#' # also touch on a few other colors at the bottom & left fringes of the scatter plot.
#'
#' @export
populate_flat <- function(set, 
                          target_scale=NULL, 
                          target_rows=NULL,
                          start_zero=TRUE, 
                          ineqmat=NULL,
                          edo=12, 
                          rounder=10, 
                          magnitude=2,
                          distance=1) {
  card <- length(set)
  ineqmat <- choose_ineqmat(set, ineqmat)
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
      project_onto(set, 
                   target_rows, 
                   start_zero=start_zero,
                   ineqmat=ineqmat, 
                   edo=edo, 
                   rounder=rounder)
    } 
  } else {
    projection_func <- function(set) {
      match_flat(set, 
                 target_scale, 
                 start_zero=start_zero,
                 ineqmat=ineqmat, 
                 edo=edo, 
                 rounder=rounder)
    }
  }

  if (vary_distance) {
    sampled_sets <- sapply(dists, surround_set, set=set, magnitude=log10(1/card))
  } else {
    sampled_sets <- surround_set(set, magnitude=magnitude, distance=distance)
  }
  apply(sampled_sets, 2, projection_func)
}
