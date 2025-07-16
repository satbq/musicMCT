#' Rearrange sim() as a vector ordered by generic interval size
#'
#' Internal function for identifying rotherberg propriety. Sorts a 
#' scalar interval matrix first internally to each generic interval,
#' then chains all the generic intervals together in a long vector.
#'
#' @inheritParams tnprime
#'
#' @returns Numeric vector of size length(set)^2
#'
#' @noRd
get_adjacent_sizes <- function(set, edo=12) {
  sorted_generic_intervals <- apply(sim(set, edo=edo), 1, sort)
  all_intervals <- as.numeric(sorted_generic_intervals)
  diff(all_intervals)
}

#' Rothenberg propriety
#'
#' Rothenberg (1978) <doi:10.1007/BF01768477> identifies a potentially 
#' desirable trait for scales which he calls "propriety." Loosely speaking,
#' a scale is proper if its specific intervals are well sorted in terms of the 
#' generic intervals they belong to. A scale is *strictly* proper if, given
#' two generic sizes g and h such that g < h, every specific size corresponding
#' to g is smaller than every specific size corresponding to h. A scale if
#' improper if any specific size of g is larger than any specific size of h.
#' An *ambiguity* occurs if any size of g equals any size of h: scales with
#' ambiguities are weakly but not strictly proper.
#'
#' @inheritParams tnprime
#' @param strict Boolean: should only strictly proper scales pass?
#'
#' @returns Boolean which answers whether the input satisfies the property named by the 
#'   function
#' @seealso
#' [make_roth_ineqmat()] creates an `ineqmat` for a hyperplane arrangement
#'   that lets you explore propriety-related issues in finer detail.
#'
#' @examples
#' c_major <- c(0, 2, 4, 5, 7, 9, 11)
#' has_contradiction(c_major)
#' strictly_proper(c_major)
#' isproper(c_major)
#' isproper(c_major, strict=TRUE)
#'
#' isproper(j(dia), strict=TRUE)
#'
#' pythagorean_diatonic <- sort(((0:6)*z(3/2))%%12)
#' isproper(pythagorean_diatonic)
#' has_contradiction(pythagorean_diatonic)
#'
#' @export
isproper <- function(set, strict=FALSE, edo=12, rounder=10) {
  no_contradictions <- !has_contradiction(set, edo, rounder)
  is_strict <- strictly_proper(set, edo, rounder)

  if (strict==FALSE) {
    return(no_contradictions)
  }

  no_contradictions && is_strict
}

#' @rdname isproper
#' @export
has_contradiction <- function(set, edo=12, rounder=10) {
  tiny <- 10^(-1*rounder)
  adjacent_sizes <- get_adjacent_sizes(set, edo)

  !as.logical(prod(adjacent_sizes > -1 * tiny))
}

#' @rdname isproper
#' @export
strictly_proper <- function(set, edo=12, rounder=10) {
  tiny <- 10^(-1*rounder)
  card <- length(set)
  adjacent_sizes <- get_adjacent_sizes(set, edo)

  crossing_between_generics <- ((1:(card-1))*card)
  is_strict <- adjacent_sizes[crossing_between_generics] > tiny
  as.logical(prod(is_strict))
}


#' Define hyperplanes for Rothenberg arrangements
#'
#' Although the Rothenberg propriety of a single scale can be computed directly with [isproper()],
#' propriety is a scalar feature (like modal "color") which is defined by a scale's position in 
#' the geometry of continuous pc-set space. That is, propriety, contradictions, and ambiguities are
#' all determined by a scale's relationship to a hyperplane arrangement, but the arrangements which
#' define these properties are different from the ones of Modal Color Theory. `make_roth_ineqmat()`
#' creates the `ineqmats` needed to study those arrangements, similar to what [makeineqmat()] does 
#' for MCT arrangements. `make_rosy_ineqmat()` creates the combination of Rothenberg and MCT arrangements.
#' (The name puns on the "Roth" of Rothenberg meaning "red," lending a reddish
#' or rosy tint to the "colors" of the MCT arrangement.)
#'
#' Each row of a Rothenberg `ineqmat` represents a hyperplane, just like the rows produced by
#' [makeineqmat()]. The rows are normalized so that their first non-zero entry is either `1` or `-1`,
#' and their orientations are assigned so that a strictly proper set will return only `-1`s for its
#' sign vector relative to the Rothenberg arrangement. A `0` in a Rothenberg sign vector represents
#' an ambiguity. Note that the Rothenberg arrangements are never "central," which means that the 
#' hyperplanes do *not* all intersect at the perfectly even scale. (It is clear that they must not, 
#' because perfectly even scales have no ambiguities.) These arrangements also grow in complexity
#' much faster than the MCT arrangements do: for tetrachords, MCT arrangements have 8 hyperplanes while
#' Rothenberg arrangements have 22. For heptachords, those numbers increase to 42 and 259, respectively.
#' Thus, this function runs slowly when called on cardinalities of only modest size (e.g. 12-24).
#'
#' @inheritParams makeineqmat
#'
#' @returns A matrix with `card+1` columns and k rows, where k is the number of hyperplanes
#'   in the arrangement.
#'
#' @examples
#' c_major <- c(0, 2, 4, 5, 7, 9, 11)
#' hepta_roth_ineqmat <- make_roth_ineqmat(7)
#' isproper(c_major)
#' cmaj_roth_sv <- signvector(c_major, ineqmat=hepta_roth_ineqmat)
#' table(cmaj_roth_sv)
#' hepta_roth_ineqmat[which(cmaj_roth_sv==0),] 
#' # This reveals that c_major has one ambiguity, which results from
#' # the interval from 4 to 7 being exactly half an octave.
#'
#' @export
make_roth_ineqmat <- function(card) {

  quasimod <- function(x) {
    normal_mod <- x %% card
    if (normal_mod == 0) {
      return(card)
    }
    normal_mod
  }

  roth_row <- function(firstroot, secondroot, g1, g2) {
    row <- rep(0, card+1)
    firstroot <- quasimod(firstroot+1)
    secondroot <- quasimod(secondroot+1)

    fr_target <- quasimod(firstroot + g1)
    sr_target <- quasimod(secondroot + g2)

    firstroot_indices <- c(firstroot, fr_target)
    secondroot_indices <- c(secondroot, sr_target)

    firstroot_vec <- c(-1, 1)
    secondroot_vec <- -1 * firstroot_vec

    if (fr_target < firstroot) {
      firstroot_indices <- c(firstroot_indices, card+1)
      firstroot_vec <- c(firstroot_vec, 1)
    }

    if (sr_target < secondroot) {
      secondroot_indices <- c(secondroot_indices, card+1)
      secondroot_vec <- c(secondroot_vec, -1)
    }

    temprow_small_side <- row
    temprow_large_side <- row
   
    temprow_small_side[firstroot_indices] <- firstroot_vec
    temprow_large_side[secondroot_indices] <- secondroot_vec
    
    row <- temprow_small_side + temprow_large_side
    first_entry <- row[which(row != 0)[1]]
    
    (row / first_entry) * sign(first_entry)
  }

  roots <- 0:(card-1)
  intervals <- 1:(card-1)
  combinations <- expand.grid(roots, roots, intervals, intervals)
  combinations <- combinations[combinations[,3] < combinations[,4],]

  firstroots <- combinations[,1]
  secondroots <- combinations[,2]
  g1s <- combinations[,3]
  g2s <- combinations[,4]

  res <- t(mapply(roth_row, firstroot=firstroots, secondroot=secondroots, g1=g1s, g2=g2s))
 
  unique(res, MARGIN=1)
}


#' @rdname make_roth_ineqmat
#' @export
make_rosy_ineqmat <- function(card) {
  rbind(getineqmat(card), make_roth_ineqmat(card))
}
