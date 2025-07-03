#' Create a scale from a list of its step sizes (or try to)
#'
#' Internal for several functions that try to create a specific scale that
#' represents some desired property like a sign vector. Works by starting
#' from a list of the desired scale's ranked step sizes, e.g. the results
#' that you'd expect from applying asword() to your desired scale. Substitues
#' the vague cardinal numbers of the step word with specific sizes drawn from
#' some predetermined range of possibilities (`1:nmax`).
#'
#' @inheritParams quantize_color
#' @param word Vector with a ranked step word for the desired scale
#' @param signvec Sign vector that you'd like the created scale to have.
#'
#' @returns Numeric vector of a satisfatory scale or a vector of `NA`s. Either
#'   is the same length as `word`.
#'
#' @noRd
try_scale_from_word <- function(signvec, 
                                word, 
                                nmax=12, 
                                reconvert=FALSE, 
                                ineqmat=NULL, 
                                edo=12, 
                                rounder=10) {
  # Generate scales with a given step-word pattern until you create one whose sign vector matches input signvec.
  card <- length(word)
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

  rep(NA,card)
}

#' Find a scale mod k that matches a given color
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
#'   Although every real color should have a rational representation in some mod k universe, for some colors
#'   that k must be very high. Increasing nmax makes the function run longer but might be necessary
#'   if small chromatic universes don't produce a result. Defaults to `12`.
#' @param reconvert Boolean. Should the scale be converted to the input edo? Defaults to `FALSE`.
#'
#' @returns If `reconvert=FALSE`, a list of two elements: element 1 is `set` with a vector of integers
#'   representing the quantized scale; element 2 is `edo` representing the number k of unit steps in the
#'   mod k universe. If `reconvert=TRUE`, returns a single numeric vector measured relative
#'   to the unit step size input as `edo`: these generally will not be integers. May also return a vector
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
#' werck3 <- z(werck_ratios)
#' quantize_color(werck3)
#' quantize_color(werck3, reconvert=TRUE)
#'
#' @export
quantize_color <- function(set, nmax=12, reconvert=FALSE, ineqmat=NULL, edo=12, rounder=10) {
  signvec <- signvector(set, ineqmat=ineqmat, edo=edo, rounder=rounder)

  word <- asword(set, edo, rounder)

  try_scale_from_word(signvec=signvec, word=word, 
                      nmax=nmax, reconvert=reconvert, ineqmat=ineqmat, edo=edo, rounder=rounder)
}

#' Create local hyperplanes for quantize_hue()
#'
#' Aids quantize_hue() by creating a hyperplane normal which simply represents
#' a comparison of a pair of scale degrees: do they represent an equal displacement
#' from the perfectly even scale? A collection of such hyperplanes helps to specify
#' a particular hue.
#'
#' @param vec A vector with 2 entries: integers which identify the scale degrees to compare
#' @param central_set A vector that represents the scale in terms of the coord_to_edo() coordinates
#'
#' @returns A vector representing a hyperplane normal for a custom ineqmat
#'
#' @noRd
ineq_from_sdpair <- function(vec, central_set) {
  ineq <- rep(0, length(central_set)+1)
  ineq[vec[1]] <- -central_set[vec[2]]
  ineq[vec[2]] <- central_set[vec[1]]
  ineq
}

#' Find a scale mod k that matches a given hue
#'
#' Given any scale, attempts to find a scale defined as integers mod k
#' which belongs to the same hue as the input (i.e. would return `TRUE`
#' when [same_hue()] is applied). This function thus is similar in spirit to
#' [quantize_color()] but seeks a more precise structural match between
#' input and quantization. Note, though, that while [quantize_color()] should always
#' be able to find a suitable quantization (if `nmax` is set high enough),
#' this is not necessarily true for `quantize_hue()`. There are lines in 
#' \eqn{\mathbb{R}^n} which pass through no rational points but the origin, so some hues
#' (including ones of musical interest like the 5-limit just diatonic scale)
#' may not have any quantization.
#'
#' @inheritParams quantize_color
#'
#' @returns If `reconvert=FALSE`, a list of two elements: element 1 is `set` with a vector of integers
#'   representing the quantized scale; element 2 is `edo` representing the number k of unit steps in the
#'   mod k universe. If `reconvert=TRUE`, returns a single numeric vector measured relative
#'   to the unit step size input as `edo`: these generally will not be integers. May also return a vector
#'   of `NA`s the same length as `set` if no suitable quantization was found beneath the limit given by
#'   `nmax`.
#'
#' @examples
#' meantone_diatonic <- sort(((0:6)*meantone_fifth())%%12)
#' quantize_hue(meantone_diatonic) # Succeeds
#' quantize_hue(j(dia), nmax=15) # Fails no matter how high you set nmax.
#'
#' quasi_guido <- convert(c(0, 2, 4, 5, 7, 9), 13, 12)
#' quantize_color(quasi_guido)
#' quantize_hue(quasi_guido)
#'
#' @export
quantize_hue <- function(set, 
                         nmax=12, 
                         reconvert=FALSE, 
                         edo=12, 
                         rounder=10) {
  card <- length(set)
  tiny <- 10^(-1 * rounder)
  central_set <- coord_to_edo(set, edo=edo)

  white_sds <- which(abs(central_set) < tiny)
  colorful_sds <- setdiff(1:length(set), white_sds)
  use_white <- use_colorful <- FALSE
  if (length(white_sds) > 1) use_white <- TRUE
  if (length(colorful_sds) > 1) use_colorful <- TRUE

  hue_ineqmat <- matrix(rep(0,card+1), nrow=1)

  if (use_white) {
    whole_white_ineqmat <- make_white_ineqmat(card)
    white_svzeroes <- whichsvzeroes(set, ineqmat=whole_white_ineqmat, edo=edo, rounder=rounder)
    white_ineqmat <- whole_white_ineqmat[white_svzeroes, ]
    hue_ineqmat <- rbind(hue_ineqmat, white_ineqmat)
  }

  if (use_colorful) {
    sd_pairs <- utils::combn(colorful_sds, 2)
    colorful_ineqmat <- t(apply(sd_pairs, 2, ineq_from_sdpair, central_set=central_set))
    
    origin <- c(edoo(card, edo=edo), edo)
    offsets <- colorful_ineqmat %*% origin 
    offsets <- (-1 * offsets) / edo
    colorful_ineqmat[, card+1] <- offsets

    hue_ineqmat <- rbind(hue_ineqmat, colorful_ineqmat)
  }
  
  hue_ineqmat <- hue_ineqmat[-1, ]
  if (!inherits(hue_ineqmat, "matrix")) hue_ineqmat <- t(hue_ineqmat)

  signvec <- signvector(set, ineqmat=hue_ineqmat, edo=edo, rounder=rounder)
  word <- asword(set, edo=edo, rounder=rounder)

  try_scale_from_word(signvec=signvec, 
                      word=word, 
                      nmax=nmax, 
                      reconvert=reconvert, 
                      ineqmat=hue_ineqmat, 
                      edo=edo, 
                      rounder=rounder
  )
}
