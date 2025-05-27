#' Relative motions in a voice leading
#'
#' Does the main computation to determine voice-leading brightness comparisons.
#'
#' @inheritParams tnprime
#' @param ref A vector the same length as `set` to serve as the origin of a voice leading.
#' 
#' @returns A value of `-1`, `0`, or `1` whose meaning is the same as the entries of the 
#'   matrix returned by brightness_comparisons().
#'
#' @noRd
modecompare <- function(set, ref, rounder=10) sum(unique(sign(round(set - ref, rounder))))

#' Voice-leading brightness relationships for a scale's modes
#'
#' The essential step in creating the brightness graph of a scale's modes
#' is to compute the pairwise comparisons between all the modes. Which ones are strictly
#' brighter than others according to "voice-leading brightness" (see "Modal Color Theory," 6-7)?
#' This function makes those pairwise comparisons in a manner that's useful for more computation.
#' If you want a human-readable version of the same information, you should use [brightnessgraph()]
#' instead.
#'
#' Note that the returned value shows all voice-leading brightness comparisons, not just 
#' the transitive reduction of those comparisons. (That is, dorian is shown as darker than ionian
#' even though mixolydian intervenes in the brightness graph.)
#'
#' @inheritParams tnprime
#' @inheritParams fpunique
#' @returns An n-by-n matrix where n is the size of the scale. Row i represents mode i of the scale
#'   in comparison to all 7 modes. If the entry in row i, column j is `-1`, then mode i is
#'   "voice-leading darker" than mode j. If `1`, mode i is "voice-leading brighter". If 0, mode i
#'   is neither brighter nor darker, either because contrary motion is involved or because mode i
#'   is identical to mode j. (Entries on the principal diagonal are always 0.)
#'
#' @examples
#' # Because the diatonic scale, sc7-35, is non-degenerate well-formed, the only
#' # 0 entries should be on its diagonal.
#' brightness_comparisons(sc(7,35))
#' 
#' mystic_chord <- sc(6,34)
#' colSums(sim(mystic_chord)) # The sum brightnesses of the mystic chord's 6 modes
#' brightness_comparisons(mystic_chord) 
#' # Almost all 0s because very few mode pairs are comparable.
#' # That's because nearly all modes have the same sum, which means they have sum-brightness
#' # ties, and voice-leading brightness can't break a sum-brightness tie.
#' # (See "Modal Color Theory," 7.)
#' 
#' @export
brightness_comparisons <- function(set, edo=12, rounder=10) {
  modes <- sim(set, edo)
  modes <- split(modes, col(modes))
  outer(modes, modes, Vectorize(modecompare), rounder=rounder)
}

#' The brightness ratio
#'
#' @description
#' Section 3.3 of "Modal Color Theory" describes a "brightness ratio" which characterizes
#' the modes of a scale in terms of how well "sum brightness" acts as a proxy for "voice-leading
#' brightness." Scales with a brightness ratio less than 1 are pretty well behaved from this
#' perspective, while ones with a brightness ratio greater than 1 are poorly behaved. When the
#' brightness ratio is 0, sum brightness and voice-leading brightness give exactly the same
#' results. (This can happen for sets on two extremes: those like the diatonic scale which are
#' well formed and those like the Weitzmann scales, which differ from "white" in only one
#' scale degree.) 
#'
#' I wish I had come up with a more descriptive name than "brightness ratio" for this 
#' property, because it's not really a ratio of brightness in the sense you might expect (i.e.
#' "this scale is 20% bright"). Rather, it's a ratio of two brightness-related properties,
#' `delta` and `eps`. "Modal Color Theory" (p. 20) offers definitions of these. Delta is
#' "the largest sum difference between (voice-leading) incomparable modes," with value 0 by 
#' definition if all of the modes are comparable. ("This, in a sense, is a measure of how badly
#' voice-leading brightness breaks down from the perspective of sum brightness.") **Eps**ilon
#' "represents the smallest sum difference between non-identical but comparable modes."
#' This is harder to give an intuitive gloss on, but my attempt in "MCT" was "Essentially,
#' epsilon measures the finest distinction that voice-leading brightness is capable of
#' parsing."
#' 
#' The brightness ratio (`ratio`) itself is simply delta divided by epsilon.
#'
#' @inheritParams tnprime
#' @inheritParams fpunique
#' @returns Single non-negative numeric value
#'
#' @examples
#' harmonic_minor <- c(0,2,3,5,7,8,11)
#' hypersaturated_harmonic_minor <- saturate(2, harmonic_minor)
#' c(delta(harmonic_minor), eps(harmonic_minor))
#' c(delta(hypersaturated_harmonic_minor), eps(hypersaturated_harmonic_minor))
#' 
#' # Delta and epsilon depend on the precise scale, but ratio() is constant on a hue
#' ratio(harmonic_minor)
#' ratio(hypersaturated_harmonic_minor)
#'
#' #### Sort all 12tet heptachords by brightness ratio
#' heptas12 <- unique(apply(combn(12,7),2,primeform),MARGIN=2)
#' hepta_ratios <- apply(heptas12, 2, ratio)
#' sorted_heptas <- heptas12[,order(hepta_ratios)]
#' colnames(sorted_heptas) <- apply(sorted_heptas,2,fortenum)
#' sorted_heptas
#' 
#' #### Compare evenness to ratio for 12tet hetpachords
#' plot(apply(heptas12, 2, evenness), hepta_ratios, xlab="Evenness", ylab="Brightness Ratio")
#'
#' @export
eps <- function(set, edo=12, rounder=10) {
  if (length(set) < 2) {
    return(NA)
  }

  modes <- t(sim(set, edo))
  chart <- brightness_comparisons(set, edo, rounder)*brightness_comparisons(set, edo, rounder)
  diffs <- outer(rowSums(modes), rowSums(modes),'-')
  result <- chart * diffs

  min(result[result > 0])
}

#' @rdname eps
#' @export
delta <- function(set, edo=12, rounder=10) {
  if (length(set) < 2) {
    return(NA)
  }

  modes <- t(sim(set, edo))
  chart <- brightness_comparisons(set, edo, rounder)*brightness_comparisons(set, edo, rounder)
  diag(chart) <- -1
  chart <- (chart + 1)%%2

  diffs <- outer(rowSums(modes),rowSums(modes),'-')
  result <- chart * diffs

  max(result)
}

#' @rdname eps
#' @export
ratio <- function(set, edo=12, rounder=10) {
  if (length(set) < 2) {
    return(NA)
  }

  delta(set, edo, rounder)/eps(set, edo, rounder)
}