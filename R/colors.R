#' Orbit of a scale under symmetries of hyperplane arrangement
#'
#' Given an input scale, return a "palette" of related scalar colors. All the returned
#' scales are the image of the input under some [ineqsym()].
#'
#' @inheritParams tnprime
#' @param include_involution Should involutional symmetry be included in the
#'   applied transformation group? Defaults to `TRUE`.
#'
#' @returns A matrix whose columns represent the colors in `set`'s palette.
#'
#' @examples
#' # The palette of a minor triad is all inversions of major and minor:
#' minor_triad <- c(0, 3, 7)
#' scale_palette(minor_triad)
#'
#' # But 12edo is a little too convenient. The palette of the just minor triad
#' # involves some less-consonant intervals:
#' just_minor <- j(1, m3, 5)
#' scale_palette(just_minor)
#'
#' # The palette of the diatonic scale includes all 42 well-formed heptachord colors:
#' dia_palette <- scale_palette(sc(7, 35))
#' dim(dia_palette)
#' table(apply(dia_palette, 2, iswellformed))
#'
#' @export
scale_palette <- function(set, include_involution=TRUE, edo=12, rounder=10) {
  tiny <- 10^(-1 * rounder)
  if (evenness(set, edo=edo) < tiny) {
    return(matrix(set, ncol=1))
  }

  card <- length(set)
  units <- units_mod(card)

  basis_colors <- sapply(units, ineqsym, set=set, b=0, involution=FALSE, edo=edo)
  basis_sims <- matrix(apply(basis_colors, 2, sim, edo=edo), nrow=card)

  if (include_involution) {
    involutions <- apply(basis_colors, 2, saturate, r=-1, edo=edo)
    involution_sims <- matrix(apply(involutions, 2, sim, edo=edo), nrow=card)
    all_colors <- cbind(basis_sims, involution_sims)
  } else {
    all_colors <- basis_sims
  }

  all_svs <- apply(all_colors, 2, signvector, edo=edo)
  duplicated_svs <- which(duplicated(all_svs, MARGIN=2))

  if (length(duplicated_svs) == 0) {
    return(all_colors)
  }
  all_colors[, -duplicated_svs]
}

