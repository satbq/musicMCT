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


#' Primary colors
#'
#' In traditional pitch-class set theory, concepts like normal order and
#' [primeform()] establish a canonical representative for each equivalence
#' class of pitch-class sets. It's useful to do something similar in MCT
#' as well: given a family of scales, such as the collection of modes or a 
#' [scale_palette()], we can define the "primary color" of the family as the
#' one that comes first when the scales' sign vectors are ordered lexicographically.
#' `primary_hue()` uses [ineqsym()] to return a specific representative of
#' the primary color which belongs to the same palette of hues as the input.
#' Because `primary_hue()` focuses on hues rather than colors, it may not 
#' highlight the fact that two scales have the same primary color. Thus, for
#' information about broader families, `primary_colornum()` returns the color
#' number of the primary color, `primary_signvector()` returns the signvector,
#' and `primary_color()` itself uses [quantize_color()] to return a consistent
#' representative of each color.
#'
#' @inheritParams tnprime
#' @param type How broad of an equivalence class should be considered? May
#'   be one of three options:
#'   * "all", the default, uses the full range of [scale_palette()] relationships
#'   * "half_palette" uses [scale_palette()] with `include_involution=FALSE`
#'   * "modes" returns only the n modes of `set`
#' @inheritParams quantize_color
#' @param ... Arguments to be passed to `primary_hue()`
#' 
#' @returns A numeric vector representing a scale for `primary_hue()`; a
#'   single integer for `primary_colornum()`; a [signvector()] for
#'   `primary_signvector()`; and a list like [quantize_color()] for
#'   `primary_color()`.
#'
#' @examples
#' major_64 <- c(0, 5, 9)
#' primary_hue(major_64)
#' primary_hue(major_64, type="modes")
#'
#' viennese_trichord <- c(0, 6, 11)
#' # Same primary color as major_64:
#' apply(cbind(major_64, viennese_trichord), 2, primary_signvector)
#' 
#' # But a different primary hue:
#' primary_hue(viennese_trichord)
#'
#' # Only works with representative_signvectors loaded:
#' primary_colornum(major_64) == primary_colornum(viennese_trichord)
#'
#' primary_color(major_64)
#' primary_color(viennese_trichord)
#'
#' @export
primary_hue <- function(set, 
                        type=c("all", "half_palette", "modes"), 
                        ineqmat=NULL,
                        edo=12,
                        rounder=10) {
  card <- length(set)
  if (is.null(ineqmat)) ineqmat <- getineqmat(card)

  type <- match.arg(type)
  colors_to_try <- switch(type,
                          modes = sim(set, edo=edo),
                          half_palette = scale_palette(set, 
                                                       include_involution=FALSE, 
                                                       edo=edo,
                                                       rounder=rounder),
                          all = scale_palette(set, edo=edo, rounder=rounder))
  signvecs <- apply(colors_to_try, 2, signvector, ineqmat=ineqmat, edo=edo, rounder=rounder)

  if (!inherits(signvecs, "matrix")) {
    return(as.numeric(colors_to_try))
  }

  string_svs <- apply(signvecs, 2, toString)

  colors_to_try[, order(string_svs)[1]]
}

#' @rdname primary_hue
#' @export
primary_colornum <- function(set, type="all", ...) colornum(primary_hue(set, type=type, ...), ...)

#' @rdname primary_hue
#' @export
primary_signvector <- function(set, type="all", ...) signvector(primary_hue(set, type=type, ...), ...)

#' @rdname primary_hue
#' @export
primary_color <- function(set, type="all", nmax=12, reconvert=FALSE, ...) {
  hue <- primary_hue(set, type=type, ...)
  quantize_color(hue, nmax=nmax, reconvert=reconvert, ...)
}

