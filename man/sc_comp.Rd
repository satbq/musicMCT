% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/set_theory.R
\name{sc_comp}
\alias{sc_comp}
\title{Set class complement}
\usage{
sc_comp(set, edo = 12)
}
\arguments{
\item{set}{Numeric vector of pitch-classes in the set}

\item{edo}{Number of unit steps in an octave. Defaults to \code{12}.}
}
\value{
Numeric vector representing a set class of length \code{edo - n} where \code{n} is
the length of the input \code{set}
}
\description{
Find the complement of a set class in a given mod k universe. Complements
have long been recognized in pitch-class set theory as sharing
many properties with each other. This is true to \emph{some} extent when
considering scales in continuous pc-space, but sometimes it is not!
Therefore whenever you're exploring an odd property that a scale has, it
can be useful to check that scale's complement (if you've come across the
scale in some mod k context, of course).
}
\examples{
diatonic19 <- c(0, 3, 6, 9, 11, 14, 17)
chromatic19 <- sc_comp(diatonic19, edo=19)
icvecs_19 <- rbind(ivec(diatonic19, edo=19), ivec(chromatic19, edo=19))
rownames(icvecs_19) <- c("diatonic ivec", "chromatic ivec")
icvecs_19
}
