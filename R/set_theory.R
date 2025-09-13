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
#'
#' @examples
#' ait1 <- sc(4, 15)
#' ait2 <- sc(4, 29)
#'
#' NB_rahn_prime_form <- sc(6, 31)
#' print(NB_rahn_prime_form)
#' @export
sc <- function(card, num) {
  if ((!inherits(card, "numeric") && !inherits(card, "integer"))
       || (!inherits(num, "numeric") && !inherits(num, "integer"))) {
    stop("Inputs must be numeric or integers.")
  }

  if (card < 1 || card > 12) {
    stop("Cardinality not in the range 1-12.")
  }

  set <- fortenums[[card]][num]

  if (length(set) != 1 || is.na(set)) {
   stop("Ordinal number out of bounds for given cardinal or multiple ordinals.") 
  }

  strtoi(unlist(strsplit(set, split=",")))
}

if(getRversion() >= "2.15.1")  utils::globalVariables(c("fortenums"))

#' Forte number from set class
#' 
#' Given a pitch-class set (in 12edo only), look up Forte 1973's catalog 
#' number for the corresponding set class.
#'
#' @inheritParams tnprime
#' @returns Character string in the form "n-x" where n is the number of notes
#'   in the set and x is the ordinal position in Forte's list.
#' @examples
#' fortenum(c(0, 4, 7))
#' fortenum(c(0, 3, 7))
#' fortenum(c(4, 8, 11))
#' @export
fortenum <- function(set) {
  condensed_set <- unique(set %% 12)
  card <- length(condensed_set)
  strset <- toString(primeform(condensed_set, edo=12))
  val <- which(fortenums[[card]]==strset)

  if (length(val) == 0) {
    warning("It looks like ", paste0(round(primeform(condensed_set, edo=12), 2), sep=" "), 
            "includes pitches outside 12edo. Not on Forte's list.")
  }

  paste0(card, "-", val)
}

#' Rahn's algorithm
#'
#' The essence of Rahn's algorithm for finding a set's prime form
#' is to find the version of a pc set which is most "packed to the left".
#' This function implements that process.
#'
#' @param modes A scalar interval matrix
#' @inheritParams tnprime
#'
#' @returns A numeric vector representing the most compact version of a pc-set
#'
#' @noRd
compactest_mode <- function(modes, rounder=10) {
  tiny <- 10^(-1*rounder)
  card <- nrow(modes)

  for (i in card:1) {
    if (inherits(modes, "numeric")) {
      return(modes)
    }

    top <- min(modes[i, ])
    index <- which(abs(modes[i, ] - top) < tiny)
    modes <- modes[, index]
  }

  modes
}

#' Transposition class of a given pc-set
#' 
#' Uses Rahn's algorithm to calculate the best normal order for the 
#' transposition class represented by a given set. Reflects transpositional
#' but not inversional equivalence, i.e. all major triads return (0, 4, 7) and
#' all minor triads return (0, 3, 7).
#'
#' @param set Numeric vector of pitch-classes in the set
#' @inheritParams edoo
#' @inheritParams fpunique
#' @returns Numeric vector of same length as `set` representing the set's
#'   Tn-prime form
#' @examples
#' tnprime(c(2, 6, 9))
#' tnprime(c(0, 3, 6, 9, 14), edo=16)
#' @export
tnprime <- function(set, edo=12, rounder=10) {
  set <- sort(set %% edo)
  card <- length(set)
  if (card == 1) { return(0) }
  if (card == 0) { return(integer(0)) }

  modes <- sim(set, edo=edo)
  modes <- compactest_mode(modes, rounder=rounder)

  modes[1:card]
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
#' (Note that this is different from [tnprime()] because it doesn't attempt
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
#' @param octave_equivalence Do you want to normalize the result so that all values are
#'   between 0 and `edo`? Boolean, defaults to `TRUE`.
#' @param optic String: the OPTIC symmetries to apply. Defaults to `NULL`,
#'   applying symmetries most appropriate to the given function. If specified, overrides 
#'   parameters `sorted` and `octave_equivalence`.
#' @returns Numeric vector of same length as `set`
#' @examples
#' c_major <- c(0, 4, 7)
#' tn(c_major, 2)
#' tn(c_major, -10)
#' tn(c_major, -10, optic="p") # Equivalent to tn(c_major, -10, octave_equivalence=FALSE)
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
tn <- function(set, n, sorted=TRUE, octave_equivalence=TRUE, optic=NULL, edo=12, rounder=10) {
  tiny <- 10^(-1 * rounder)

  if (is.null(optic)) {
    symmetries <- c(o = octave_equivalence, p = sorted, t = FALSE, i = FALSE, c = FALSE)
  } else {
    symmetries <- optic_choices(optic)
  }

  res <- set + n
  if (symmetries["o"]) res <- fpmod(res, edo=edo, rounder=rounder)

  if (symmetries["p"]) res <- sort(res)
 
  if (symmetries["t"] || symmetries["i"]) {
    warning("T and I symmetries don't make sense in this context and have not been applied.")
  }

  if (symmetries["c"]) {
    res <- c_fuse(res, rounder=rounder)
  }

  res
}

#' @rdname tn
#' @export
tni <- function(set, 
                n, 
                sorted=TRUE, 
                octave_equivalence=TRUE, 
                optic=NULL, 
                edo=12, 
                rounder=10) {
  tiny <- 10^(-1 * rounder)

  if (is.null(optic)) {
    symmetries <- c(o = octave_equivalence, p = sorted, t = FALSE, i = FALSE, c = FALSE)
  } else {
    symmetries <- optic_choices(optic)
  }

  res <- n - set
 
  if (symmetries["o"]) res <- fpmod(res, edo=edo, rounder=rounder)

  if (symmetries["p"]) res <- sort(res)
 
  if (symmetries["t"] || symmetries["i"]) {
    warning("T and I symmetries don't make sense in this context and have not been applied.")
  }

  if (symmetries["c"]) {
    res <- c_fuse(res, rounder=rounder)
  }

  res
}

#' @rdname tn
#' @export
startzero <- function(set, 
                      sorted=TRUE, 
                      octave_equivalence=TRUE, 
                      optic=NULL,
                      edo=12, 
                      rounder=10) {
  res <-  tn(set,
            -set[1], 
            sorted=sorted, 
            octave_equivalence=octave_equivalence,
            optic=optic,
            edo=edo, 
            rounder=rounder)
  res - res[1]
}

#' @rdname tn
#' @export
charm <- function(set, edo=12, rounder=10) {
  tnprime(tni(set, 0, edo=edo), edo=edo, rounder=rounder)
}

#' Apply compactest_mode to both inversions of a set
#'
#' The final step of finding a prime form is to compare the
#' most compact representations of original and inverted forms
#' of a set. This does this by passing their individual best representatives
#' to compactest_mode() for comparison.
#'
#' @param x,y Numeric vectors of the same length
#' @inheritParams tnprime
#' 
#' @returns A single "winner" represented by either x or y
#'
#' @noRd
strange_charm_compare <- function(x, y, rounder=10) {
  card <- length(x)
  modes <- cbind(x,y)
  modes <- compactest_mode(modes, rounder=rounder)

  modes[1:card]
}

#' Find the optimal element for Hook's normal form algorithm
#'
#' See Hook (2023 pp. 417-418, ISBN: 9780190246013).
#'
#' @param vals Vector of values (notes or intervals) from which to choose the optimal element
#' @param octave_equivalence Is O symmetry being considered? Defaults to `TRUE`.
#'
#' @returns Either the absolutely smallest element or smallest residue mod edo
#'   depending on the `octave_equivalence` parameter
#'
#' @noRd
hook_optimize <- function(vals, octave_equivalence=TRUE, edo=12, rounder=10) {
  rounded_vals <- round(vals, digits=rounder)
  rounded_abs <- abs(rounded_vals)
  signs <- sign(rounded_vals)
  tiny <- 10^(-1 * rounder)

  if (octave_equivalence==FALSE) {
    optimal_val <- min(rounded_abs)
    indices <- which(rounded_abs==optimal_val)
    negative_values <- which(signs < 0)
    positive_indices <- setdiff(indices, negative_values)
    if (length(positive_indices) < 1) {
      index <- indices[1]
    } else {
      index <- positive_indices[1] 
    }   
  } else {
    modular_vals <- fpmod(rounded_vals, edo=edo, rounder=rounder)
    min_mod_val <- min(modular_vals)
    offsets <- modular_vals - min_mod_val
    indices <- which(abs(offsets) < tiny)
    index <- indices[1]
    vals <- modular_vals
  }

  vals[index]
}

#' Pack a set to the left
#'
#' Like Rahn's algorithm but doesn't apply T-equivalence, so can be used to find
#' the traditional "normal order" of a pitch-class set.
#'
#' @inheritParams tnprime
#' @param mat An imput matrix whose columns are to be compared
#' @inheritParams hook_optimize
#'
#' @returns Numeric vector which corresponds to once of the columns of `mat`
#'
#' @noRd
pack_left <- function(mat, octave_equivalence=TRUE, edo=12, rounder=10) {
  card <- dim(mat)[1]
  tiny <- 10^(-1 * rounder)

  for (i in card:1) {
    optimal_value <- hook_optimize(mat[i, ], 
                                   octave_equivalence=octave_equivalence, 
                                   edo=edo,
                                   rounder=rounder)
    indices <- which(abs(mat[i, ] - optimal_value) < tiny)
    mat <- mat[, indices]

    if (length(indices)==1) {
      return(mat)
    }
  }

  mat[, 1]
}


#' First Note Tiebreaker
#'
#' See (2023, 418, ISBN: 9780190246013), step 5.
#'
#' @inheritParams pack_left
#' 
#' @returns A vector representing the set with optimal starting element
#'
#' @noRd
hook_tiebreak <- function(mat, octave_equivalence=TRUE, edo=12, rounder=10) {
  card <- dim(mat)[1]
  reversed_mat <- mat[card:1, ]
  res <- pack_left(reversed_mat, octave_equivalence=octave_equivalence, edo=edo, rounder=rounder)
  res[card:1]
}

#' Hook's OPTIC normal forms
#'
#' Following Hook (2023, 416-18, ISBN: 9780190246013), calculates a normal
#' form for the input `set` using any combination of OPTIC symmetries.
#'
#' This function is designed for flexibility in the `optic` parameter, not speed.
#' In situations where you need to calculate a large number of OPTIC- or OPTC-normal
#' forms, you should use `primeform()` or `tnprime()` respectively, which are considerably
#' faster.
#'
#' @inheritParams tnprime
#' @param optic String: the OPTIC symmetries to apply. Defaults to "opc".
#'
#' @returns Numeric vector with the desired normal form of `set`
#'
#' @examples
#' # See Exercise 10.4.8 in Hook (2023, 420):
#' eroica <- c(-25, -13, -6, -3, 0, 3)
#' normal_form(eroica, optic="pti")
#' normal_form(eroica, optic="op")
#'
#' # See Table 10.4.1 in Hook (2023, 417):
#' alpha <- c(-5, -11, 14, 9, 14, 14, 2)
#' num_symmetries <- sample(0:5, 1)
#' random_symmetries <- sample(c("o", "p", "t", "i", "c"), num_symmetries)
#' random_symmetries <- paste(random_symmetries, collapse="")
#' print(random_symmetries)
#' normal_form(alpha, optic=random_symmetries)
#'
#' @seealso [primeform()], [tnprime()], and [startzero()] for faster functions
#'  dedicated to specific symmetry combinations
#' @export
# currently fails for hook's demo set under PI
normal_form <- function(set, optic="opc", edo=12, rounder=10) {
  if (length(set) == 0) {
    return(numeric(0))
  }

  optic <- tolower(optic)
  symmetries <- optic_choices(optic)
  optc_only <- gsub("i", "", optic)
  opc_only <- gsub("t", "", optc_only) 

  if (symmetries["o"]) set <- fpmod(set, edo=edo, rounder=rounder)

  if (symmetries["p"]) set <- sort(set)

  if (symmetries["c"]) set <- c_fuse(set, rounder=rounder)

  if (length(set)==1) {
    if (symmetries["t"]) {
      return(0)
    }
    if (symmetries["i"]) {
      return(abs(set))
    } else {
      return(set)
    }
  }

  if (symmetries["o"] && symmetries["p"]) {
    modes <- sim(set, edo=edo, rounder=rounder)

    # octave_equivalence should indeed be false here
    # because multisets can have an octave span from first to last (not a unison!)
    ideal_mode <- pack_left(modes, octave_equivalence=FALSE, edo=edo, rounder=rounder)
    options <- sapply(set, tn, set=ideal_mode, sorted=FALSE, edo=edo, rounder=rounder)

    option_matches <- function(opt, dig=rounder) {
      length(setdiff(round(opt, digits=dig), round(set, digits=dig))) == 0
    }

    indices <- apply(options, 2, option_matches)
    index <- which(indices==TRUE)

    if (length(index) < 1) {
      indices <- apply(options, 2, option_matches, dig=rounder+1)
      index <- which(indices==TRUE)
    }

    set <- options[, index]
  }

  if (inherits(set, "matrix")) {
    set <- hook_tiebreak(set, octave_equivalence=symmetries["o"], edo=edo, rounder=rounder)
  }

  if (symmetries["t"]) {
    set <- startzero(set, optic=opc_only, edo=edo, rounder=rounder)
  }

  if (symmetries["i"]) {
    # Implement most of Step 7
    charm_set <- tni(set, 0, optic=opc_only, edo=edo, rounder=rounder)
    charm_set <- normal_form(charm_set, optic=optc_only, edo=edo, rounder=rounder)
    strange_and_charm <- cbind(set, charm_set)
    snc_zero <- apply(strange_and_charm, 2, startzero, optic=opc_only, edo=edo, rounder=rounder)
    packed_quark <- pack_left(snc_zero, octave_equivalence=FALSE, edo=edo, rounder=rounder)
    matches_packing <- function(vec) isTRUE(all.equal(vec, packed_quark))
    is_packed <- apply(snc_zero, 2, matches_packing)
    set <- strange_and_charm[, is_packed]
    if (inherits(set, "matrix")) {
      set <- hook_tiebreak(set, octave_equivalence=symmetries["o"], edo=edo, rounder=rounder)
    }    

    # Implement "... and, if necessary, step 5"
    if (!symmetries["p"]) {
      set <- cbind(set, -1 * set)
      if (symmetries["o"]) set <- fpmod(set, edo=edo, rounder=rounder)
      set <- hook_tiebreak(set, octave_equivalence=symmetries["o"], edo=edo, rounder=rounder)  
    }  
  }

  set
}

#' Prime form of a set using Rahn's algorithm
#'
#' Takes a set (in any order, inversion, and transposition) and returns the
#' canonical ("prime") form that represents the \eqn{T_n /T_n I}-type to which the
#' set belongs. Uses the algorithm from Rahn 1980 rather than Forte 1973.
#'
#' In principle this should work for sets in continuous pitch-class space,
#' not just those in a mod k universe. But watch out for rounding errors:
#' if you can manage to work with integer values, that's probably safer.
#' Otherwise, try rounding your set to various decimal places to test for
#' consistency of result.
#'
#' @inheritParams tnprime
#' @inheritParams fpunique
#' @returns Numeric vector of same length as `set`
#' @examples
#' primeform(c(0, 3, 4, 8))
#' primeform(c(0, 1, 3, 7, 8))
#' primeform(c(0, 3, 6, 9, 12, 14), edo=16)
#' @export
primeform <- function(set, edo=12, rounder=10) {
  if (length(set)==1) { return(0) }
  upset <- tnprime(set, edo, rounder)
  downset <- charm(set, edo, rounder)
  strange_charm_compare(upset, downset, rounder)
}

#' Test for inversional symmetry
#'
#' Is the pc-set **i**nversionally **sym**metrical? That is, does it map onto itself
#' under \eqn{T_n I} for some appropriate \eqn{n}? `isym()` can return either
#' `TRUE`/`FALSE` or an index of symmetry but defaults to the former. `isym_index()`
#' is a simple wrapper for `isym()` that returns the latter. `isym_degree()`
#' counts the total number of inversional symmetries (i.e. the number of distinct 
#' inversional axes of symmetry).
#'
#' `isym()` is evaluated by asking whether, for some appropriate rotation,
#' the step-interval series of the given set is equal to the step-interval 
#' series of the set's inversion. This is designed to work for sets in 
#' continuous pc-space, not just integers mod k. Note also that this 
#' calculates abstract pitch-class symmetry, not potential
#' symmetry in pitch space. (See the second example.)
#'
#' @inheritParams tnprime
#' @inheritParams fpunique
#' @param return_index Should the function return a specific index at which
#'   the set is symmetrical? Defaults to `FALSE`.
#' @param ... Arguments to be passed to `isym()`
#' @returns `isym()` returns the Boolean value from testing for symmetry,
#'   unless `return_index=TRUE`, in which case isym() and `isym_index()`
#'   return a numeric value for one index of inversion at which the set
#'   is symmetrical. If the set is not inversionally symmetrical, they will
#'   return `NA`. `isym_degree()` gives the degree of inversional symmetry.
#' 
#' @examples
#' #### Mod 12
#' isym(c(0, 1, 5, 8))
#' isym(c(0, 2, 4, 8))
#'
#' #### Continuous Values
#' qcm_fifth <- meantone_fifth()
#' qcm_dia <- sort(((0:6)*qcm_fifth)%%12)
#' just_dia <- j(dia)
#' isym(qcm_dia)
#' isym(just_dia)
#' 
#' #### Rounding matters:
#' isym(qcm_dia, rounder=15)
#'
#' ### Index and Degree
#' hexatonic_scale <- c(0, 1, 4, 5, 8, 9)
#' isym_index(hexatonic_scale) # Only returns one suitable index
#' isym_degree(hexatonic_scale)
#'
#' @export
isym <- function(set, return_index=FALSE, edo=12, rounder=10) {
  card <- length(set)
  if (card < 2) { 
    return(TRUE) 
  }

  setword <- asword(set, edo, rounder)
  invsetword <- rev(setword)

  test_mode <- function(i) isTRUE(all.equal(rotate(invsetword, i), setword))
  symmetrical_rotations <- sapply(1:card, test_mode)

  if (return_index) {
    first_sym <- which(symmetrical_rotations==TRUE)[1]
    (set[1] + set[card+1-first_sym]) %% edo
  } else {
    any(symmetrical_rotations)
  }
}

#' @rdname isym
#' @export
isym_index <- function(set, ...) isym(set, return_index=TRUE, ...)

#' @rdname isym
#' @export
isym_degree <- function(set, ...) tsym_degree(set, ...) * isym(set, return_index=FALSE, ...)

#' Test for transpositional symmetry
#'
#' Does the set map onto itself at some transposition other than \eqn{T_0}?  That is,
#' does it map onto itself under \eqn{T_n} for some appropriate \eqn{n}? `tsym()` 
#' can return either `TRUE`/`FALSE` or an index of symmetry but defaults to the former. 
#' `tsym_index()` is a simple wrapper for `tsym()` that returns the latter. `tsym_degree()`
#' counts the total number of transpositional symmetries.
#'
#' @inheritParams tnprime
#' @param ... Arguments to be passed to `tsym()`
#' @inheritParams isym
#'
#' @returns By default, `tsym()` returns `TRUE` if the set has non-trivial transpositional 
#'   symmetry, `FALSE` otherwise. If `return_index` is `TRUE`, returns a vector of transposition
#'   levels at which the set is symmetric, including `0`. `tsym_index()` is a wrapper for `tsym()`
#'   which sets `return_index` to `TRUE`. `tsym_degree()` gives the degree of symmetry, which
#'   is simply the length of `tsym_index()`'s value.
#'
#' @examples
#' tsym(sc(6, 34))
#' tsym(sc(6, 35))
#' tsym(edoo(5))
#'
#' # Works for continuous values:
#' tsym(tc(j(dia), edoo(3)))
#'
#'
#' # Index and Degree:
#' tsym_index(c(0, 1, 3, 6, 7, 9))
#' tsym_degree(edoo(7))
#'
#' @export
tsym <- function(set, return_index=FALSE, edo=12, rounder=10) {
  set <- sort(set)
  card <- length(set)

  if (card < 2) {
    if (return_index) {
      return(0)
    } else {
      return(FALSE)
    }
  }

  levels_to_check <- edoo(card, edo=edo)
  transpositions <- sapply(levels_to_check, tn, set=set, edo=edo)
  matches_set <- function(x) isTRUE(all.equal(round(x, rounder), set))
  symmetry_levels <- which(apply(transpositions, 2, matches_set))
  indices <- levels_to_check[symmetry_levels]

  if (return_index) {
    indices
  } else {
    length(symmetry_levels) > 1
  }
}

#' @rdname tsym
#' @export
tsym_index <- function(set, ...) tsym(set, return_index=TRUE, ...)

#' @rdname tsym
#' @export
tsym_degree <- function(set, ...) length(tsym_index(set, ...))

#' Interval-class vector
#'
#' The classic summary of a set's dyadic subset content from pitch-class set theory.
#' The name `ivec` is short for **i**nterval-class **vec**tor.
#' 
#' @inheritParams tnprime
#' @returns Numeric vector of length `floor(edo/2)`
#' @examples
#' ivec(c(0, 1, 4, 6))
#' ivec(c(0, 1, 3, 7))
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

  vec
}

#' Set class complement
#'
#' Find the complement of a set class in a given mod k universe. Complements
#' have long been recognized in pitch-class set theory as sharing
#' many properties with each other. This is true to *some* extent when 
#' considering scales in continuous pc-space, but sometimes it is not! 
#' Therefore whenever you're exploring an odd property that a scale has, it
#' can be useful to check that scale's complement (if you've come across the
#' scale in some mod k context, of course).
#'
#' @inheritParams tnprime
#' @inheritParams cover
#' @returns Numeric vector representing a set class of length `edo - n` where `n` is
#'   the length of the input `set`
#' @examples
#' diatonic19 <- c(0, 3, 6, 9, 11, 14, 17)
#' chromatic19 <- sc_comp(diatonic19, edo=19)
#' icvecs_19 <- rbind(ivec(diatonic19, edo=19), ivec(chromatic19, edo=19))
#' rownames(icvecs_19) <- c("diatonic ivec", "chromatic ivec")
#' icvecs_19
#' @export
sc_comp <- function(set, canon=c("tni", "tn"), edo=12, rounder=10) {
  canon <- match.arg(canon)
  normalform <- function(x, edo, rounder) {
    switch(canon,
           tni = primeform(x, edo=edo, rounder=rounder),
           tn = tnprime(x, edo=edo, rounder=rounder))
  }

  normalform(setdiff(0:(edo-1), set), edo=edo, rounder=rounder)
}

#' Transpositional combination & pitch multiplication
#'
#' Cohn (1988) <doi:10.2307/745790> defines transpositional
#' combination as a procedure that generates a pc-set as the union of two
#' (or more) transpositions of some smaller set. `tc()` takes the small set
#' and a vector of transposition levels, returning the larger pc-set that
#' results. (Pierre Boulez referred to this procedure as pitch "multiplication",
#' which Amiot (2016) <doi:10.1007/978-3-319-45581-5> shows to be not at
#' all fanciful, as a convolution of two pitch-class sets.)
#'
#' @inheritParams tnprime
#' @param multiplier Numeric vector of transposition levels to apply to `set`. If not
#'   specified, defaults to `set`.
#'
#' @returns Numeric vector of length \eqn{\leq} `length(set)` \eqn{\cdot} `length(multiplier)`
#'
#' @examples
#' tc(c(0, 4), c(0, 7))
#' tc(c(0, 7), c(0, 4))
#'
#' pyth_tetrachord <- j(1, t, dt, 4)
#' pyth_dia <- tc(pyth_tetrachord, j(1, 5))
#' same_hue(pyth_dia, c(0, 2, 4, 5, 7, 9, 11))
#'
#' @export
tc <- function(set, multiplier=NULL, edo=12, rounder=10) {
  if (is.null(multiplier)) multiplier <- set
  all_pcs <- sapply(multiplier, tn, set=set, edo=edo)    
  all_pcs <- as.numeric(all_pcs)
  sort(fpunique(all_pcs, rounder=rounder))
}


#' Visualize a set in pitch-class space
#'
#' No-frills way to plot the elements of a set on the circular "clockface"
#' of pc-set theory pedagogy. (See e.g. Straus 2016, ISBN: 9781324045076.)
#'
#' @inheritParams tnprime
#' 
#' @returns Invisible copy of the input `set`
#'
#' @examples
#' just_diatonic <- j(dia)
#' clockface(just_diatonic)
#'
#' double_tresillo <- c(0, 3, 6, 9, 12, 14)
#' clockface(double_tresillo, edo=16)
#'
#' @export
clockface <- function(set, edo=12) {
  radius <- 2
  rim_radius <- 1.2 * radius
  note_circle_offset <- radius * -.0075
  num_circle_points <- 100
  circle_points <- seq(0, 2*pi, length.out=num_circle_points) 

  hours <- 0:(edo-1)
  display_digits <- sapply(hours, toString)

  get_position <- function(x, rad=radius) c(rad*cos(2*pi*x/edo), rad*sin(2*pi*x/edo))
  digit_positions <- sapply(hours, get_position, rad=radius)
  note_positions <- sapply(set, get_position, rad=radius)

  rotation_matrix <- matrix(c(0, -1, 1, 0), nrow=2)
  change_orientation <- function(vec) {
    vec <- rotation_matrix %*% vec
    c(vec[1], -vec[2])
  }

  digit_positions <- t(apply(digit_positions, 2, change_orientation))
  note_positions <- t(apply(note_positions, 2, change_orientation)) 
  note_positions[, 2] <- note_positions[, 2] + note_circle_offset

  plot(digit_positions, 
       type="n", 
       axes=FALSE, 
       xlab="", 
       ylab="", 
       asp=1, 
       xlim=1.2*c(-radius, radius),  ylim=1.2*c(-radius, radius))
  graphics::text(digit_positions, labels=display_digits)

  oldpar <- graphics::par(new=TRUE)

  plot(rim_radius*cbind(cos(circle_points), sin(circle_points)), 
       type="l", 
       axes=FALSE, 
       xlab="", 
       ylab="", 
       asp=1, 
       xlim=1.2*c(-radius, radius),  
       ylim=1.2*c(-radius, radius))

  graphics::par(new=TRUE)
  plot(note_positions, 
       pch=1, 
       cex=3.5, 
       lwd=3,
       axes=FALSE, 
       xlab="", 
       ylab="", 
       asp=1, 
       xlim=1.2*c(-radius, radius),
       ylim=1.2*c(-radius, radius))
  graphics::mtext(paste("Clockface Representation of ", deparse(substitute(set)), " in ", edo, "-edo", sep=""))

  graphics::par(oldpar)
  invisible(set)
}

