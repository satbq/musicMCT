#' Do two sign vectors represent adjacent colors?
#'
#' As "Modal Color Theory" (pp. 31ff.) describes, it can be useful to know
#' whether two colors are adjacent to each other in the MCT space. That is,
#' can one scalar color be continuously modified until it becomes the other,
#' without crossing through any third color? For instance, the 5-limit just
#' diatonic scale is a two-dimensional color that is adjacent to the 1-d
#' line of meantone diatonic scales. This means, in some sense, that the meantone
#' structure is a good approximation of the 5-limit just structure.
#'
#' @param signvecX,signvecY A pair of sign vectors to be compared. Note that
#'   these must be sign vectors, not scales themselves.
#'
#' @returns Integer: `0` if the sign vectors represent the same color, 
#'   `1` if they are adjacent, and `-1` if they are neither adjacent nor 
#'   identical.
#'
#' @examples
#' meantone_major_sv <- signvector(c(0,2,4,5,7,9,11))
#' meantone_dorian_sv <- signvector(c(0,2,3,5,7,9,10))
#' just_major <- 12 * log2(c(1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8))
#' just_dorian <- sim(just_major)[,2] 
#' just_major_sv <- signvector(just_major)
#' just_dorian_sv <- signvector(just_dorian)
#' 
#' comparesignvecs(meantone_major_sv, just_major_sv)
#' comparesignvecs(meantone_dorian_sv, just_major_sv)
#' comparesignvecs(meantone_dorian_sv, just_dorian_sv)
#'
#' @export
comparesignvecs <- function(signvecX, signvecY) {
  # Are the signvecs identical?
  if ( isTRUE(all.equal(signvecX,signvecY)) ) { return(0) }

  # Initial sorting based on which hyperplanes the scales lie on.
  signvec.zeroes.x <- which(signvecX == 0)
  signvec.zeroes.y <- which(signvecY == 0)

  numzeroes.x <- length(signvec.zeroes.x)
  numzeroes.y <- length(signvec.zeroes.y)

  # Distinct colors can't be adjacent if lie on same number of hyperplanes.
  if (numzeroes.x == numzeroes.y) {
    return(-1)
  }

  # Which scale lies on more hyperplanes?
  if (numzeroes.x > numzeroes.y) {
    upper <- signvecX
    upper.zeroes <- signvec.zeroes.x
    lower <- signvecY
    lower.zeroes <- signvec.zeroes.y
  }

  if (numzeroes.x < numzeroes.y) {
    upper <- signvecY
    upper.zeroes <- signvec.zeroes.y
    lower <- signvecX
    lower.zeroes <- signvec.zeroes.x
  }

  # To be adjacent, a freer region must lie on all the hyperplanes of the stricter region.
  check.zeroes <- lower.zeroes %in% upper.zeroes
  if ( prod(check.zeroes) == 0 ) {
    return(-1)
  }

  # We've weeded out the obvious cases based on scales lying **on** hyperplanes.
  # Now we have to check the hyperplanes that the scales lie above/below.
  svdiff <- signvecX - signvecY

  # If both scales lie off a hyperplane, to be adjacent they should lie in the same direction (diff of 0).
  # But the freer region can step "up" or "down" off a hyperplane of the stricter region (diff of +1 or -1).
  # So what we need to catch are cases where one scale lies above & the other lies below a hyerplane,
  # which shows up as a difference of +2 or -2 in the svdiff.
  difftypes <- unique(abs(svdiff))

  # Want to return -1 if +/-2 is present, else 1 if +/-1 is present, and 0 if identical.
  index <- max(difftypes)
  res <- ((2*index)%%3)-index
  return(res)
}
