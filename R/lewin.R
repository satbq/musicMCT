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
#' just_dia <- 12 * log2(c(1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8))
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

  intervals <- as.numeric(outer(y, x, "-") %% edo)

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