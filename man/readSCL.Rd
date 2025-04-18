% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scala.R
\name{readSCL}
\alias{readSCL}
\title{Import a Scala (.scl) file as a scale}
\usage{
readSCL(filename, scaleonly = TRUE, edo = 12)
}
\arguments{
\item{filename}{String with the path to the file to be imported}

\item{scaleonly}{Boolean: should \code{readSCL} return only a vector of pitches, not
additional information from the file? Defaults to \code{TRUE}}

\item{edo}{Number of unit steps in an octave. Defaults to \code{12}.}
}
\value{
A numeric vector with the scale's pitches if \code{scaleonly=TRUE}; else a list
in which the scale's pitches are the first entry, the length of the scale is the second,
and the size of the period is the third.
}
\description{
This function allows you to import scales that have been defined in the Scala tuning format
(*.scl) into R to analyze with the functions of \code{musicMCT}. Scales can be defined in .scl files
in different ways, some of which may lack the precision that computations in \code{musicMCT} normally
assume. If you import a scale that seems to have less regularity than you expected (i.e. it's on 0
hyperplanes even though it seems to be very regular), try increasing your rounding tolerance (i.e. lower
the value of \code{rounder} arguments in the functions you apply to the imported scale).
}
\examples{
# We'll read a sample .scl file that comes with the `musicMCT` package.
demo_filepath <- system.file("extdata", "sample_pentachord.scl", package="musicMCT")
fun_pentachord <- readSCL(demo_filepath)
sim(fun_pentachord)
brightnessgraph(fun_pentachord)

}
