% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sim.R
\name{sim}
\alias{sim}
\title{Scalar (and interscalar) interval matrix}
\usage{
sim(set, goal = NULL, edo = 12, rounder = 10)
}
\arguments{
\item{set}{Numeric vector of pitch-classes in the set}

\item{goal}{Numeric vector of same length as set. Defaults to \code{NULL}.}

\item{edo}{Number of unit steps in an octave. Defaults to \code{12}.}

\item{rounder}{Numeric (expected integer), defaults to \code{10}:
number of decimal places to round to when testing for equality.}
}
\value{
Numeric \code{n} by \code{n} matrix where \code{n} is the number of notes in \code{set}
}
\description{
As defined by Tymoczko 2008 ("Scale Theory, Serial Theory and Voice Leading")
\url{https://onlinelibrary.wiley.com/doi/10.1111/j.1468-2249.2008.00257.x},
the \strong{s}calar \strong{i}nterval \strong{m}atrix represents the "rotations" of a set,
transposed to begin on 0, in its columns. Its nth row represents the
specific intervals which represent its generic interval of size n. If changed
from its default (\code{NULL}), the parameter \code{goal} calculates Tymoczko's
\emph{interscalar} interval matrix from \code{set} to \code{goal}.
}
\examples{
diatonic_modes <- sim(c(0, 2, 4, 5, 7, 9, 11))
print(diatonic_modes)

miyakobushi_modes <- sim(c(0, 1, 5, 7, 8)) # rows show trivalence
print(miyakobushi_modes)

# Interscalar Interval Matrix:
sim(c(0, 3, 6, 10), c(0, 4, 7, 10))

# Note that the interscalar matrices factor out transposition:
minor <- c(0, 3, 7)
major <- c(0, 4, 7)
sim(minor, major)
sim(minor-1, major)
sim(minor, major+2)

# But not permutation:
major_64 <- c(0, 5, 9)
major_open <- c(0, 7, 4)
sim(minor, major_64)
sim(minor, major_open)

}
