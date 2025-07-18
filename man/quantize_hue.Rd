% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/quantize_color.R
\name{quantize_hue}
\alias{quantize_hue}
\title{Find a scale mod k that matches a given hue}
\usage{
quantize_hue(
  set,
  nmax = 12,
  reconvert = FALSE,
  target_edo = NULL,
  edo = 12,
  rounder = 10
)
}
\arguments{
\item{set}{Numeric vector of pitch-classes in the set}

\item{nmax}{Integer, essentially a limit to how far the function should search before giving up.
Although every real color should have a rational representation in some mod k universe, for some colors
that k must be very high. Increasing nmax makes the function run longer but might be necessary
if small chromatic universes don't produce a result. Defaults to \code{12}.}

\item{reconvert}{Boolean. Should the scale be converted to the input edo? Defaults to \code{FALSE}.}

\item{target_edo}{Numeric (expected integer) determining a specific equal division of the octave to
quantize to. Defaults to \code{NULL}, in which any potential \code{edo} will be accepted.}

\item{edo}{Number of unit steps in an octave. Defaults to \code{12}.}

\item{rounder}{Numeric (expected integer), defaults to \code{10}:
number of decimal places to round to when testing for equality.}
}
\value{
If \code{reconvert=FALSE}, a list of two elements: element 1 is \code{set} with a vector of integers
representing the quantized scale; element 2 is \code{edo} representing the number k of unit steps in the
mod k universe. If \code{reconvert=TRUE}, returns a single numeric vector measured relative
to the unit step size input as \code{edo}: these generally will not be integers. Values may be NA if no
suitable quantization was found beneath the limit given by nmax or in target_edo (if specified).
}
\description{
Given any scale, attempts to find a scale defined as integers mod k
which belongs to the same hue as the input (i.e. would return \code{TRUE}
when \code{\link[=same_hue]{same_hue()}} is applied). This function thus is similar in spirit to
\code{\link[=quantize_color]{quantize_color()}} but seeks a more precise structural match between
input and quantization. Note, though, that while \code{\link[=quantize_color]{quantize_color()}} should always
be able to find a suitable quantization (if \code{nmax} is set high enough),
this is not necessarily true for \code{quantize_hue()}. There are lines in
\eqn{\mathbb{R}^n} which pass through no rational points but the origin, so some hues
(including ones of musical interest like the 5-limit just diatonic scale)
may not have any quantization.
}
\examples{
meantone_diatonic <- sort(((0:6)*meantone_fifth())\%\%12)
quantize_hue(meantone_diatonic) # Succeeds
quantize_hue(j(dia), nmax=15) # Fails no matter how high you set nmax.

quasi_guido <- convert(c(0, 2, 4, 5, 7, 9), 13, 12)
quantize_color(quasi_guido)
quantize_hue(quasi_guido)

quantize_hue(c(0, 1, 4, 6))
quantize_hue(c(0, 1, 4, 6), target_edo=16)

}
