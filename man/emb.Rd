% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lewin.R
\name{emb}
\alias{emb}
\alias{cover}
\title{How many instances of a subset-type exist within a scale? How many scales embed a subset?}
\usage{
emb(subset, scale, canon = c("tni", "tn"), edo = 12, rounder = 10)

cover(subset, scale, canon = c("tni", "tn"), edo = 12, rounder = 10)
}
\arguments{
\item{subset}{Numeric vector of pitch-classes in any representative of the subset type
(Lewin's X)}

\item{scale}{Numeric vector of pitch-classes in the larger set to embed into
(Lewin's Y)}

\item{canon}{What transformations should be considered equivalent? Defaults to "tni" (using
standard set classes) but can be "tn" (using transposition classes)}

\item{edo}{Number of unit steps in an octave. Defaults to \code{12}.}

\item{rounder}{Numeric (expected integer), defaults to \code{10}:
number of decimal places to round to when testing for equality.}
}
\value{
Integer: count of \code{subset} or \code{scale} types satisfying the desired relation.
}
\description{
David Lewin's EMB and COV functions: see Lewin, \emph{Generalized Musical Intervals and Transformations}
(New Haven, CT: Yale University Press, 1987), 105-120. For EMB, given a group ("CANON") of transformations
which are considered to preserve a set's type, find the number of instances of that type in a larger
set (\code{scale}). Lewin characterizes this generally, but \code{emb()} only offers \eqn{T_n} and \eqn{T_n / T_nI}
transformation groups as available canonical groups. Conversely, Lewin's COV function asks how
many instances of a \code{scale} type include \code{subset}: this is implemented as \code{cover()} (not \code{\link[=cov]{cov()}}!).
}
\examples{
emb(c(0, 4, 7), sc(7, 35))
emb(c(0, 4, 7), sc(7, 35), canon="tn")

# Works for continuous pc-space too:
emb(j(1, 3, 5), j(dia))
emb(j(1, 2, 3, 5, 6), j(dia))
emb(j(1, 2, 4, 5, 6), j(dia), canon="tn")

emb(c(0, 4, 7), c(0, 1, 3, 7))
emb(c(0, 4, 7), c(0, 1, 3, 7), canon="tn")

emb(c(0, 4), c(0, 4, 8))
cover(c(0, 4), c(0, 4, 8))

harmonic_minor <- c(0, 2, 3, 5, 7, 8, 11)
cover(c(0, 4, 8), harmonic_minor)
cover(c(0, 4, 8), harmonic_minor, canon="tn")

}
