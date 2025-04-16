#' Reference numbers for scale structures
#'
#' As described on p. 28 of "Modal Color Theory," it's convenient to have a
#' systematic labeling system ("color numbers") to refer to the distinct colors
#' in the hyperplane arrangements. This serves a similar function as Forte's
#' set class numbers do in traditional pitch-class set theory. Color numbers
#' are defined with reference to a complete list of the possible sign vectors
#' for each cardinality, so they depend on the extensive prior computation
#' that is stored in the object `representative_signvectors`. (This is a large
#' file that cannot be included in the package musicMCT itself; it needs to be
#' downloaded separately, saved in your working directory, and loaded by entering
#' `representative_signvectors <- readRDS("representative_signvectors.rds")`.
#' Color numbers are currently only defined for scales with 7 or fewer notes.
#'
#' Note that the perfectly even "white" scale is number `0` for every cardinality
#' by definition.
#'
#' The function assumes that you don't need to be reminded of
#' the cardinality of the set you've entered.
#' That is, there's a color number 2 for every cardinality, so you can get
#' that value returned by entering a trichord, tetrachord, etc.
#'
#' @inheritParams tnprime
#' @inheritParams fpunique
#' @param ineqmat Defaults to `NULL`, in which case the function assumes
#'   you want to use the standard hyperplane arrangement of MCT. But you can
#'   enter a different matrix that contains normal vectors for any hyperplane
#'   arrangement in the same format as the standard ineqmats.
#' @param signvector_list A list of signvectors to use as the reference by 
#'   which `colornum` assigns a value. Defaults to `NULL` and will attempt to
#'   use `representative_signvectors`, which needs to be downloaded and assigned
#'   separately from the package musicMCT.
#'
#' @returns Single non-negative integer (the color number) if a `signvector_list`
#'   is specified or `representative_signvectors` is loaded; otherwise `NULL`
#' @examples
#' colornum(edoo(5))
#' colornum(c(0,3,7))
#' colornum(c(0,2,7))
#' colornum(c(0,1,3,7))
#' colornum(c(0,1,3,6,10,15,21), edo=33)
#' colornum(c(0,2,4,5,7,9,11))
#' @export
colornum <- function(set, ineqmat=NULL, signvector_list=NULL, edo=12, rounder=10) {
  if (evenness(set, edo) < 10^(-rounder) ) { 
    return(0) 
  }

  if (is.null(signvector_list)) {
    if (exists("representative_signvectors")) {
      signvector_list <- get("representative_signvectors")
    } else {
        return(NULL)
    }
  }

  card <- length(set)
  signvec <- toString(signvector(set, ineqmat, edo, rounder))

  which(signvector_list[[card]]==signvec)
}