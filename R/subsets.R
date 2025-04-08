#' The specific sizes corresponding to each generic interval of a scale
#'
#' As defined by Clough and Myerson 1986 
#' (<https://doi.org/10.1080/00029890.1986.11971924>),
#' an "interval spectrum" is a list of all the specific (or "chromatic") 
#' intervals that occur as instances of a single generic (or "diatonic")
#' interval within some reference scale. For instance, in the usual diatonic
#' scale, the generic interval 1 (a "step" in the scale) comes in two specific
#' sizes: 1 semitone and 2 semitones. Therefore its interval spectrum
#' \eqn{\langle 1 \rangle = \{ 1, 2 \}}. These functions calculates the 
#' spectrum for every generic interval within a set and return either a list of specific values in each 
#' spectrum or a summary of how many distinct values there are.
#'
#' @inheritParams tnprime
#' @inheritParams fpunique
#' @returns `intervalspectrum` returns a list of length one less than `length(set)`. The nth entry of the list
#'   represents the specific sizes of generic interval n. `spectrumcount` returns a vector that reports the length
#'   of each entry in that list (i.e. the number of distinct specific intervals for each generic interval).
#' @examples
#' intervalspectrum(sc(7,35))
#' qcm_fifth <- meantone_fifth()
#' qcm_dia <- sort(((0:6)*qcm_fifth)%%12)
#' intervalspectrum(qcm_dia)
#' just_dia <- 12 * log2(c(1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8))
#' intervalspectrum(just_dia)
#' 
#' spectrumcount(just_dia) # The just diatonic scale is trivalent.
#'
#' # Melodic minor nearly has "Myhill's Property" except for its 3 sizes of fourth and fifth
#' spectrumcount(sc(7,34)) 
#' @export
intervalspectrum <- function(set, edo=12, rounder=10) {
  card <- length(set)
  if (card < 2) { return(list()) }

  modes <- sim(set, edo)
  modes <- t(apply(modes, 1, sort))
  if (card == 2) { return(list(fpunique(modes[2,], rounder=rounder))) }
  uniques <- apply(modes[2:card,],1, fpunique, rounder=rounder)
  if ("matrix" %in% class(uniques)) {
    uniques <- as.list(as.data.frame(uniques))
    names(uniques) <- NULL
  }
  return(uniques)
}

#' @rdname intervalspectrum
#' @export
spectrumcount <- function(set, edo=12, rounder=10) sapply(intervalspectrum(set,edo,rounder),length)

#' Varieties (qualities) of the subsets in a scale that match some generic shape
#'
#' Considered mod 7, the traditional triads of a diatonic scale are all instances of the generic
#' shape (0,2,4). They come in three varieties: major, minor, and diminished. This function lists
#' the distinct varieties of any similarly defined generic shape which occur as subsets in some
#' specified scale (or larger set). 
#'
#' @inheritParams tnprime
#' @inheritParams fpunique
#' @param subsetdegrees Vector of integers indicating the generic shape to use, e.g. `c(0,2,4)` for
#'   tertian trids in a heptachord. Lowest note should be 0.
#' @param set The scale to find subsets of, as a numeric vector
#' @param unique Should each variety be listed only once? Defaults to `TRUE`. If `FALSE`, 
#'   each specific variety will be listed corresponding to how many times it occurs as a subset.
#' @returns A numeric matrix whose columns represent the specific varieties of the subset
#' 
#' @examples
#' c_major_scale <- c(0,2,4,5,7,9,11)
#' double_harmonic_scale <- c(0,1,4,5,7,8,11)
#' 
#' diatonicsubsets(c(0,2,4), c_major_scale)
#' diatonicsubsets(c(0,2,4), c_major_scale, unique=FALSE)
#' diatonicsubsets(c(0,2,4), double_harmonic_scale)
#' @export
diatonicsubsets <- function(subsetdegrees,set,unique=TRUE,edo=12,rounder=10) {
  modes <- sim(set,edo=edo)
  subsetdegrees <- subsetdegrees + 1 #Because in music theory these are 0-indexed, but vectors are 1-indexed in R
  res <- modes[subsetdegrees,]

  if (unique == TRUE) {
  res <- fpunique(res, MARGIN=2, rounder=rounder)
  }

  return(res)
}

#' Subset varieties for all subsets of a fixed size
#'
#' @description
#' Applies [diatonicsubsets] not just to a particular subset shape but to all possible subset shapes
#' given a fixed cardinality. For example, finds the specific varieties of *all* trichordal subsets of 
#' the major scale, not than just the varities of the tonal triad. Comparable to [intervalspectrum] 
#' but for subsets larger than dyads.
#' 
#' The parameter `simplify` lets you decide whether to consider different "inversions" of a subset shape
#' independently. For instance, with `simplify=TRUE`, only root position triads (0,2,4) would be considered;
#' but with `simplify=FALSE`, the first inversion (0,2,5) and second inversion (0,3,5) subset shapes would 
#' also be displayed.
#'
#' @inheritParams diatonicsubsets
#' @param subsetcard Single integer defining the cardinality of subsets to consider
#' @param simplify Should "inversions" of a subset be ignored? Boolean, defaults to `TRUE`
#' @param mode String `"tn"` or `"tni"`. When defining subset shapes, use transposition or transposition 
#'   & inversion to reduce the number of shapes to consider? Defaults to `"tn"`.
#'
#' @returns A list whose length matches the number of distinct subset shapes (given the chosen options).
#'   Each entry of the list is a matrix displaying the varieties of some particular subset type.
#'
#' @examples
#' c_major_scale <- c(0,2,4,5,7,9,11)
#' subsetspectrum(c_major_scale, 3)
#' subsetspectrum(c_major_scale, 3, simplify=FALSE)
#' subsetspectrum(c_major_scale, 3, mode="tni")
#'
#' @export
subsetspectrum <- function(set,subsetcard,simplify=TRUE,mode="tn",edo=12,rounder=10) { 
  card <- length(set)
  comb <- utils::combn(card-1,subsetcard-1)
  comb <- rbind(rep(0,choose(card-1,subsetcard-1)),comb)

  if (mode=="tn") { use <- tnprime }
  if (mode=="tni") { use <- primeform }

  if (simplify == TRUE) {
    comb <- fpunique(apply(comb,2,use,edo=card),MARGIN=2,rounder=rounder)
    if (!("matrix" %in% class(comb))) {
      comb <- as.matrix(comb)
    }
  }

  res <- apply(comb,2,diatonicsubsets,set=set,edo=edo,rounder=rounder)

  if ("matrix" %in% class(res)) {
    res <- as.list(as.data.frame(res))

    for (i in 1:length(res) ) {
       res[[i]] <- matrix(res[[i]],nrow=subsetcard,ncol=(length(res[[i]])/subsetcard))
    }
  }

  names(res) <- apply(comb,2,toString)
  return(res)
}
