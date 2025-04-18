% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/set_theory.R
\name{isym}
\alias{isym}
\title{Test for inversional symmetry}
\usage{
isym(set, edo = 12, rounder = 10)
}
\arguments{
\item{set}{Numeric vector of pitch-classes in the set}

\item{edo}{Number of unit steps in an octave. Defaults to \code{12}.}

\item{rounder}{Numeric (expected integer) representing tolerance:
number of decimal places to round to.}
}
\value{
\code{TRUE} if the set is inversionally symmetrical, \code{FALSE} otherwise
}
\description{
Is the pc-set \strong{i}nversionally \strong{sym}metrical? That is, does it map onto itself
under \eqn{T_n I} for some appropriate \eqn{n}? This is evaluated by asking
whether, for some appropriate rotations, the step-interval series of the
given set is equal to the step-interval series of the set's inversion.
This is designed to work for sets in continuous pc-space, not just
integers mod k. As usual for working with real values, this depends
on your rounding tolerance (\code{rounder}).
}
\details{
Note that this calculates abstract pitch-class symmetry, not potential
symmetry in pitch space. (See the second example.)
}
\examples{
#### Mod 12
isym(c(0, 1, 5, 8))
isym(c(0, 2, 4, 8))

#### Continuous Values
qcm_fifth <- meantone_fifth()
qcm_dia <- sort(((0:6)*qcm_fifth)\%\%12)
just_dia <- 12 * log2(c(1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8))
isym(qcm_dia)
isym(just_dia)

#### Rounding matters:
isym(qcm_dia, rounder=15)
}
