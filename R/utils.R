#' Are two integers coprime?
#'
#' Tests whether gcd(num, edo)=1
#'
#' @param num The integer to test
#' @param edo The other integer to test (notionally representing a scale size)
#'
#' @returns Boolean: are the inputs coprime?
#'
#' @noRd
coprime_to_edo <- function(num, edo=12) {
  residues <- 1:edo
  prods <- num * residues
  zeroes <- which(prods %% edo == 0)
  length(zeroes) == 1
}

#' Distance between two points
#'
#' In music theory, different contexts sometimes suggest different ways
#' of measuring distance as most appropriate. Several functions call 
#' `dist_func()` to let a common set of `method`s be available for user
#' choice.
#'
#' @param x A vector which represents the difference between two scales
#' @inheritParams minimize_vl
#'
#' @returns Single numeric value representing a distance
#' 
#' @noRd
dist_func <- function(x, 
                      method=c("taxicab", "euclidean", "chebyshev", "hamming"),
                      rounder=10) {
  method <- match.arg(method)
  tiny <- 10^(-1 * rounder)
  switch(method,
         taxicab = sum(abs(x)),
         euclidean = sqrt(sum(x^2)),
         chebyshev = max(abs(x)),
         hamming = sum(abs(x) > tiny))
}

#' Ensure that an object is a matrix
#'
#' Some functions usually return a matrix but give a vector when there's
#' only one result. This makes sure that even an errant vector is formatted
#' as a matrix with a single column.
#'
#' @param x Any object that you expect to be a matrix
#'
#' @returns Matrix containing the values of x; just x if it was already
#'   a matrix.
#'
#' @noRd
insist_matrix <- function(x) {
  if (!(inherits(x, "matrix"))) x <- as.matrix(x)
  x
}

#' Find all the multiplicative units mod edo
#'
#' For ineqsym (and potentially some other functions, like the classic
#' set theory M operation) you want to find all the multiplicative units
#' in Z/nZ. This does so.
#'
#' @param edo Integer to treat as the modulus
#'
#' @returns Vectors of integers which are invertible mod edo
#'
#' @noRd
units_mod <- function(edo) which(sapply(1:edo, coprime_to_edo, edo=edo)==TRUE)

#' Supply an ineqmat from a choice of hyperplane arrangements
#'
#' Allows users to supply a manual ineqmat if desired, but also to call on
#' any of the standard hyperplane arrangements that have a make_x_ineqmat()
#' function defined for them.
#'
#' @inheritParams tnprime
#' @param x Specify the desired ineqmat. Either enter a matrix (the ineqmat
#'   itself) or a character string naming one of the available conventional
#'   ineqmats ("mct" for modal color theory, "white", "black", or "roth"). Important
#'   combinations of those arrangements are also possible: "pastel" combines
#'   "mct" and "white"; "rosy" combines "mct" and "roth"; "gray" combines "white" and
#'   "black". Defaults to the "mct" ineqmats if unspecified.
#'
#' @returns A matrix (such as getineqmat() or make_roth_ineqmat() produce)
#' @noRd
choose_ineqmat <- function(set, 
                           x=c("mct", "white", "roth", "pastel", "rosy", "black", "gray")) {
  if (inherits(x, "matrix")) {
    return(x)
  }

  if (is.null(x)) x <- "mct"

  card <- length(set)

  x <- match.arg(x)
  create_ineqmat <- switch(x,
                           mct = getineqmat,
                           white = make_white_ineqmat,
                           roth = get_roth_ineqmat,
                           pastel = make_pastel_ineqmat,
                           rosy = make_rosy_ineqmat,
                           black = make_black_ineqmat,
                           gray = make_gray_ineqmat)

  create_ineqmat(card)
}

#' Process inputs from optic parameter
#'
#' Some functions like tn() have a parameter "optic" which allows the
#' user to specify what symmetries they want to consider in a voice-leading
#' space. This function does some initial processing of the input for that
#' parameter that can be shared between functions using it.
#'
#' Throws a warning if the user's input seems to specify symmetries that aren't defined.
#'
#' @param x A string of relevant symmetries (i.e., some substring of "optic")
#' 
#' @returns A vector of 5 boolean values, answering "Should X symmetry be assumed?" for
#'  X = octave, permutation, transposition, inversion, and cardinality, respectively.
#'
#' @noRd
optic_choices <- function(x) {
  x <- tolower(x)
  has_o <- grepl("o", x, fixed=TRUE)
  has_p <- grepl("p", x, fixed=TRUE)
  has_t <- grepl("t", x, fixed=TRUE)  
  has_i <- grepl("i", x, fixed=TRUE)
  has_c <- grepl("c", x, fixed=TRUE)

  should_warn <- grepl("[^ optic]", x, fixed=FALSE)
  if (should_warn) {
    warning("You seem to have specified some non-OPTIC symmetry. Check your 'optic' parameter.",
            call.=FALSE)
  }

  res <- c(has_o, has_p, has_t, has_i, has_c)
  names(res) <- c("o", "p", "t", "i", "c")

  res
}

#' Cardinality Fuse
#'
#' Implements cardinality reduction following Hook (2023, 416-8).
#'
#' @inheritParams tnprime
#'
#' @returns Numeric vector with immediate repetitions (up to rounding) removed
#' 
#' @noRd
c_fuse <- function(set, rounder=10) {
  tiny <- 10^(-1 * rounder)
  adjacencies <- abs(diff(set))
  repetitions <- which((adjacencies < tiny) == TRUE) + 1
  if (length(repetitions)==0) {
    set 
  } else {
    set[-repetitions]
  }
}


#' Difference of multisets
#'
#' Calculate the asymmetric difference between two multisets.
#'
#' @param set1, set2 The multisets to be compared
#' @inheritParams tnprime
#'
#' @returns Vector of the entries of set1 with any entries of set2 removed
#'   (counting multiplicities)
#'
#' @noRd
multiset_diff <- function(set1, set2, rounder=10) {
  set1_uniques <- fpunique(set1, rounder=rounder)
  set2_uniques <- fpunique(set2, rounder=rounder)

  tiny <- 10^(-1 * rounder)
  count_instances <- function(val, set) {
    value_matches <- abs(set - val) < tiny
    sum(value_matches)
  }

  counts_in_set1 <- sapply(set1_uniques, count_instances, set=set1)
  counts_in_set2 <- sapply(set1_uniques, count_instances, set=set2)
  result_counts <- counts_in_set1 - counts_in_set2
  result_counts[result_counts < 0] <- 0
  unlist(mapply(rep, set1_uniques, result_counts))  
}
