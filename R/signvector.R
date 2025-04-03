#' Locate a scale relative to a hyperplane arrangement
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
#' just_dia <- c(0, musicMCT:::just_wt, musicMCT:::just_maj3, musicMCT:::just_p4, 
#'   musicMCT:::just_p5, 12-musicMCT:::just_min3, 12-musicMCT:::just_st)
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