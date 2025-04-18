% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/signvector.R
\name{signvector}
\alias{signvector}
\title{Detect a scale's location relative to a hyperplane arrangement}
\usage{
signvector(set, ineqmat = NULL, edo = 12, rounder = 10)
}
\arguments{
\item{set}{Numeric vector of pitch-classes in the set}

\item{ineqmat}{Defaults to \code{NULL}, in which case the function assumes
you want to use the standard hyperplane arrangement of MCT. But you can
enter a different matrix that contains normal vectors for any hyperplane
arrangement in the same format as the standard ineqmats.}

\item{edo}{Number of unit steps in an octave. Defaults to \code{12}.}

\item{rounder}{Numeric (expected integer) representing tolerance:
number of decimal places to round to.}
}
\value{
A vector whose entries are \code{0}, \code{-1}, or \code{1}. Length of vector equals the
number of hyperplanes in \code{ineqmat}.
}
\description{
As "Modal Color Theory" describes (pp. 25-26), each distinct scalar "color" is determined
by its relationships to the hyperplanes that define the space. For any scale, this
function calculates a sign vector that compares the scale to each hyperplane and returns
a vector summarizing the results. If the scale lies on hyperplane 1, then the first
entry of its sign vector is \code{0}. If it lies below hyperplane 2, then the second entry
of its sign vector is \code{-1}. If it lies above hyperplane 3, then the third entry of its
sign vector is \code{1}. Two scales with identical sign vectors belong to the same "color".
}
\examples{
# 037 and 016 have identical sign vectors because they belong to the same trichordal color
signvector(c(0,3,7))
signvector(c(0,1,6))

# Just and equal-tempered diatonic scales have different sign vectors because they have 
# different internal structures (e.g. 12edo dia is generated but just dia is not). 
dia_12edo <- c(0, 2, 4, 5, 7, 9, 11)
just_dia <- 12 * log2(c(1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8))
isTRUE( all.equal( signvector(dia_12edo), signvector(just_dia) ) )

}
