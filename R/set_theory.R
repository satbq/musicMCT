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

if(getRversion() >= "2.15.1")  utils::globalVariables(c("fortenums"))

#' Forte number from set class
#' 
#' Given a pitch-class set (in 12edo only), look up Forte 1973's catalog 
#' number for the corresponding set class.
#'
#' @inheritParams tnprime
#' @returns Character string in the form n-x where n is the number of notes
#'   in the set and x is the ordinal position in Forte's list.
#' @examples
#' fortenum(c(0,4,7))
#' fortenum(c(0,3,7))
#' fortenum(c(4,8,11))
#' @export
fortenum <- function(set) {
  condensed_set <- unique(set)
  card <- length(condensed_set)
  strset <- toString(primeform(condensed_set, edo=12))
  val <- which(fortenums[[card]]==strset)
  return(paste0(card, "-", val))
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

#' Transposition and Inversion
#'
#' @description
#' Calculate the classic operations on pitch-class sets \eqn{T_n} and 
#' \eqn{T_n I}. That is, `tn` adds a constant to all elements in a set
#' modulo the octave, and `tni` essentially multiplies a set by `-1` (modulo 
#' the octave) and then adds a constant (modulo the octave). If `sorted` is
#' `TRUE` (as is default), the resulting set is listed in ascending order,
#' but sometimes it can be useful to track transformational voice leadings,
#' in which case you should set `sorted` to `FALSE`.
#'
#' `startzero` transposes a set so that its first element is `0`.
#' (Note that this is different from [tnprime] because it doesn't attempt
#' to find the most compact form of the set. See examples for the contrast.)
#'
#' Sometimes you just want to invert a set and you don't care what the
#' index is. `charm` is a quick way to do this, giving a name to
#' the transposition-class of \eqn{T_0 I} of the set.
#' (The name `charm` is a reference to "strange" and "charm" quarks in 
#' particle physics: I like these as names for the "a" and "b" forms of
#' a set class, i.e. the strange common triad is 3-11a = (0, 3, 7) 
#' and the charm common triad is 3-11b = (0, 4, 7). The name of the function
#' `charm` means that if you input a strange set, you get out a charm set,
#' but NB also vice versa.)
#' 
#' @inheritParams tnprime
#' @param n Numeric value (not necessarily an integer!) representing the 
#'   index of transposition or inversion.
#' @param sorted Do you want the result to be in ascending order? Boolean,
#'   defaults to `TRUE`.
#' @returns Numeric vector of same length as `set`
#' @examples
#' c_major <- c(0, 4, 7)
#' tn(c_major, 2)
#' tn(c_major, -10)
#' tni(c_major, 7)
#' tni(c_major, 7, sorted=FALSE)
#' tn(c(0, 1, 6, 7), 6)
#' tn(c(0, 1, 6, 7), 6, sorted=FALSE)
#'
#' ##### Difference between startzero and tnprime
#' e_maj7 <- c(4, 8, 11, 3)
#' startzero(e_maj7)
#' tnprime(e_maj7)
#' isTRUE(all.equal(tnprime(e_maj7), charm(e_maj7))) # True because inversionally symmetrical
#' 
#' ##### Derive minimal voice leading from ionian to lydian
#' ionian <- c(0, 2, 4, 5, 7, 9, 11)
#' lydian <- rotate(tn(ionian, 7, sorted=FALSE), 3)
#' lydian - ionian
#' @export
tn <- function(set, n, edo=12, sorted=TRUE) {
  res <- ((set%%edo) + (n%%edo)) %% edo
  if (sorted == FALSE) { return(res) }
  return(sort(res))
}

#' @rdname tn
#' @export
tni <- function(set, n, edo=12, sorted=TRUE) {
  res <- ((n%%edo) - (set%%edo)) %% edo
  if (sorted == FALSE) { return(res) }
  return(sort(res))
}

#' @rdname tn
#' @export
startzero <- function(set, edo=12, sorted=TRUE) tn(set, -set[1], edo, sorted)

#' @rdname tn
#' @export
charm <- function(set, edo=12, sorted=TRUE) {
  return(tnprime(tni(set, 0, edo, sorted), edo))
}

setcompare <- function(x,y) {
  card <- length(x)
  if ( length(y) != card ) { print("Cardinality mismatch"); return(NA) }

  modes <- cbind(x,y)

  for (i in card:1) {
    if (class(modes)[1]=="numeric") {return(modes)}
    top <- min(modes[i,])
    index <- which(modes[i,] == top)
    modes <- modes[,index]
  }

  return(modes[,1])
}

#' Prime form of a set using Rahn's algorithm
#'
#' Takes a set (in any order, inversion, and transposition) and returns the
#' canonical ("prime") form that represents the \eqn{T_n /T_n I}-type to which the
#' set belongs. Uses the algorithm from Rahn 1980 rather than Forte 1973.
#'
#' In principle this should work for sets in continous pitch-class space,
#' not just those in a mod k universe. But watch out for rounding errors:
#' if you can manage to work with integer values, that's probably safer.
#' Otherwise, try rounding your set to various decimal places to test for
#' consistency of result.
#'
#' @inheritParams tnprime
#' @returns Numeric vector of same length as `set`
#' @examples
#' primeform(c(0, 3, 4, 8))
#' primeform(c(0, 1, 3, 7, 8))
#' primeform(c(0, 3, 6, 9, 12, 14), edo=16)
#' @export
primeform <- function(set, edo=12) {
  if (length(set)==1) { return(0) }
  upset <- startzero(tnprime(set, edo), edo)
  downset <- startzero(tnprime(tni(set, 0, edo), edo), edo)
  winner <- setcompare(upset, downset)
  return(winner)
}

#' Test for inversional symmetry
#'
#' Is the pc-set **i**nversionally **sym**metrical? That is, does it map onto itself
#' under \eqn{T_n I} for some appropriate \eqn{n}? This is evaluated by asking
#' whether, for some appropriate rotations, the step-interval series of the
#' given set is equal to the step-interval series of the set's inversion.
#' This is designed to work for sets in continuous pc-space, not just
#' integers mod k. As usual for working with real values, this depends
#' on your rounding tolerance (`rounder`).
#'
#' Note that this calculates abstract pitch-class symmetry, not potential
#' symmetry in pitch space. (See the second example.)
#'
#' @inheritParams tnprime
#' @inheritParams fpunique
#' @returns `TRUE` if the set is inversionally symmetrical, `FALSE` otherwise
#' @examples
#' #### Mod 12
#' isym(c(0, 1, 5, 8))
#' isym(c(0, 2, 4, 8))
#'
#' #### Continuous Values
#' qcm_fifth <- meantone_fifth()
#' qcm_dia <- sort(((0:6)*qcm_fifth)%%12)
#' just_dia <- c(0, just_wt, just_maj3, just_p4, just_p5, 12-just_min3, 12-just_st)
#' isym(qcm_dia)
#' isym(just_dia)
#' 
#' #### Rounding matters:
#' isym(qcm_dia, rounder=15)

#' @export
isym <- function(set, edo=12, rounder=10) {
  card <- length(set)
  setword <- asword(set, edo, rounder)
  invsetword <- rev(setword)

  for (i in 1:card) {
    invmode <- rotate(invsetword,i)
    if ( isTRUE(all.equal(setword,invmode)) ) { return(TRUE) }
  }
  return(FALSE)
}

#' Interval-class vector
#'
#' The classic summary of a set's dyadic subset content from pitch-class set theory.
#' The name `ivec` is short for **i**nterval-calss **vec**tor.
#' 
#' @inheritParams tnprime
#' @returns Numeric vector of length `floor(edo/2)`
#' @examples
#' ivec(c(0,1,4,6))
#' ivec(c(0,1,3,7))
#' 
#' #### Z-related sextuple in 24edo:
#' sextuple <- matrix(
#'   c(0, 1, 2, 6, 8, 10, 13, 16,
#'   0, 1, 3, 7, 9, 11, 12, 17,
#'   0, 1, 6, 8, 10, 13, 14, 16,
#'   0, 1, 7, 9, 11, 12, 15, 17,
#'   0, 1, 2, 4, 8, 10, 13, 18,
#'   0, 2, 3, 4, 8, 10, 15, 18), nrow=6, byrow=TRUE)
#' apply(sextuple, 1, ivec, edo=24) # The ic-vectors are the 6 identical columns of the output matrix
#' @export
ivec <- function(set, edo=12) {
  set <- set%%edo
  set <- unique(set)
  vec <- rep(edo+1,edo/2)
  ivs <- outer(set, set, "-")
  ivs2 <- (edo - ivs)
  lowers <- ivs
  lowers[which(ivs > ivs2)] <- ivs2[which(ivs > ivs2)]
  nonzero <- lowers[lowers > 0]

  for (i in 1:(edo/2)) {
    vec[i] <- sum(nonzero == i)
  }

  return(vec)
}

#' Set class complement
#'
#' Find the complement of a set class in a given mod k universe. Complements
#' have traditionally been recognized in pitch-class set theory as sharing
#' many properties with each other. This is true to *some* extent when 
#' considering scales in continuous pc-space, but sometimes it is not! 
#' Therefore whenever you're exploring an odd property that a scale has, it
#' can be useful to check that scale's complement (if you've come across the
#' scale in some mod k context, of course).
#'
#' @inheritParams tnprime
#' @returns Numeric vector representing a set of length `edo - n` where `n` is
#'   the length of the input `set`
#' @examples
#' diatonic19 <- c(0, 3, 6, 9, 11, 14, 17)
#' chromatic19 <- scComp(diatonic19, edo=19)
#' icvecs_19 <- rbind(ivec(diatonic19, edo=19), ivec(chromatic19, edo=19))
#' rownames(icvecs_19) <- c("diatonic ivec", "chromatic ivec")
#' icvecs_19
#' @export
scComp <- function(set,edo=12) {
  return(primeform(setdiff(0:(edo-1),set),edo))
}
