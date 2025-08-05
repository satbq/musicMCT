#' Evaluate potentially minimal voice-leading options
#'
#' Following Tymoczko 2008 <https://doi.org/10.1111/j.1468-2249.2008.00257.x>,
#' considers the strongly crossing-free voice leadings from `source` to the 
#' modes of `goal`. 
#'
#' @inheritParams minimize_vl
#'
#' @returns A list with 3 entries:
#'   * `$vls`: The "interscalar interval matrix" with intervals as 
#'             signed interval classes.
#'   * `vl_scores`: Measurements of the size of the rows in `$vls` according
#'   *              to the chosen `method`.
#'   * `min_index`: The row(s) containing the smallest voice leading.
#'
#' @noRd
crossingfree_vls <- function(source, 
                             goal, 
                             method=c("taxicab", "euclidean", "chebyshev", "hamming"), 
                             edo=12,
                             rounder=10) {
  method <- match.arg(method)
  tiny <- 10^(-1 * rounder)
  card <- length(source)
  if (card != length(goal)) { 
    stop("Goal and source should have the same cardinality. 
  You might want to double notes in your smaller (multi)set.", call.=FALSE)
  }

  modes <- sapply(0:(card-1), rotate, x=goal, edo=edo)
  voice_leadings <- modes - matrix(source, nrow=card, ncol=card, byrow=TRUE)
  voice_leadings[] <- sapply(voice_leadings, signed_interval_class, edo=edo)

  vl_scores <- apply(voice_leadings, 1, dist_func, method=method, rounder=rounder)
  min_index <- which(vl_scores == min(vl_scores))
  
  list(vls=voice_leadings, vl_scores=vl_scores, min_index=min_index)
}

#' Smallest voice leading between two sets
#'
#' Given a `source` set and a `goal` to move to, find the voice leading from `source` 
#' to `goal` with smallest size. 
#'
#' Unless method="hamming", it is assumed that the minimal voice leading should be
#' strongly crossing-free, so you might get strange results if your `source` and `goal`
#' are not both in ascending order.
#' 
#' @param source Numeric vector, the pitch-class set at the start of your voice leading
#' @param goal Numeric vector, the pitch-class set at the end of your voice leading
#' @param method What distance metric should be used? Defaults to `"taxicab"` 
#'   but can be `"euclidean"`, `"chebyshev"`, or `"hamming"`.
#' @param no_ties If multiple VLs are equally small, should only one be returned? Defaults to `FALSE`, which
#'   is generally what an interactive user should want. 
#' @inheritParams tnprime
#' 
#' @returns Numeric array. In most cases, a vector the same length as `source`;
#'    or a vector of `NA` the same length as `source` if `goal` and
#'   `source` have different lengths. If `no_ties=FALSE` and multiple voice leadings
#'   are equivalent, the array can be a matrix with `m` rows where `m` is the number
#'   of equally small voice leadings.
#' @examples
#' c_major <- c(0, 4, 7)
#' ab_minor <- c(8, 11, 3)
#' minimize_vl(c_major, ab_minor)
#'
#' diatonic_scale <- c(0, 2, 4, 5, 7, 9, 11)
#' minimize_vl(diatonic_scale, tn(diatonic_scale, 7))
#'
#' d_major <- c(2, 6, 9)
#' minimize_vl(c_major, d_major)
#' minimize_vl(c_major, d_major, no_ties=TRUE)
#' minimize_vl(c_major, d_major, method="euclidean", no_ties=FALSE)
#'
#' minimize_vl(c(0, 4, 7, 10), c(7, 7, 11, 2), method="euclidean")
#' minimize_vl(c(0, 4, 7, 10), c(7, 7, 11, 2), method="euclidean", no_ties=TRUE)
#'
#' natural_hexachord <- c(0, 2, 4, 5, 7, 9)
#' hard_hexachord <- c(7, 9, 11, 0, 2, 4)
#' minimize_vl(natural_hexachord, hard_hexachord, method="hamming")
#' @export
minimize_vl<- function(source, 
                       goal, 
                       method=c("taxicab", "euclidean", "chebyshev", "hamming"), 
                       no_ties=FALSE, 
                       edo=12,
                       rounder=10) {
  is_hamming <- match.arg(method) == "hamming"
  if (is_hamming) {
    tiny <- 1 * 10^(-1 * rounder)
    source <- round(source, digits=rounder)
    goal <- round(goal, digits=rounder)
    duplicated_source <- duplicated(source)
    duplicated_goal <- duplicated(goal)
    source_offsets <- stats::runif(sum(duplicated_source), 0, 1)
    goal_offsets <- stats::runif(sum(duplicated_goal), 0, 1)
    source[duplicated_source] <- source[duplicated_source] + tiny * source_offsets
    goal[duplicated_goal] <- goal[duplicated_goal] + tiny * goal_offsets
    
    notes_to_move <- setdiff(source, goal)
    goal_of_motion <- setdiff(goal, source)
    if (length(notes_to_move) != length(goal_of_motion)) {
      stop("Error detecting common tones.")
    }
    res <- rep(0, length(source))
    if (length(notes_to_move) == 0) {
      return(res)
    }
    moving_vl <- minimize_vl(notes_to_move, goal_of_motion, edo=edo, rounder=rounder, no_ties=TRUE)
    res[source %in% notes_to_move] <- round(moving_vl, digits=rounder)
    return(res)     
  }

  vl_data <- crossingfree_vls(source=source, goal=goal, method=method, edo=edo, rounder=rounder)

  index <- vl_data$"min_index"
  if (no_ties) index <- index[1]

  vl_data$"vls"[index,]
}

#' Smallest crossing-free voice leading between two pitch-class sets
#'
#' Given source and goal pitch-class sets, which mode of the goal is closest to the source
#' (assuming crossing-free voice leadings and the given `method` for determining distance).
#'
#' @inheritParams minimize_vl
#' @inheritParams fpunique
#'
#' @returns Numeric value(s) identifying the modes of `goal`. Single value if `no_ties` is `TRUE`,
#'   otherwise n values for an n-way tie.
#'
#' @examples
#' c_53 <- c(0, 4, 7)
#' c_64 <- c(7, 0, 4)
#' d_53 <- c(2, 6, 9)
#' e_53 <- c(4, 8, 11)
#' 
#' whichmodebest(c_53, c_64)
#' whichmodebest(c_64, c_53)
#' whichmodebest(c_53, e_53)
#' whichmodebest(c_53, d_53)
#' whichmodebest(c_53, d_53, method="euclidean")
#'
#' # See "Modal Color Theory," p. 12, note 21
#' pyth_dia_modes <- sim(sort((j(5) * 0:6)%%12))
#' pyth_lydian <- pyth_dia_modes[,1]
#' pyth_locrian <- pyth_dia_modes[,4]
#' whichmodebest(pyth_locrian, pyth_lydian) 
#' @export
whichmodebest <- function(source, 
                          goal, 
                          method=c("taxicab", "euclidean", "chebyshev", "hamming"), 
                          no_ties=FALSE, 
                          edo=12,
                          rounder=10) {
  res <- crossingfree_vls(source=source, goal=goal, method=method, edo=edo, rounder=rounder)$"min_index"
  if (no_ties) {
    return(res[1])
  }
  res
}

#' How far apart are two scales?
#'
#' Using the chosen `method` to measure distance, determines how far 
#' apart two scales are in voice-leading space.
#' 
#' @inheritParams tnprime
#' @inheritParams minimize_vl
#' @inheritParams same_hue
#'
#' @returns Numeric: distance between `set_1` and `set_2`
#'
#' @examples
#' c_major <- c(0, 4, 7)
#' a_minor_63 <- c(0, 4, 9)
#' f_minor_64 <- c(0, 5, 8)
#' vl_dist(c_major, a_minor_63)
#' vl_dist(c_major, f_minor_64)
#' vl_dist(c_major, a_minor_63, method="euclidean")
#' vl_dist(c_major, f_minor_64, method="euclidean")
#' 
#' @export
vl_dist <- function(set_1, 
                    set_2, 
                    method=c("taxicab", "euclidean", "chebyshev", "hamming"),
                    rounder=10) {
  dist_func(set_1 - set_2, method=method, rounder=rounder)
}

#' Create a sequence of transposition indices
#'
#' Internal function serving plotting of [tndists()]
#'
#' @inheritParams tndists
#'
#' @returns Vector: sequence with `1 + edo*subdivide`steps from `0` to `edo`
#' 
#' @noRd
get_tn_levels <- function(edo, subdivide) seq(0, edo, length.out=1 + (edo*subdivide))

#' Calculate the distance from a set to a bunch of transpositions
#'
#' Generates the distance values which are plotted as the y axis of [tndists()]
#'
#' @inheritParams tndists
#'
#' @returns Vector of length `1 + edo*subdivide` with voice-leading distances
#'
#' @noRd 
get_vl_dists <- function(set, 
                         goal=NULL,
                         method=c("taxicab", "euclidean", "chebyshev", "hamming"), 
                         subdivide=100, 
                         edo=12,
                         rounder=10) {
  if (is.null(goal)) goal <- set

  tn_levels <- get_tn_levels(edo=edo, subdivide=subdivide)
  all_transpositions <- sapply(tn_levels, tn, set=goal, edo=edo, sorted=FALSE)
  getdist <- function(source, goal, method, edo) {
    min(crossingfree_vls(source, goal, method, edo, rounder)$vl_scores)
  }
  apply(all_transpositions, 2, getdist, source=set, method=method, edo=edo)
}

#' Distances between continuous transpositions of a set
#'
#' @description
#' One way to think about the voice-leading potential of a set is to consider the minimal voice-leadings
#' by which it can move to transpositions of itself (or another set). For instance, the major triad's 
#' closest transpositions are \eqn{T_4} and \eqn{T_8} while its most distant transposition is \eqn{T_6},
#' and potentially also \eqn{T_{\pm 2}} depending on the distance metric you use. For 
#' the major triad restricted to 12-tone equal temperament, this set of relationships is well
#' modeled by Richard Cohn's discussion of [Douthett & Steinbach's](https://www.jstor.org/stable/843877)
#' "Cube Dance" in *Audacious Euphony* (102-106). The behavior of other sets is not always what you
#' might expect extrapolating from the case of tertian sonorities. For instance, the trichord (027) has
#' different minimal neighbors depending on the metric chosen: its nearest neighbors are \eqn{T_{\pm 4}}
#' under the Euclidean metric but \eqn{T_{\pm 5}} under the taxicab metric.
#'
#' This function allows us to visualize such relationships by plotting the minimal voice leading
#' distance from a set to transpositions of its goal in continuous pc-space. (In spirit, it is like
#' a continuous version of [vl_rolodex()] except that it visualizes a voice-leading distance rather than
#' reporting the specific motions of the set's individual voices.) The main intended use of the function
#' is the plot that it produces, which represents many discrete \eqn{T_n}s of the set (for a sampling of 
#' each `edo` step divided into `subdivide` amounts) on the x axis and voice-leading distance on the y
#' axis. Secondarily, `tndists()` invisibly returns the distance values that it plots, named 
#' according to the \eqn{T_n} they correspond to.
#'
#' @inheritParams tnprime
#' @inheritParams minimize_vl
#' @param goal Numeric vector like set: what is the tn-type of the voice leading's destination?
#'   Defaults to `NULL`, in which case the function uses `set` as the tn-type.
#' @param subdivide Numeric: how many small amounts should each `edo` step be divided into? Defaults to `100`.
#'
#' @returns Numeric vector of length `edo * subdivide` representing distances of the transpositions. Names
#'   indicate the transposition index that corresponds to each distance.
#'
#' @examples
#' major_triad <- c(0, 4, 7)
#' taxicab_dists <- tndists(major_triad)
#' euclidean_dists <- tndists(major_triad, method="euclidean")
#' tns_to_display <- c("1.9", "1.92", "1.95", "2", "2.05", "2.08", "2.1")
#' taxicab_dists[tns_to_display]
#' euclidean_dists[tns_to_display]
#' 
#' @export
tndists <- function(set, 
                    goal=NULL,
                    method=c("taxicab", "euclidean", "chebyshev", "hamming"), 
                    subdivide=100, 
                    edo=12,
                    rounder=10) {
  if (is.null(goal)) {
    goal <- set
    title_final <- "to its transpositions"
  } else {
    title_final <- paste("to transpositions of", deparse(substitute(goal)))
  }

  method <- match.arg(method)
  method_title <- paste0(toupper(substr(method, 1, 1)),
                        substr(method, 2, nchar(method)), collapse="")

  tn_levels <- get_tn_levels(edo=edo, subdivide=subdivide)

  all_dists <- get_vl_dists(set=set, 
                            goal=goal, 
                            method=method, 
                            subdivide=subdivide, 
                            edo=edo, 
                            rounder=rounder)

  plot(tn_levels, all_dists, type="l", lwd=4, ljoin=2,
       xlab = paste0("Transposition relative to ", edo, "-equal temperament"), xaxs="i",
       ylab = "Voice-leading distance")
  graphics::mtext(side=3, 
        paste(method_title, "distances from", 
              deparse(substitute(set)), title_final),
        font=2, line=1)
  graphics::grid(nx=edo, ny=NA, lty="dashed")
  graphics::grid(nx=NA, ny=NULL, lty="dotted")

  names(all_dists) <- tn_levels
  invisible(all_dists)
}

#' Voice-leading inflection points
#'
#' When considering an n-note set's potential voice leadings to transpositions of a goal (along the lines 
#' of [vl_rolodex()] and [tndists()]), there will always be some transposition in continuous pc-space
#' for which a given modal rotation is the best potential target for voice leading. (That is, there is
#' always some `x` such that `whichmodebest(set, tn(set, x)) == k` for any `k` between `1` and `n`.)
#' Moreover, there will always be a transposition level at the boundary between two different ideal modes,
#' where both modes require the same amount of voice leading work. `flex_points()` identifies those
#' inflection points where one mode gives way to another. (Note: `flex_points()` identifies these points
#' by numerical approximation, so it may not give exact values. For more precision, increase the value
#' of `subdivide`.)
#'
#' @inheritParams tndists
#' @inheritParams tnprime
#'
#' @returns Numeric vector of the transposition indices that are inflection points. Length of result 
#'   matches size of `set`, except in the case of some multisets, which can have fewer inflection points.
#'
#' @examples
#' major_triad_12tet <- c(0, 4, 7)
#' major_triad_just <- z(1, 5/4, 3/2)
#' major_triad_19tet <- c(0, 6, 11)
#'
#' flex_points(major_triad_12tet, method="euclidean", subdivide=1000)
#' flex_points(major_triad_just, method="euclidean", subdivide=1000)
#' 
#' # Note that the units of measurement correspond to edo.
#' # The value 3.16 here corresponds to exactly 1/6 of an octave.
#' flex_points(major_triad_19tet, edo=19)
#'
#' @export
flex_points <- function(set, 
                        goal=NULL,
                        method=c("taxicab", "euclidean", "chebyshev", "hamming"), 
                        subdivide=100, 
                        edo=12, 
                        rounder=10) {
  if (is.null(goal)) goal <- set

  all_dists <- get_vl_dists(set=set, 
                            goal=goal, 
                            method=method, 
                            subdivide=subdivide, 
                            edo=edo, 
                            rounder=rounder)
  second_derivative <- round(diff(all_dists, differences=2), digits=rounder)
  inflection_points <- which(second_derivative < 0)
  duplicated_points <- which(diff(inflection_points)==1) + 1
  if (length(duplicated_points) > 0) {
    inflection_points <- inflection_points[-duplicated_points]
  }
  inflection_points/subdivide
}
  
