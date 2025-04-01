#' Set class from Forte's list
#' 
#' Given a cardinality and ordinal position, returns the (Rahn) prime form
#' of the set class from Allen Forte's list in *The Structure of Atonal
#' Music* (1973). Draws the information from hard-coded values in the package's
#' data.
#' @param card Integer value between 1 and 12 (inclusive)
#'   that indicates the number of distinct pitch-classes in the set class.
#' @param num Ordinal number of the desired set class in Forte's list
#' @returns Numeric vector of length `card` representing a pc-set of `card` notes.
#' @examples
#' ait1 <- sc(4,15)
#' ait2 <- sc(4,29)
#' NB_rahn_prime_form <- sc(6,31)
#' @export
sc <- function(card, num) {
  set <- fortenums[[card]][num]
  res <- strtoi(unlist(strsplit(set,split=",")))
  return(res)
}

#' Transposition class of a given pc-set
#' 
#' Uses Rahn's algorithm to calculate the best normal order for the 
#' transposition class represented by a given set. Reflects transpositional
#' but not inversional equivalence, i.e. all major triads return (0,4,7) and
#' all minor triads return (0,3,7).
#'
#' @param set Numeric vector of pitch-classes in the set
#' @inheritParams edoo
#' @returns Numeric vector of same length as `set` representing the set's
#'   Tn-prime form
#' @examples
#' tnprime(c(2,6,9))
#' tnprime(c(0,3,6,9,14),edo=16)
#' @export
tnprime <- function(set, edo=12) {
  set <- sort(set %% edo)
  card <- length(set)
  if (card == 1) { return(0) }
  if (card == 0) { return(integer(0))}
  modes <- sim(set, edo)

  for (i in card:1) {
     if (class(modes)[1]=="numeric") {return(modes)}
     top <- min(modes[i,])
     index <- which(modes[i,] == top)
     modes <- modes[,index]
  }

  return(modes[,1])
}