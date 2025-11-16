#' All intervals from one set to another
#'
#' David Lewin's interval function (IFUNC) calculates all the intervals
#' from some source set `x` to some goal set `y`. See Lewin, *Generalized 
#' Musical Intervals and Transformations* (New Haven, CT: Yale University Press,
#' 1987), 88. Lewin's definition of the IFUNC depends on the GIS it applies to,
#' but this package's `ifunc()` is less flexible. It uses only ordered pitch-class
#' intervals as the group of IVLS to be measured. Its intervals can, however,
#' be any continuous value and are not restricted to integers mod `edo`. The
#' format of the result depends on whether non-integer intervals occur.
#'
#' @inheritParams tnprime
#' @param x The source set from which the intervals originate
#' @param y The goal set to which the intervals lead. Defaults to `NULL`, in
#'   which case `ifunc()` gives the intervals from `x` to itself.
#' @param display_digits Integer: how many digits to display when naming any
#'   non-integral interval sizes. Defaults to 2.
#' @param show_zeroes Boolean: if `x` and `y` belong to a single mod `edo`
#'   universe, should `0` values be listed for any intervals mod `edo` which
#'   do not occur in their IFUNC? Defaults to `TRUE`.
#'
#' @returns Numeric vector counting the number of occurrences of each interval.
#'   The [names()] of the result indicate which interval size is counted by
#'   each entry. If `x` and `y` both belong to a single mod `edo` universe (and
#'   `show_zeroes=TRUE`), the result is a vector of length `edo` and includes
#'   explicit `0` results for missing intervals. If `x` and `y` must be measured
#'   in continuous pitch-class space, no missing intervals are identified
#'   (since there would be infinitely many to list).
#'
#' @examples
#' ifunc(c(0, 3, 7))
#' ifunc(c(0, 3, 7), c(0, 4, 7))
#' ifunc(c(0, 4, 7), c(0, 3, 7))
#'
#' ifunc(c(0, 2, 4, 7, 9), show_zeroes=FALSE)
#'
#' just_dia <- j(dia)
#' ifunc(just_dia)
#' ifunc(just_dia, display_digits=4)
#'
#' # See Lewin, GMIT p. 89:
#' lewin_x <- c(4, 10)
#' lewin_y1 <- c(9, 1, 5)
#' lewin_y2 <- c(7, 11, 9)
#' isTRUE(all.equal(ifunc(lewin_x, lewin_y1), ifunc(lewin_x, lewin_y2)))
#' apply(cbind(lewin_y1, lewin_y2), 2, fortenum)
#'
#' @export
ifunc <- function(x, 
                  y=NULL, 
                  edo=12, 
                  rounder=10, 
                  display_digits=2, 
                  show_zeroes=TRUE) {
  if (is.null(y)) y <- x

  intervals <- as.numeric(fpmod(outer(y, x, "-"), edo=edo, rounder=rounder))

  all_integers <- isTRUE(all.equal(intervals, round(intervals, 0)))

  if (all_integers && show_zeroes) {
    res_as_table <- table(factor(intervals, levels=0:(edo-1)))
  } else {
    res_as_table <- table(factor(round(intervals, rounder)))

    name_shortener <- function(string, n) {
      sub(paste0("(\\.\\d{", n, "})\\d+"), 
          "\\1", 
          string)
    }
    names(res_as_table) <- sapply(names(res_as_table), 
                                  name_shortener, 
                                  n=display_digits)
  }

  res <- as.numeric(res_as_table)
  names(res) <- names(res_as_table)

  res    
}

#' How many instances of a subset-type exist within a scale? How many scales embed a subset?
#'
#' David Lewin's EMB and COV functions: see Lewin, *Generalized Musical Intervals and Transformations* 
#' (New Haven, CT: Yale University Press, 1987), 105-120. For EMB, given a group ("CANON") of transformations 
#' which are considered to preserve a set's type, find the number of instances of that type in a larger 
#' set (`scale`). Lewin characterizes this generally, but `emb()` only offers \eqn{T_n} and \eqn{T_n / T_nI}
#' transformation groups as available canonical groups. Conversely, Lewin's COV function asks how
#' many instances of a `scale` type include `subset`: this is implemented as `cover()` (not [cov()]!).
#'
#' @inheritParams tnprime
#' @param subset Numeric vector of pitch-classes in any representative of the subset type
#'   (Lewin's X)
#' @param scale Numeric vector of pitch-classes in the larger set to embed into
#'   (Lewin's Y)
#' @param canon What transformations should be considered equivalent? Defaults to "tni" (using
#'   standard set classes) but can be "tn" (using transposition classes)
#'
#' @returns Integer: count of `subset` or `scale` types satisfying the desired relation.
#'
#' @examples
#' emb(c(0, 4, 7), sc(7, 35))
#' emb(c(0, 4, 7), sc(7, 35), canon="tn")
#'
#' # Works for continuous pc-space too:
#' emb(j(1, 3, 5), j(dia))
#' emb(j(1, 2, 3, 5, 6), j(dia))
#' emb(j(1, 2, 4, 5, 6), j(dia), canon="tn")
#'
#' emb(c(0, 4, 7), c(0, 1, 3, 7))
#' emb(c(0, 4, 7), c(0, 1, 3, 7), canon="tn")
#'
#' emb(c(0, 4), c(0, 4, 8))
#' cover(c(0, 4), c(0, 4, 8))
#'
#' harmonic_minor <- c(0, 2, 3, 5, 7, 8, 11)
#' cover(c(0, 4, 8), harmonic_minor)
#' cover(c(0, 4, 8), harmonic_minor, canon="tn")
#'
#' @export
emb <- function(subset, scale, canon=c("tni", "tn"), edo=12, rounder=10) {
  if (is.null(subset) || is.null(scale)) {
    return(NULL)
  }

  xcard <- length(subset)
  ycard <- length(scale)

  if (xcard == 0) {
    return(0)
  }
  if (xcard == 1) {
    return(ycard)
  }

  canon <- match.arg(canon)
  canon_normal <- function(x, edo, rounder) {
    switch(canon,
           tni = primeform(x, edo=edo, rounder=rounder),
           tn = tnprime(x, edo=edo, rounder=rounder))
  }

  if (xcard >= ycard) {
    if (isTRUE(all.equal(canon_normal(subset, edo=edo, rounder=rounder), 
                         canon_normal(scale, edo=edo, rounder=rounder)))) {
      return(1)
    } else {
      return(0)
    }
  }

  all_subsets <- utils::combn(scale, xcard)
  xnormal <- canon_normal(subset, edo=edo, rounder=rounder)
  normalized_subsets <- apply(all_subsets, 2, canon_normal, edo=edo, rounder=rounder)
  match_x <- function(set) length(fpunique(cbind(set, xnormal), MARGIN=2)) == xcard
  matches_count <- apply(normalized_subsets, 2, match_x)
  sum(matches_count)
}

#' @rdname emb
#' @export
cover <- function(subset, scale, canon=c("tni", "tn"), edo=12, rounder=10) {
  canon <- match.arg(canon)
  embedding_count <- emb(subset, scale, canon=canon, edo=edo, rounder=rounder)

  t_ratio <- tsym_degree(subset, edo, rounder) / tsym_degree(scale, edo, rounder)

  i_ratio <- 1
  if (canon == "tni") {
    if (isym(scale, edo=edo, rounder=rounder) == FALSE) {
      i_ratio <- i_ratio + isym(subset, edo=edo, rounder=rounder)
    } else {
      if (isym(subset, edo=edo, rounder=rounder)==FALSE) {
        i_ratio <- 1/2
      }
    }
  }

  embedding_count * t_ratio * i_ratio
}

