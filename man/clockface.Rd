% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/set_theory.R
\name{clockface}
\alias{clockface}
\title{Visualize a set in pitch-class space}
\usage{
clockface(set, edo = 12)
}
\arguments{
\item{set}{Numeric vector of pitch-classes in the set}

\item{edo}{Number of unit steps in an octave. Defaults to \code{12}.}
}
\value{
Invisible copy of the input \code{set}
}
\description{
No-frills way to plot the elements of a set on the circular "clockface"
of pc-set theory pedagogy. (See e.g. Straus 2016, ISBN: 9781324045076.)
}
\examples{
just_diatonic <- j(dia)
clockface(just_diatonic)

double_tresillo <- c(0, 3, 6, 9, 12, 14)
clockface(double_tresillo, edo=16)

}
