% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/saturate.R
\name{same_hue}
\alias{same_hue}
\title{Do two scales lie on the same ray?}
\usage{
same_hue(set_1, set_2, edo = 12, rounder = 10)
}
\arguments{
\item{set_1, set_2}{Numeric vectors of pitch-classes in the sets. Must be
of same length.}

\item{edo}{Number of unit steps in an octave. Defaults to \code{12}.}

\item{rounder}{Numeric (expected integer), defaults to \code{10}:
number of decimal places to round to when testing for equality.}
}
\value{
Boolean: are the sets of the same hue? NB: \code{TRUE} for identical
sets (even perfectly even scales); \code{FALSE} for scales which are
related by "involution."
}
\description{
Two scales which lie on the same ray from \code{\link[=edoo]{edoo()}} (the perfectly even
scale) differ only in their saturation and are said to belong to the same
"hue." They are not only members of a large "color" but also a much more
specific structure which preserves properties such as \code{\link[=ratio]{ratio()}} and the
precise shape of \code{\link[=brightnessgraph]{brightnessgraph()}}. \code{same_hue()} tests whether two
scales have this close relationship.
}
\examples{
set39 <- c(0, 5, 9, 10, 14, 16, 21)
set53 <- c(0, 7, 13, 16, 22, 26, 33)
set39 <- convert(set39, 39, 12)
set53 <- convert(set53, 53, 12)
same_hue(set39, set53)
# Since they have the same hue, we can resaturate one to become the other:
relative_evenness <- evenness(set53)/evenness(set39)
set53
saturate(relative_evenness, set39)

# These two hexachords belong to the same quasi-pairwise well formed 
# color (see "Modal Color Theory," p. 37), but not to the same hue: 
guidonian_1 <- c(0, 2, 4, 5, 7, 9)
guidonian_2 <- convert(guidonian_1, 13, 12)
isTRUE(all.equal(signvector(guidonian_1), signvector(guidonian_2)))
same_hue(guidonian_1, guidonian_2)

}
