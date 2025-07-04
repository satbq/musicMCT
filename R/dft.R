#' Convert between pitch-class sets and distributions
#'
#' For applications of the Discrete Fourier Transform to pitch-class 
#' set theory, it's typically convenient to represent musical sets 
#' in terms of *distributions* rather than lists of their elements.
#' (See Chapter 1 of Amiot 2016, <doi:10.1007/978-3-319-45581-5>.)
#' These functions convert back and forth between those representations.
#' s2d() and d2s() are shorthands for set_to_distribution() and
#' distribution_to_set(), respectively.
#'
#' @inheritParams tnprime
#' @param set Numeric vector of pitch-classes in the set. May be a 
#'  multiset, in which case the result is different from the corresponding
#'  set with repetitions removed. Entries must be integers.
#' @param distro Numeric vector representing a pitch-class distribution.
#' @param multiset Boolean. Should distribution_to_set() return a multiset if 
#'  element weights are greater than 1? Defaults to `TRUE`.
#' @param reconvert Boolean. Should the scale be converted to the input edo? 
#'  Defaults to `TRUE`.
#' @param ... Arguments to be passed from s2d() or d2s() to unabbreviated
#'  functions.
#'
#' @returns set_to_distribution() returns a numeric vector with length
#'  `edo`, whose `i`th entry represents the weight assigned to pitch-class
#'  `i` in the distribution. distribution_to_set() returns a (multi)set
#'  represented by listing its elements in a vector. (Non-integer weights are rounded
#'  *up* to the next highest integer if `multiset` is `TRUE`.)
#'
#' @examples
#' set_to_distribution(c(0, 4, 7))
#' s2d(c(0, 4, 7)) # Same result but quicker to type
#' s2d(c(0, 4, 4, 7)) # The doubled third is reflected by the value 2 in the result
#' 
#' minor_triad_distro <- c(2, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0)
#' distribution_to_set(minor_triad_distro)
#' d2s(minor_triad_distro, multiset=FALSE)
#'
#' # distribution_to_set automatically converts to 12edo, which
#' # can sometimes be undesirable, as in this case:
#' tresillo_distro <- c(1, 0, 0, 1, 0, 0, 1, 0)
#' d2s(tresillo_distro) 
#' d2s(tresillo_distro, reconvert=FALSE)
#'
#' @export
set_to_distribution <- function(set, edo=12, rounder=10) {
  set <- set %% edo
  rounded_set <- round(set, 0)

  rounding_diff <- set - rounded_set
  if (max(abs(rounding_diff)) > 10^(-1 * rounder)) {
    stop("Non-integer values detected in ",
            deparse(substitute(set)),
            " but only ",
            edo,
            "-edo values were expected.")
  }

  distro <- rep(0, edo)
  set_counts <- table(rounded_set+1)
  set_values <- strtoi(names(set_counts))
  distro[set_values] <- set_counts
  distro
}

#' @rdname set_to_distribution
#' @export
distribution_to_set <- function(distro, 
                                multiset=TRUE, 
                                reconvert=TRUE, 
                                edo=12, 
                                rounder=10) {
  d_edo <- length(distro)
  rounded_distro <- round(distro, digits=rounder)
  if (multiset) { get_counts <- ceiling } else { get_counts <- sign }

  counts <- get_counts(rounded_distro)
  values <- 0:(length(distro)-1)

  set <- unlist(mapply(rep, x=values, times=counts))
 
  if (reconvert) {
    res <- convert(set, d_edo, edo)
  } else {
    res <- list(set=set, edo=d_edo)
  }

  res
}

#' @rdname set_to_distribution
#' @export
s2d <- function(...) set_to_distribution(...)

#' @rdname set_to_distribution
#' @export
d2s <- function(...) distribution_to_set(...)

#' The musical Discrete Fourier Transform of a pitch-class set
#'
#' Computes the magnitudes and phases of the DFT components for a given (multi)set
#' which can be input as either a vector of elements or as a distribution.
#' (See Amiot (2016) <doi:10.1007/978-3-319-45581-5> for an overview of applications
#' of the DFT in this vein.) Entering a distribution takes priority over an entered `set`.
#' 
#' The scaling and orientation of phases corresponds to that used in Yust (2021)
#' <doi:10.1093/mts/mtaa0017>: phases are reported as multiples of one kth of an
#' octave (where the set is entered in k-edo), and oriented so that the $f_1$ component
#' of a singleton points in the direction of the singleton (i.e. the phase of $f_1$ for
#' pitch class 4 is 4). This differs from the phase values use in other publications,
#' such as Yust (2015) <doi:10.1215/00222909-2863409>. Magnitudes are not squared, following
#' Amiot (2016) rather than Yust (2021).
#'
#' @inheritParams tnprime
#' @param distro Numeric vector representing a pitch-class distribution. Defaults
#'  to `NULL` and overrides `set` and `edo` if entered.
#'
#' @returns A 2-by-k real matrix, where k is the number of independent components. The 
#'  ith column corresponds to the (i-1)th component (so that the first column gives the
#'  zeroth component). The first row gives the magnitudes of the components and the
#'  second row gives the phases. (See details regarding interpretation of the values:
#'  they are scaled by edo/(2*pi) from radians.)
#'
#' @examples
#' # Compare to Yust (2021), Example 10
#' reich_signature <- c(0, 1, 2, 4, 5, 7, 9, 10)
#' dft(reich_signature)
#' # Magnitudes differ from Yust by squaring:
#' round(dft(reich_signature)[1, ]^2, digits=3)
#'
#' reich_sig_distribution <- c(1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0)
#' dft(distro=reich_sig_distribution)
#'
#' # Z-related AITs differ in phase but not magnitude:
#' ait1 <- c(0, 1, 4, 6)
#' ait2 <- c(0, 1, 3, 7)
#' dft(ait1)
#' dft(ait2)
#'
#' @export
dft <- function(set, distro=NULL, edo=12, rounder=10) {
  if (!is.null(distro)) edo <- length(distro)
  num_components <- floor(edo/2) + 1

  if (is.null(distro)) {
    distro <- set_to_distribution(set=set, edo=edo, rounder=rounder)
  }
  
  complex_vals <- stats::fft(distro)
  complex_vals <- complex_vals[1:num_components]
  magnitude <- Mod(complex_vals)
  phase <- Arg(complex_vals)
  phase <- (-edo/(2*pi)) * phase
  phase <- phase %% edo
  too_close_to_edo <- which((edo - phase) < 10^(-1*rounder))
  phase[too_close_to_edo] <- 0

  res <- rbind(magnitude, phase)

  fs <- rep("f", num_components)
  nums <- 0:(num_components-1)
  f_num <- cbind(fs, nums) |> apply(MARGIN=1, FUN=paste, collapse="")
  colnames(res) <- f_num

  res
}