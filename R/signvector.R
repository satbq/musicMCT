#' Detect a scale's location relative to a hyperplane arrangement
#'
#' As "Modal Color Theory" describes (pp. 25-26), each distinct scalar "color" is determined
#' by its relationships to the hyperplanes that define the space. For any scale, this
#' function calculates a sign vector that compares the scale to each hyperplane and returns
#' a vector summarizing the results. If the scale lies on hyperplane 1, then the first
#' entry of its sign vector is `0`. If it lies below hyperplane 2, then the second entry
#' of its sign vector is `-1`. If it lies above hyperplane 3, then the third entry of its
#' sign vector is `1`. Two scales with identical sign vectors belong to the same "color".
#'
#' @inheritParams colornum
#' @returns A vector whose entries are `0`, `-1`, or `1`. Length of vector equals the
#'   number of hyperplanes in `ineqmat`.
#' @examples
#' # 037 and 016 have identical sign vectors because they belong to the same trichordal color
#' signvector(c(0,3,7))
#' signvector(c(0,1,6))
#'
#' # Just and equal-tempered diatonic scales have different sign vectors because they have 
#' # different internal structures (e.g. 12edo dia is generated but just dia is not). 
#' dia_12edo <- c(0, 2, 4, 5, 7, 9, 11)
#' just_dia <- c(0, just_wt, just_maj3, just_p4, just_p5, 12-just_min3, 12-just_st)
#' isTRUE( all.equal( signvector(dia_12edo), signvector(just_dia) ) )
#'
#' @export
signvector <- function(set, ineqmat=NULL, edo=12, rounder=10) {
  if (is.null(ineqmat)) {
    card <- length(set)
    ineqmat <- getineqmat(card)
  }
  set <- c(set, edo)
  res <- ineqmat %*% set
  res <- sign(round(res, digits=rounder))
  return(as.vector(res))
}

#' Which interval-comparison equalities does a scale satisfy?
#'
#' @description
#' As "Modal Color Theory" (p. 26) describes, one useful measure of a scale's
#' regularity is the number of zeroes in its signvector. This indicates how
#' many hyperplanes a scale lies *on*, a geometrical fact whose musical 
#' interpretation is, roughly speaking, how many times two generic intervals equal each other
#' in specific size. (I say only "roughly speaking" because one hyperplane usually
#' represents multiple comparisons: see Appendix 1.1.) Scales with a great
#' degree of symmetry or other forms of regularity such as well-formedness
#' tend to be on a very high number of hyperplanes compared to all sets of 
#' a given cardinality. 
#'
#' `countsvzeroes` returns this **count** of the number
#' of **s**ign-**v**ector **zeroes**, while `whichsvzeroes` gives a list of
#' the specific hyperplanes the scale lines on (numbered according to their
#' position on the given `ineqmat`). The specific information in `whichsvzeroes`
#' can be useful because it determines the "flat" of the hyperplane arrangement
#' that the scale lies on, which is a more general kind of scalar structure
#' than color (as determined by the entire sign vector).
#'
#' @inheritParams signvector
#' @returns Single numeric value for `countsvzeroes` and a numeric vector
#'   for `whichsvzeroes`
#' @examples
#' # Sort 12edo heptachords by how many sign vector zeroes they have (from high to low)
#' heptas12 <- unique(apply(utils::combn(12,7),2,primeform),MARGIN=2)
#' heptas12_svzeroes <- apply(heptas12, 2, countsvzeroes)
#' colnames(heptas12) <- apply(heptas12, 2, fortenum)
#' heptas12[,order(heptas12_svzeroes, decreasing=TRUE)]
#'
#' # Multiple hexachords on the same flat but of different colors
#' hex1 <- c(0,2,4,5,7,9)
#' hex2 <- convert(c(0,1,2,4,5,6),9,12)
#' hex3 <- convert(c(0,3,6,8,11,14),15,12)
#' hex_words <- rbind(asword(hex1), asword(hex2), asword(hex3))
#' rownames(hex_words) <- c("hex1", "hex2", "hex3")
#' c(colornum(hex1), colornum(hex2), colornum(hex3))
#' whichsvzeroes(hex1)
#' whichsvzeroes(hex2)
#' whichsvzeroes(hex3)
#' hex_words
#'
#' @export
whichsvzeroes <- function(set, ineqmat=NULL, edo=12, rounder=10) {
  signvec <- signvector(set, ineqmat, edo, rounder)
  return(which(signvec == 0))
}

#' @rdname whichsvzeroes
#' @export
countsvzeroes <- function(set, ineqmat=NULL, edo=12, rounder=10) {
  signveczeroes <- whichsvzeroes(set, ineqmat, edo, rounder)
  return(length(signveczeroes))
}

#' Distinguish different types of interval equalities for a scale
#'
#' Not all hyperplanes are made equal. Those which represent "formal tritone"
#' comparisons and those which are "exceptional" because they check a 
#' scale degree twice ("Modal Color Theory," 40-41) play a different role
#' in the structure of the hyperplane arrangement than the rest. This function
#' returns a "fingerprint" of a scale which is like [countsvzeroes()] but 
#' which counts the different types of hyperplane separately.
#'
#' @inheritParams signvector
#' @returns Numeric vector with 3 entries: the number of 'normal' hyerplanes
#'   the set lies on, the number of 'exceptional' hyperplanes, and the
#'   number of hyperplanes which compare a formal tritone to itself.
#' @examples
#' # Two hexachords on the same number of hyperplanes but with different fingerprints
#' hex1 <- c(0,1,3,5,8,9)
#' hex2 <- c(0,1,3,5,6,9)
#' countsvzeroes(hex1) == countsvzeroes(hex2)
#' svzero_fingerprint(hex1)
#' svzero_fingerprint(hex2)
#' # Compare brightnessgraph(hex1) and brightnessgraph(hex2)
#'
#' @export
svzero_fingerprint <- function(set, ineqmat=NULL, edo=12, rounder=10) {
  if (is.null(ineqmat)) {
    card <- length(set)
    ineqmat <- getineqmat(card)
  }

  count_twos <- function(vec) sum(abs(vec)==2)
  two_count <- apply(ineqmat, 1, count_twos)
  general_row_index <- which(two_count == 0)
  anchored_row_index <- which(two_count == 1)
  reflexive_tritone_index <- which(two_count == 2)

  general_ineqmat <- ineqmat[general_row_index, ]
  anchored_ineqmat <- ineqmat[anchored_row_index, ]
  reflexive_tritone_ineqmat <- ineqmat[reflexive_tritone_index, ]

  general_count <- countsvzeroes(set, ineqmat=general_ineqmat, edo=edo, rounder=rounder)
  anchored_count <- countsvzeroes(set, ineqmat=anchored_ineqmat, edo=edo, rounder=rounder)
  reflexive_tritone_count <- countsvzeroes(set, ineqmat=reflexive_tritone_ineqmat, edo=edo, rounder=rounder)

  return(c(general_count, anchored_count, reflexive_tritone_count))
}