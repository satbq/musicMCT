#' Twin set in the Z-relation (Z mate)
#'
#' For the standard 12edo sets of Fortean pitch-class set theory,
#' given one pitch-class set, finds a set class whose interval-class
#' vector is the same as the input set but which does not include
#' the input set. Not all set classes participate in the Z-relation,
#' in which case the function returns `NA`.
#'
#' These values are hard-coded from Forte's list for non-hexachords and only work for subsets
#' of the standard chromatic scale. `zmate()` doesn't even give you an option
#' to work in a different `edo`. If it were to do so, I can't see a better solution
#' than calculating all the set classes of a given cardinality on the spot,
#' which can be slow for higher `edo`s.
#'
#' @inheritParams tnprime
#' @returns `NA` or numeric vector of same length as `set`
#' @examples
#' zmate(c(0, 4, 7))
#' zmate(c(0, 1, 4, 6))
#' @export
zmate <- function(set) {
  set <- unique(set)
  card <- length(set)
  num <- fortenum(set)

  if (card == 6) {
    complement <- sc_comp(set)
    if (num == fortenum(complement)) { 
      NA 
    } else {
      sc_comp(set)
    }
  } else {

    if (card > 6) num <- fortenum(sc_comp(set))

    hardcoded_values        <- c(   29,     15,     36,     12,     18,     38,     17,     37)
    names(hardcoded_values) <- c("4-15", "4-29", "5-12", "5-36", "5-38", "5-18", "5-37", "5-17")

    if (num %in% names(hardcoded_values)) {
      sc(card, hardcoded_values[num])
    } else {
      NA
    }
  }
}