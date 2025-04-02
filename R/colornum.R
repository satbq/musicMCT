#' Color number
#'
#' As described on p. 28 of "Modal Color Theory," it's convenient to have a
#' systematic labeling system (color numbers) to refer to the distinct colors
#' in the hyperplane arrangements. This serves a similar function as Forte's
#' set class numbers do in traditional pitch-class set theory. Color numbers
#' are defined with reference to a complete list of the possible sign vectors
#' for each cardinality, so they depend on the extensive prior computation
#' that is stored in the object `representative_signvectors`. Color numbers
#' are currently only defined for scales with 7 or fewer notes.
#'
#' Note that the perfectly even "white" scale is number `0` for every cardinality
#' by definition.
#'
#' The function assumes that you don't need to be reminded of
#" the cardinality of the set you've entered.
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
#'   which `colornum` assigns a value; defaults to `representative_signvectors`.
#'   You would only change this if you have defined your own hyperplane 
#'   arrangement and cataloged all its faces; if so, your signvector_list
#'   should have the same internal structure as representative_signvectors.
#'
#' @returns Single non-negative integer (the color number)
#' @examples
#' colornum(edoo(5))
#' colornum(c(0,3,7))
#' colornum(c(0,2,7))
#' colornum(c(0,1,3,7))
#' colornum(c(0,1,3,6,10,15,21), edo=33)
#' colornum(c(0,2,4,5,7,9,11))
#' @export
colornum <- function(set, ineqmat=NULL, edo=12, rounder=10,
                     signvector_list=representative_signvectors) {
  if (evenness(set, edo) < 10^(-rounder) ) { return(0) }

  card <- length(set)
  signvec <- toString(signvector(set, ineqmat, edo, rounder))

  return(which(signvector_list[[card]]==signvec))
}