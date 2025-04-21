#' Specific sizes corresponding to each generic interval
#'
#' As defined by Clough and Myerson 1986 
#' (<doi:10.1080/00029890.1986.11971924>),
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
  if (card < 2) { 
    return(list()) 
  }

  modes <- sim(set, edo)
  modes <- t(apply(modes, 1, sort))
  if (card == 2) { 
    return(list(fpunique(modes[2,], rounder=rounder))) 
  }
  uniques <- apply(modes[2:card,], 1, fpunique, rounder=rounder)
  if ("matrix" %in% class(uniques)) {
    uniques <- as.list(as.data.frame(uniques))
    names(uniques) <- NULL
  }
  uniques
}

#' @rdname intervalspectrum
#' @export
spectrumcount <- function(set, edo=12, rounder=10) sapply(intervalspectrum(set, edo, rounder), length)

#' Specific varieties of scalar subsets given a generic shape
#'
#' Considered mod 7, the traditional triads of a diatonic scale are all instances of the generic
#' shape (0,2,4). They come in three varieties: major, minor, and diminished. This function lists
#' the distinct varieties of any similarly defined generic shape which occur as subsets in some
#' specified scale (or larger set). 
#'
#' @inheritParams tnprime
#' @inheritParams fpunique
#' @param subsetdegrees Vector of integers indicating the generic shape to use, e.g. `c(0, 2, 4)` for
#'   tertian triads in a heptachord. Expected to begin with `0` and must have length > 1.
#' @param set The scale to find subsets of, as a numeric vector
#' @param unique Should each variety be listed only once? Defaults to `TRUE`. If `FALSE`, 
#'   each specific variety will be listed corresponding to how many times it occurs as a subset.
#' @returns A numeric matrix whose columns represent the specific varieties of the subset
#' 
#' @examples
#' c_major_scale <- c(0, 2, 4, 5, 7, 9, 11)
#' double_harmonic_scale <- c(0, 1, 4, 5, 7, 8, 11)
#' 
#' subset_varieties(c(0, 2, 4), c_major_scale)
#' subset_varieties(c(0, 2, 4), c_major_scale, unique=FALSE)
#' subset_varieties(c(0, 2, 4), double_harmonic_scale)
#' @export
subset_varieties <- function(subsetdegrees, set, unique=TRUE, edo=12, rounder=10) {
  card <- length(set)
  if (max(subsetdegrees) >= card || min(subsetdegrees) < 0) {
    stop("All subset degrees must be >= 0 and < the scale's cardinality")
  }
  if (length(subsetdegrees) < 2) {
    stop("Subsetdegrees must have length at least 2")
  }

  modes <- sim(set, edo=edo)
  subsetdegrees <- subsetdegrees + 1 #Because in music theory these are 0-indexed, but vectors are 1-indexed in R
  res <- modes[subsetdegrees,]

  if (unique == TRUE) {
    res <- fpunique(res, MARGIN=2, rounder=rounder)
  }

  res
}

#' Subset varieties for all subsets of a fixed size
#'
#' Applies [subset_varieties()] not just to a particular subset shape but to all possible subset shapes
#' given a fixed cardinality. For example, finds the specific varieties of *all* trichordal subsets of 
#' the major scale, not than just the varieties of the tonal triad. Comparable to [intervalspectrum()] 
#' but for subsets larger than dyads.
#' 
#' The parameter `simplify` lets you control whether to consider different "inversions" of a subset shape
#' independently. For instance, with `simplify=TRUE`, only root position triads (0, 2, 4) would be considered;
#' but with `simplify=FALSE`, the first inversion (0, 2, 5) and second inversion (0, 3, 5) subset shapes would 
#' also be displayed.
#'
#' @inheritParams subset_varieties
#' @param subsetcard Single integer defining the cardinality of subsets to consider
#' @param simplify Should "inversions" of a subset be ignored? Boolean, defaults to `TRUE`
#' @param mode String `"tn"` or `"tni"`. When defining subset shapes, use transposition or transposition 
#'   & inversion to reduce the number of shapes to consider? Defaults to `"tn"`.
#'
#' @returns A list whose length matches the number of distinct subset shapes (given the chosen options).
#'   Each entry of the list is a matrix displaying the varieties of some particular subset type.
#'
#' @examples
#' c_major_scale <- c(0, 2, 4, 5, 7, 9, 11)
#' subsetspectrum(c_major_scale, 3)
#' subsetspectrum(c_major_scale, 3, simplify=FALSE)
#' subsetspectrum(c_major_scale, 3, mode="tni") # Note the absence of a "0, 2, 3" matrix
#'
#' @export
subsetspectrum <- function(set, subsetcard, simplify=TRUE, mode="tn", edo=12, rounder=10) { 
  card <- length(set)
  comb <- utils::combn(card-1, subsetcard-1)
  comb <- rbind(rep(0, choose(card-1, subsetcard-1)), comb)

  if (mode=="tn") { 
    use <- tnprime 
  }
  if (mode=="tni") { 
    use <- primeform 
  }

  if (simplify == TRUE) {
    comb <- fpunique(apply(comb, 2, use, edo=card), MARGIN=2, rounder=rounder)
    if (!("matrix" %in% class(comb))) {
      comb <- as.matrix(comb)
    }
  }

  res <- apply(comb, 2, subset_varieties, set=set, edo=edo, rounder=rounder)

  if ("matrix" %in% class(res)) {
    res <- as.list(as.data.frame(res))

    for (i in 1:length(res) ) {
       res[[i]] <- matrix(res[[i]], nrow=subsetcard, ncol=(length(res[[i]])/subsetcard))
    }
  }

  names(res) <- apply(comb, 2, toString)
  res
}


#' Count the multiplicities of a subset-type's varieties 
#'
#' Given the varieties of a subset type returned by [subset_varieties()], `subset_multiplicities()`
#' counts how many times each one occurs in the scale. These are the multiplicities of the subsets
#' in the sense of [Clough and Myerson (1985)'s](https://www.jstor.org/stable/843615) 
#' result "structure yields multiplicity" for well-formed scales.
#'
#' @inheritParams subset_varieties
#' @inheritParams ifunc
#'
#' @returns Numeric vector whose names indicate the `k` varieties of the subset type and whose
#'   entries count how often each variety occurs.
#'
#' @examples
#' subset_multiplicities(c(0, 2, 4), sc(7, 35))
#' subset_multiplicities(c(0, 1, 4), sc(7, 35))
#' 
#' subset_multiplicities(c(0, 2, 4), j(dia))
#'
#' @export
subset_multiplicities <- function(subsetdegrees, set, edo=12, rounder=10, display_digits=2) {
  all_subsets <- subset_varieties(subsetdegrees=subsetdegrees, set=set, unique=FALSE, edo=edo, rounder=rounder)
  unique_subsets <- fpunique(all_subsets, rounder=rounder, MARGIN=2)

  single_variety <- !("matrix" %in% class(unique_subsets))
  if (single_variety) {
    res <- length(set)
    names(res) <- toString(round(unique_subsets, digits=display_digits))
    return(res)
  }

  variety_count <- table(apply(round(all_subsets, digits=(rounder-1)), 2, toString))
  res <- as.numeric(variety_count)

  variety_names <- sort(apply(round(unique_subsets, digits=display_digits), 2, paste0, collapse=", "))
  give_parens <- function(x) paste0("(",x,")",collapse="")
  variety_names <- sapply(variety_names, give_parens)
  names(res) <- variety_names

  res
}

