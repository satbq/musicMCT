% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scala.R
\name{writeSCL}
\alias{writeSCL}
\title{Create a Scala tuning file from a given scale}
\usage{
writeSCL(x, path, filename, period = 2, ineqmat = NULL, edo = 12, rounder = 10)
}
\arguments{
\item{x}{Numeric vector: the scale to export}

\item{path}{String specifying path where Scala file should be saved. No default and cannot be missing.}

\item{filename}{String (in quotation marks): what to name your Scala file. Defaults to using
the name of \code{x} as the file name if you enter nothing.}

\item{period}{The frequency ratio at which your scale repeats; defaults to \code{2} which
indicates an octave-repeating scale.}

\item{ineqmat}{Specifies which hyperplane arrangement to consider. By default (or by
explicitly entering "mct") it supplies the standard "Modal Color Theory" arrangements
of \code{\link[=getineqmat]{getineqmat()}}, but can be set to "white," "black", "gray", "roth", "pastel," or "rosy",
giving the \code{ineqmat}s of \code{\link[=make_white_ineqmat]{make_white_ineqmat()}}, \code{\link[=make_black_ineqmat]{make_black_ineqmat()}}, \code{\link[=make_gray_ineqmat]{make_gray_ineqmat()}},
\code{\link[=make_roth_ineqmat]{make_roth_ineqmat()}}, \code{\link[=make_pastel_ineqmat]{make_pastel_ineqmat()}}, and \code{\link[=make_rosy_ineqmat]{make_rosy_ineqmat()}}. For other
arrangements, the desired inequality matrix can be entered directly.}

\item{edo}{Number of unit steps in an octave. Defaults to \code{12}.}

\item{rounder}{Numeric (expected integer), defaults to \code{10}:
number of decimal places to round to when testing for equality.}
}
\value{
Invisible \code{NULL}
}
\description{
You mean you don't want to play around in R forever?
This function lets you export any scale you've defined in R
as a .scl tuning file for use in Scala or by any synth that can read
.scl files. Will write to your working directory.

In addition to saving the necessary tuning data, the function
will attempt to add as comments extra information that can be derived
from MCT functions, like the color number, degrees of freedom, number of sign-vector zeroes, etc.
}
\examples{
neat_pentachord <- convert(c(0, 1, 4, 9, 11), 15, 12)
\donttest{
writeSCL(neat_pentachord, path=tempdir(), "neat_pentachord.scl")
}
}
