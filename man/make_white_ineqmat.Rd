% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_white_ineqmat.R
\name{make_white_ineqmat}
\alias{make_white_ineqmat}
\alias{make_pastel_ineqmat}
\title{Define hyperplanes for white arrangements}
\usage{
make_white_ineqmat(card)

make_pastel_ineqmat(card)
}
\arguments{
\item{card}{The cardinality of the scale(s) to be studied}
}
\value{
A matrix with \code{card+1} columns and k rows, where k is the nth triangular number
}
\description{
Although the hyperplane arrangements of Modal Color Theory determine most
scalar properties, there are some potentially interesting questions which
require different arrangements. This function makes "white" arrangements
which consider how many of a scale's intervals correspond exactly to the
"white" or perfectly even color for their generic size. That is, for an
interval \code{x} belonging to generic size \code{g} in an \code{n} note scale, does
\eqn{x = g \cdot \frac{edo}{n}}? This may be relevant, for instance, because
two modes have identical sum brightnesses when the interval that separates
their tonics is "white" in this way. Mostly you will want to use these
matrices as inputs to functions with an \code{ineqmat} parameter.

In many cases, it is desirable to use a combination of the MCT \code{ineqmat} from
\code{\link[=makeineqmat]{makeineqmat()}} and the quasi-white \code{ineqmat} from \code{make_white_ineqmat()}. Generally
these are distinct, but they do have some shared hyperplanes in even cardinalities
related to formal tritones (intervals that divide the scale exactly in half).
Therefore, the function \code{make_pastel_ineqmat()} exists to give the result of combining
them with duplicates removed. (The moniker "pastel" is
meant to suggest combining the colors of MCT arrangements with a white pigment
from white arrangements.)

Just as the MCT arrangements are concretized by the files "representative_scales"
and "representative_signvectors," the white and pastel arrangements are represented
by \href{https://github.com/satbq/modalcolortheory/blob/main/offwhite_scales.rds}{offwhite_scales},
\href{https://github.com/satbq/modalcolortheory/blob/main/offwhite_signvectors.rds}{offwhite_signvectors},
\href{https://github.com/satbq/modalcolortheory/blob/main/pastel_scales.rds}{pastel_scales}, and
\href{https://github.com/satbq/modalcolortheory/blob/main/pastel_signvectors.rds}{pastel_signvectors}.
This data has not been as thoroughly vetted as the files for the MCT arrangements, and currently
white and pastel arrangements are only represented up through cardinality 6.
The files are hosted at the \href{https://github.com/satbq/modalcolortheory}{modalcolortheory repo}
like representative_scales because they are too large to include in musicMCT.
}
\examples{
major_triad <- c(0, 4, 7)
howfree(major_triad)
howfree(major_triad, ineqmat=make_white_ineqmat(3))
# Because it's now constrained to preserve its step of exactly 1/3 the octave.

just_major_triad <- j(1, 3, 5)
howfree(just_major_triad)
howfree(just_major_triad, ineqmat=make_white_ineqmat(3))
# Because this triad's major third isn't identical to 400 cents which equally
# divide the octave.

ait1 <- c(0, 1, 4, 6)
quantize_color(ait1, reconvert=TRUE)
# quantize_color() doesn't match (0146) exactly because it's only looking for
# any set in the same 3-dimensional color as 0146.

quantize_color(ait1, ineqmat=make_white_ineqmat(4), reconvert=TRUE)
# Now that it's constrained to respect ait1's minor third from 1 to 4, the set 0146
# is now the first satisfactory result that quantize_color() finds.

}
