% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lewin.R
\name{ifunc}
\alias{ifunc}
\title{All intervals from one set to another}
\usage{
ifunc(
  x,
  y = NULL,
  edo = 12,
  rounder = 10,
  display_digits = 2,
  show_zeroes = TRUE
)
}
\arguments{
\item{x}{The source set from which the intervals originate}

\item{y}{The goal set to which the intervals lead. Defaults to \code{NULL}, in
which case \code{ifunc()} gives the intervals from \code{x} to itself.}

\item{edo}{Number of unit steps in an octave. Defaults to \code{12}.}

\item{rounder}{Numeric (expected integer), defaults to \code{10}:
number of decimal places to round to when testing for equality.}

\item{display_digits}{Integer: how many digits to display when naming any
non-integral interval sizes. Defaults to 2.}

\item{show_zeroes}{Boolean: if \code{x} and \code{y} belong to a single mod \code{edo}
universe, should \code{0} values be listed for any intervals mod \code{edo} which
do not occur in their IFUNC? Defaults to \code{TRUE}.}
}
\value{
Numeric vector counting the number of occurrences of each interval.
The \code{\link[=names]{names()}} of the result indicate which interval size is counted by
each entry. If \code{x} and \code{y} both belong to a single mod \code{edo} universe (and
\code{show_zeroes=TRUE}), the result is a vector of length \code{edo} and includes
explicit \code{0} results for missing intervals. If \code{x} and \code{y} must be measured
in continuous pitch-class space, no missing intervals are identified
(since there would be infinitely many to list).
}
\description{
David Lewin's interval function (IFUNC) calculates all the intervals
from some source set \code{x} to some goal set \code{y}. See Lewin, \emph{Generalized
Musical Intervals and Transformations} (New Haven, CT: Yale University Press,
1987), 88. Lewin's definition of the IFUNC depends on the GIS it applies to,
but this package's \code{ifunc()} is less flexible. It uses only ordered pitch-class
intervals as the group of IVLS to be measured. Its intervals can, however,
be any continuous value and are not restricted to integers mod \code{edo}. The
format of the result depends on whether non-integer intervals occur.
}
\examples{
ifunc(c(0, 3, 7))
ifunc(c(0, 3, 7), c(0, 4, 7))
ifunc(c(0, 4, 7), c(0, 3, 7))

ifunc(c(0, 2, 4, 7, 9), show_zeroes=FALSE)

just_dia <- j(dia)
ifunc(just_dia)
ifunc(just_dia, display_digits=4)

# See Lewin, GMIT p. 89:
lewin_x <- c(4, 10)
lewin_y1 <- c(9, 1, 5)
lewin_y2 <- c(7, 11, 9)
isTRUE(all.equal(ifunc(lewin_x, lewin_y1), ifunc(lewin_x, lewin_y2)))
apply(cbind(lewin_y1, lewin_y2), 2, fortenum)

}
