affected_generic_intervals <- function(row, card) {
    row <- utils::head(row, -1) # Ignore last column, which doesn't affect generic intervals.
    negative_positions <- which(row < 0)
    postitive_positions <- which(row > 0)
    reference_pitch <- negative_positions[1]
    res <- postitive_positions - reference_pitch
    res <- abs(sapply(res, signed_interval_class, edo=card))
    sort(unique(res))
}

#' Which hyperplanes affect a given generic interval?
#'
#' Given an `ineqmat` (i.e. a matrix representing a hyperplane arrangement),
#' this function tells us which of those hyperplanes affect a specific generic
#' interval size. (One specific application of this is is [step_signvector()],
#' which pays attention only to the comparisons between step sizes in a scale.)
#'
#' @param generic_intervals A vector of one or more integers representing
#'   generic intervals that can be found within the scale. Unisons are `0`,
#'   generic steps are `1`, etc.
#' @param ineqmat The matrix of hyperplane normal vectors that you want to search.
#'
#' @returns Vector of integers indicating the relevant hyperplanes from `ineqmat`
#' @examples
#' heptachord_ineqmat <- getineqmat(7)
#' heptachord_step_comparisons <- get_relevant_rows(1, heptachord_ineqmat)
#'
#' # Create an ineqmat that attends only to the quality of (024) trichordal
#' # subsets in a heptachord.
#' heptachord_triads <- get_relevant_rows(c(0, 2, 4), heptachord_ineqmat)
#' triads_in_7_ineqmat <- heptachord_ineqmat[heptachord_triads,]
#' 
#' # Now, the following two heptachords have different colors
#' # but the same pattern of (024) trichordal subsets, so their signvector
#' # using triads_in_7_ineqmat is identical:
#' heptachord_1 <- convert(c(0, 1, 3, 6, 8, 12, 13), 17, 12)
#' heptachord_2 <- convert(c(0, 1, 3, 5, 7, 10, 11), 14, 12)
#' colornum(heptachord_1) == colornum(heptachord_2)
#' sv_1 <- signvector(heptachord_1, ineqmat=triads_in_7_ineqmat)
#' sv_2 <- signvector(heptachord_2, ineqmat=triads_in_7_ineqmat)
#' isTRUE(all.equal(sv_1, sv_2))
#' subset_varieties(c(0, 2, 4), heptachord_1, unique=FALSE)
#' subset_varieties(c(0, 2, 4), heptachord_2, unique=FALSE)
#' # Both have identical qualities for triads on scale degree 3, 5, and 7,
#' # which you can see by comparing columns 3, 5, and 7 in the two
#' # matrices above.
#' 
#' @export
get_relevant_rows <- function(generic_intervals, ineqmat) {
  generic_intervals <- generic_intervals[generic_intervals > 0]
  card <- length(ineqmat[1,]) - 1
  generic_intervals <- abs(sapply(generic_intervals, signed_interval_class, edo=card))

  row_generics <- apply(ineqmat, 1, affected_generic_intervals, card=card)
  check_row <- function(row, generic_interval) generic_interval %in% row
  check_generic <- function(generic_interval) {
    list_of_checks <- lapply(row_generics, check_row, generic_interval=generic_interval)
    return(which(unlist(list_of_checks)==TRUE))
  }

  res <- sapply(generic_intervals, check_generic)
  sort(unique(as.vector(res)))
}