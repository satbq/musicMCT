#' Find a scale mod k of the same color
#'
#' Modal Color Theory is useful for analyzing scales in continuous pitch-class
#' space with irrational values, but sometimes those irrational values can be
#' inconvenient to work with. Therefore it's often quite useful to find a 
#' scale that has the same color as the one you're studying, but which can
#' be represented by integers in some mod k universe. See "Modal Color Theory,"
#' 27.
#'
#' @inheritParams howfree
#' @param nmax Integer, essentially a limit to how far the function should search before giving up.
#'   Although every color should have a rational representation in some mod k universe, for some colors
#'   that k must be very high. Increasing nmax makes `quantize_color` run longer but might be necessary
#'   if small chromatic universes don't produce a result. Defaults to `12`.
#' @param reconvert Boolean. Should the scale be converted to 12edo? Defaults to `FALSE`.
#'
#' @returns If `reconvert=FALSE`, a list of two elements: element 1 is `set` with a vector of integers
#'   representing the quantized scale; element 2 is `edo` representing the number k of unit steps in the
#'   mod k universe. If `reconvert=TRUE`, returns a single numeric vector converted to measurement relative
#'   to 12-tone equal tempered semitones: these generally will not be integers. May also return a vector
#'   of `NA`s the same length as `set` if no suitable quantization was found beneath the limit given by
#'   `nmax`.
#'
#' @examples
#' qcm_fifth <- meantone_fifth()
#' qcm_lydian <- sort(((0:6)*qcm_fifth)%%12)
#' quantize_color(qcm_lydian)
#' 
#' # Let's approximate the Werckmeister III well-temperament
#' werck_ratios <- c(1, 256/243, 64*sqrt(2)/81, 32/27, (256/243)*2^(1/4), 4/3, 
#'   1024/729, (8/9)*2^(3/4), 128/81, (1024/729)*2^(1/4), 16/9, (128/81)*2^(1/4))
#' werck3 <- 12 * log2(werck_ratios)
#' quantize_color(werck3)
#' quantize_color(werck3, reconvert=TRUE)
#'
#' @export
quantize_color <- function(set, nmax=12, reconvert=FALSE, ineqmat=NULL, edo=12, rounder=10) {
  card <- length(set)
  signvec <- signvector(set, ineqmat=ineqmat, edo=edo, rounder=rounder)

  word <- asword(set, edo, rounder)
  letters <- sort(unique(word), decreasing=FALSE)

  startedo <- sum(word)

  current_set <- cumsum(c(0,word))[1:card]

  if (isTRUE(all.equal(signvector(current_set, ineqmat=ineqmat, edo=startedo, rounder=rounder), signvec))) {
    result_list <- list(set=current_set, edo=startedo)
    if (reconvert==TRUE) {
      return(convert(result_list$"set", result_list$"edo", edo))
    } else {
      return(result_list)
    }
  }

  options <- utils::combn(nmax,length(letters))
  stop <- dim(options)[2]

  for (i in 1:stop) {
      newletters <- options[,i]
      res <- word

    for (j in seq_along(letters)) {
      res <- replace(res, which(word==letters[j]), newletters[j])
    }

    current_edo <- sum(res)
    current_set <- cumsum(c(0,res))[1:card]

    current_signvec <- signvector(current_set, ineqmat=ineqmat, edo=current_edo, rounder=rounder)

    if (isTRUE(all.equal(current_signvec, signvec))) {
          result_list <- list(set=current_set, edo=current_edo)
          if (reconvert==TRUE) {
            return(convert(result_list$"set", result_list$"edo", edo))
          } else {
            return(result_list)
          }
    }
  }
  return(rep(NA,card))
}
