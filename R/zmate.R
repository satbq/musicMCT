#' Twin set in the Z-relation (Z mate)
#'
#' For the standard 12edo sets of Fortean pitch-class set theory,
#' given one pitch-class set, find a set class whose interval-class
#' vector is the same as the input set but which does not include
#' the input set. Not all set classes participate in the Z-relation,
#' in which case the function returns `NA`.
#'
#' These values are hard-coded from Forte's list and only work for subsets
#' of the standard chromatic scale. `zmate` doesn't even give you an option
#' to work in a different `edo`. To do so, I can't see a better solution
#' than calculating all the set classes of a given cardinality on the spot,
#' which can be slow for higher `edo`s.
#'
#' @inheritParams tnprime
#' @returns `NA` or numeric vector of same length as `set`
#' @examples
#' zmate(c(0,4,7))
#' zmate(c(0,1,4,6))
#' @export
zmate <- function(set) {
  num <- fortenum(set)
  res <- NA

  if (num == "4-15") { res <- c(4,29) }
  if (num == "4-29") { res <- c(4,15) }

  if (num == "8-15") { res <- c(8,29) }
  if (num == "8-29") { res <- c(8,15) }

  if (num == "5-12") { res <- c(5,36) }
  if (num == "5-36") { res <- c(5,12) }
  if (num == "5-38") { res <- c(5,18) }
  if (num == "5-18") { res <- c(5,38) }
  if (num == "5-37") { res <- c(5,17) }
  if (num == "5-17") { res <- c(5,37) }

  if (num == "7-12") { res <- c(7,36) }
  if (num == "7-36") { res <- c(7,12) }
  if (num == "7-38") { res <- c(7,18) }
  if (num == "7-18") { res <- c(7,38) }
  if (num == "7-37") { res <- c(7,17) }
  if (num == "7-17") { res <- c(7,37) }


  if (num == "6-36") { res <- c(6,3) }
  if (num == "6-3") { res <- c(6,36) }
  if (num == "6-37") { res <- c(6,4) }
  if (num == "6-4") { res <- c(6,37) }
  if (num == "6-40") { res <- c(6,11) }
  if (num == "6-11") { res <- c(6,40) }
  if (num == "6-41") { res <- c(6,12) }
  if (num == "6-12") { res <- c(6,41) }
  if (num == "6-13") { res <- c(6,42) }
  if (num == "6-42") { res <- c(6,13) }
  if (num == "6-38") { res <- c(6,6) }
  if (num == "6-6") { res <- c(6,38) }
  if (num == "6-46") { res <- c(6,24) }
  if (num == "6-24") { res <- c(6,46) }
  if (num == "6-17") { res <- c(6,43) }
  if (num == "6-43") { res <- c(6,17) }
  if (num == "6-47") { res <- c(6,25) }
  if (num == "6-25") { res <- c(6,47) }
  if (num == "6-19") { res <- c(6,44) }
  if (num == "6-44") { res <- c(6,19) }
  if (num == "6-48") { res <- c(6,26) }
  if (num == "6-26") { res <- c(6,48) }
  if (num == "6-10") { res <- c(6,39) }
  if (num == "6-39") { res <- c(6,10) }
  if (num == "6-49") { res <- c(6,28) }
  if (num == "6-28") { res <- c(6,49) }
  if (num == "6-29") { res <- c(6,50) }
  if (num == "6-50") { res <- c(6,29) }
  if (num == "6-45") { res <- c(6,23) }
  if (num == "6-23") { res <- c(6,45) }

  if (is.na(res[1])) { return(res) }

  return(sc(res[1],res[2]))
}