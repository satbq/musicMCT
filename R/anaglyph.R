#' Define hyperplanes for cross-type voice leadings
#'
#' @description
#' Voice leadings between members of a single set class are 
#' well characterized by the Modal Color Theory arrangements
#' of [makeineqmat()]. Those arrangements do not tell the whole
#' story for relationships between inequivalent sets. (For instance,
#' under what circumstances are two [brightnessgraph()] structures
#' equivalent when `set` and `goal` belong to different set classes?)
#' Such relationships are described by the "anaglyph" arrangements
#' produced by this function. (The name for the arrangements alludes
#' to those 20th-century 3D movie glasses which produce a stereoscopic
#' effect by using lenses of different colors for each eye. Like those
#' glasses, the anaglyph arrangements "see" two scalar colors at once.)
#'
#' @details
#' Note that, unlike for most other hyperplane arrangements, for
#' anaglyph arrangements `card` is only half the size of the data you're
#' working with, since anaglyph arrangements compare *two* sets of size 
#' `card`. In general, when useing anaglyph ineqmats with other functions,
#' such as [signvector()] or [howfree()], you should enter the two sets
#' to be compared as a single vector, i.e. `c(set, goal)`. See the use of
#' [howfree()] in the example.
#'
#' @param card Integer: the cardinality of the two sets to be compared.
#'
#' @returns A matrix with `2*card+1` columns and k rows, where
#'  k is  either 4 times an entry of A050509 in the OEIS if `card` is even,
#'  or an entry of A033594 if `card` is odd.
#'
#' @examples
#' min7 <- c(0, 3, 7, 10)
#' maj7 <- c(0, 4, 7, 11)
#' just_min7 <- j(1, m3, 5, m7)
#' just_maj7 <- j(1, 3, 5, 7)
#' 
#' # The 12tet and just pairs have the same anaglyph signvector:
#' anaglyph_tetrachords <- make_anaglyph_ineqmat(4)
#' signvector(c(min7, maj7), ineqmat=anaglyph_tetrachords)
#' signvector(c(just_min7, just_maj7), ineqmat=anaglyph_tetrachords)
#'
#' # They therefore have equivalent brightness graphs:
#' brightnessgraph(min7, maj7)
#' brightnessgraph(just_min7, just_maj7)
#'
#' # The pair is able to vary along two dimensions in anaglyph space:
#' howfree(c(min7, maj7), ineqmat="anaglyph")
#'
#' @export
make_anaglyph_ineqmat <- function(card) {
  colorful_mat <- getineqmat(card)
  if (card==1) {
    return(colorful_mat)
  }
  numrows <- dim(colorful_mat)[1]
  zeroes <- matrix(0, nrow=numrows, ncol=card)

  first_block <- colorful_mat[, 1:card]
  last_block <- colorful_mat[, card+1]
  if (card==2) {
    first_block <- t(first_block)
    last_block <- matrix(-1, nrow=1)
  }

  rows_1 <- cbind(first_block, zeroes, last_block)
  rows_2 <-  cbind(zeroes, first_block, last_block)

  generic_intervals <- 1:floor(card/2)
  roots <- 1:card
  comp_row_options <- expand.grid(roots, roots, generic_intervals)

  zero_row <- rep(0, 2*card + 1)

  make_comparison_row <- function(vec) {
    new_row <- zero_row
    firstroot <- vec[1]
    secondroot <- vec[2]
    genericival <- vec[3]

    new_row[firstroot] <- -1
    new_row[secondroot + card] <- 1
    new_row[quasimod(firstroot + genericival, card=card)] <- 1
    new_row[quasimod(secondroot + genericival, card=card) + card] <- -1

    w <- ((firstroot + genericival) > card) - ((secondroot + genericival) > card)
    new_row[(2*card) + 1] <- w

    new_row
  }

  comparison_rows <- t(apply(comp_row_options, 1, make_comparison_row))

  rowSign <- function(row) row * -1 * sign(row[which(row!=0)])[1]
  comparison_rows <- t(apply(comparison_rows, 1, rowSign))

  res <- rbind(rows_1, rows_2, comparison_rows)
  res <- res[!duplicated(res, MARGIN=1),]
  dimnames(res) <- NULL

  res
}

#' Are regularities within or between sets in a pair?
#'
#' As for other hyperplane arrangements, it is useful to consider the
#' number of entries which equal 0 in an anaglyph signvector. However,
#' such entries can represent three different types of regularity:
#' regularity within the first set, regularity within the second set, or
#' regularity in the comparison between them. This function distinguishes
#' between those three types of hyperplanes.
#'
#' @param set A vector of even length representing a pair of sets
#' @inheritParams tnprime
#'
#' @returns A vector with three entries, representing regularities in the 
#'  first set, regularities in the second set, and regularities between them.
#'
#' @examples
#' maj <- c(0, 4, 7)
#' sus2 <- c(0, 2, 7)
#' anazero_fingerprint(c(maj, sus2))
#' 
#' # The first zero shows that the major triad has no regularities.
#' # This is equivalent to:
#' countsvzeroes(maj)
#'
#' # The second zero shows that the sus2 trichord has 1 regularity.
#' # This is equivalent to:
#' countsvzeroes(sus2)
#'
#' # The final zero shows that the major triad's perfect fifth
#' # equals the size of the *two* perfect fifths in the sus2 trichord.
#' # We can visualize the whole set of relationships using a brightness
#' # graph:
#' brightnessgraph(maj, sus2)
#'
#' @seealso [make_anaglyph_ineqmat()], [svzero_fingerprint()]
#' @export
anazero_fingerprint <- function(set, edo=12, rounder=10) {
  card <- length(set)/2
  mct_size <- dim(getineqmat(card))[1]
  anaineq <- make_anaglyph_ineqmat(card)
  ana_size <- dim(anaineq)[1]
  A <- anaineq[1:mct_size, ]
  B <- anaineq[(mct_size+1):(2*mct_size), ]
  C <- anaineq[(2*mct_size + 1 ):ana_size, ]
  c(countsvzeroes(set, ineqmat=A, edo=edo, rounder=rounder),
    countsvzeroes(set, ineqmat=B, edo=edo, rounder=rounder),
    countsvzeroes(set, ineqmat=C, edo=edo, rounder=rounder))
}

