% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{roth_ineqmats}
\alias{roth_ineqmats}
\title{Hyperplane arrangements for Rothenberg arrangements}
\format{
\code{roth_ineqmats}
A list with 24 entries. The nth entry of the list gives the inequality
matrix for n-note scales. Each inequality matrix itself is an m by (n+1)
matrix, where m is the number of hyperplanes in the relevant Rothenberg arrangement.
(The values m are currently only empirical: so far, no principled enumeration exists.)
The last column of the matrix contains constants that translate the hyperplane away
from the origin.
}
\source{
The data in \code{roth_ineqmats} can be recreated with the command
\code{sapply(1:24, make_roth_ineqmat)}.
}
\usage{
roth_ineqmats
}
\description{
The data file \code{roth_ineqmats} represents the Rothenberg hyperplane arrangements
that \code{\link[=make_roth_ineqmat]{make_roth_ineqmat()}} generates. Just like the file \code{ineqmats}, for large
computations it's faster simply to call on precalculated data rather than to run
\code{\link[=make_roth_ineqmat]{make_roth_ineqmat()}} many thousands of times. Thus the object \code{roth_ineqmats} saves
the inequality matrices for scales of cardinality 1-24, to be called upon by
\code{\link[=get_roth_ineqmat]{get_roth_ineqmat()}}.
}
\keyword{datasets}
