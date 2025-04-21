crossingfree_vls <- function(source, 
                             goal, 
                             method=c("taxicab", "euclidean"), 
                             edo=12) {
  card <- length(source)
  if (card != length(goal)) { 
    stop("Goal and source should have the same cardinality. 
  You might want to double notes in your smaller (multi)set.")
    return(rep(NA, card)) 
  }

  modes <- sapply(0:(card-1), rotate, x=goal, edo=edo)
  voice_leadings <- modes - matrix(source, nrow=card, ncol=card, byrow=TRUE)
  voice_leadings[] <- sapply(voice_leadings, signed_interval_class, edo=edo)

  method <- match.arg(method)
  get_vl_scores <- function(vls) {
    switch(method,
           taxicab = colSums(apply(vls, 1, abs)),
           euclidean = sqrt(rowSums(vls^2)))
  }

  vl_scores <- get_vl_scores(voice_leadings)
  min_index <- which(vl_scores == min(vl_scores))
  
  list(vls=voice_leadings, vl_scores=vl_scores, min_index=min_index)
}

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

minimizeVL <- function(source, 
                       goal, 
                       method=c("taxicab", "euclidean"), 
                       no_ties=FALSE, 
                       edo=12) {

  vl_data <- crossingfree_vls(source=source, goal=goal, method=method, edo=edo)

  index <- vl_data$"min_index"
  if (no_ties) index <- index[1]

  vl_data$"vls"[index,]
}

#' Smallest crossing-free voice leading between two pitch-class sets
#'
#' Given source and goal pitch-class sets, which mode of the goal is closest to the source
#' (assuming crossing-free voice leadings and the given `method` for determining distance).
#'
#' @inheritParams minimizeVL
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
                          method=c("taxicab", "euclidean"), 
                          no_ties=FALSE, 
                          edo=12) {
  res <- crossingfree_vls(source=source, goal=goal, method=method, edo=edo)$"min_index"
  if (no_ties) res[1]
  res
}

get_tn_levels <- function(edo, subdivide) seq(0, edo, length.out=1 + (edo*subdivide))
 
get_vl_dists <- function(set, method=c("taxicab", "euclidean"), subdivide=100, edo=12) {
  tn_levels <- get_tn_levels(edo=edo, subdivide=subdivide)
  all_transpositions <- sapply(tn_levels, tn, set=set, edo=edo, sorted=FALSE)
  getdist <- function(source, goal, method, edo) {
    min(crossingfree_vls(source, goal, method, edo)$vl_scores)
  }
  apply(all_transpositions, 2, getdist, source=set, method=method, edo=edo)
}

#' Distances between continuous transpositions of a set
#'
#' @description
#' One way to think about the voice-leading potential of a set is to consider all the ways
#' that it can move to transpositions of itself. For instance, the major triad's closest 
#' transpositions are \eqn{T_4} and \eqn{T_8} while its most distant transposition is \eqn{T_6},
#' and potentially also \eqn{T_{\pm 2}} depending on the distance metric you use. For 
#' the major triad restricted to 12-tone equal temperament, this set of relationships is well
#' modeled by Richard Cohn's discussion of [Douthett & Steinbach's](https://doi.org/10.2307/843877)
#' "Cube Dance" in *Audacious Euphony* (102-106). The behavior of other sets is not always what you
#' might expect based on the model of tertian sonorities. For instance, the trichord (027) has
#' different minimal neighbors depending on the metric chosen: its nearest neighbors are \eqn{T_{\pm 4}}
#' under the Euclidean metric but \eqn{T_{\pm 5}} under the taxicab metric.
#'
#' This function allows us to visualize such relationships by plotting the minimal voice leading
#' distance from a set to all of its transpositions in continuous pc-space. (In spirit, it is like
#' a continuous version of [VL_rolodex()] except that it visualizes a voice-leading distance rather than
#' reporting the specific motions of the set's individual voices.) The main intended use of the function
#' is  
#' 
tndists <- function(set, method=c("taxicab", "euclidean"), subdivide=100, edo=12) {
  method <- match.arg(method)
  method_title <- paste0(toupper(substr(method, 1, 1)),
                        substr(method, 2, nchar(method)), collapse="")

  tn_levels <- get_tn_levels(edo=edo, subdivide=subdivide)

  all_dists <- get_vl_dists(set=set, method=method, subdivide=subdivide, edo=edo)

  plot(tn_levels, all_dists, type="l", lwd=4, ljoin=2,
       xlab = paste0("Transposition relative to ", edo, "-equal temperament"), xaxs="i",
       ylab = "Voice-leading distance")
  mtext(side=3, 
        paste(method_title, "distances from", 
              deparse(substitute(set)), "to its transpositions"),
        font=2, line=1)
  grid(nx=edo, ny=NA, lty="dashed")
  grid(nx=NA, ny=NULL, lty="dotted")

  names(all_dists) <- tn_levels
  invisible(all_dists)
}

tn_inflections <- function(set, method=c("taxicab", "euclidean"), subdivide=100, edo=12, rounder=10) {
  all_dists <- get_vl_dists(set=set, method=method, subdivide=subdivide, edo=edo)
  second_derivative <- round(diff(all_dists, differences=2), digits=rounder)
  inflection_points <- which(second_derivative < 0)
  duplicated_points <- which(diff(inflection_points)==1) + 1
  if (length(duplicated_points) > 0) {
    inflection_points <- inflection_points[-duplicated_points]
  }
  inflection_points/subdivide
}
  
