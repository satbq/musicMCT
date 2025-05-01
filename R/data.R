#' Hyperplane arrangements for MCT spaces
#'
#' The data file `ineqmats` represents the hyperplane arrangements
#' at the core of Modal Color Theory as matrices containing the
#' hyperplanes' normal vectors. See Appendix 1.2 of Sherrill (2025) for
#' a discussion of the format of these matrices. The matrices can be generated
#' on the fly by [makeineqmat()], but for large computations it's faster
#' simply to call on precalculated data rather than to run [makeineqmat()]
#' many thousands of times. Thus the object `ineqmats` saves the inequality
#' matrices for scales of cardinality 1-53, to be called upon by [getineqmat()].
#'
#' @format `ineqmats`
#' A list with 53 entries. The nth entry of the list gives the inequality
#' matrix for n-note scales. Each inequality matrix itself is an m by (n+1)
#' matrix, where m is an element of [OEIS A034828](https://oeis.org/A034828)
#' (see Sherrill 2025, 40-42). The last column of the matrix contains an
#' offset related to whether any of the generic intervals "wrap around the
#' octave," as e.g. the third from 7 to 2 does in a heptachord. This column
#' is linearly dependent on the previous n columns, which contain the 
#' coefficients of the hyperplane's normal vectors. That is, the first row
#' of the matrix (dropping its last entry) is the normal vector for the
#' first hyperplane of the arrangement, and so on.
#'
#' @source
#' The data in `ineqmats` can be recreated with the command
#' `sapply(2:53, makeineqmat)` and then appending `integer(0)` as the first
#' element of the list (for the case of one-note scales which have no 
#' pairwise interval comparisons and therefore need a matrix of size 0).
"ineqmats"


#' Allen Forte's list of set classes
#'
#' @description
#' For compatibility with music theory's traditional pitch-class set theory,
#' whose landmark text is Allen Forte's 1973 *The Structure of Atonal Music*,
#' the data set `fortenums` hard-codes the ordinal positions of 12-equal pitch-class
#' set classes from Allen Forte's list. This allows us to look up specific set
#' classes from Forte numbers or vice versa. [sc()] does the former and 
#' [fortenum()] does the latter. There's very little need to ever interact with
#' the file `fortenums` itself: you should be able to get anything you need from this
#' data through either [sc()] or [fortenum()].
#' 
#' Note that [primeform()] in `musicMCT`
#' uses Rahn's algorithm rather than Forte's for finding a canonical representative
#' of each set class. Consequently, the entries of `fortenums` also use Rahn's prime
#' forms rather than Forte's.
#'
#' @format
#' A list of length 12. The nth entry of the list corresponds to set classes of
#' cardinality n. Each list entry is a vector of character strings; every element
#' of the vector contains a Rahn prime form as a comma-delimited string. These prime
#' forms are ordered in the same sequence as Forte's list. Thus, for instance, the
#' set class of the minor triad is represented by the string `"0, 3, 7"`, which is
#' the 11th element in `fortenums[[3]]`. 
#'
#' @source
#' Forte, Allen. 1973. *The Structure of Atonal Music*. New Haven, CT:
#' Yale University Press. Appendix 1, pp. 179-181.
"fortenums"