#' Define scale by entering its relative step sizes
#'
#' Where [asword()] takes you from a scale to a ranked list of its step sizes,
#' `realize_setword` does the opposite: given a list of ranked step sizes,
#' it defines a scale with those steps. It does not attempt to define a scale
#' that exists in 12-tone equal temperament or another mod k universe, though
#' the result will always have integral values in *some* mod k setting. If you
#' want that information, set `reconvert` to `FALSE`.
#'
#' @param setword A numeric vector (intended to be integers) of ranked step
#'   sizes; should be the same length as desired output set.
#' @inheritParams tnprime
#' @param reconvert Boolean. Should the result be expressed measured in
#'   terms of semitones (or a different mod k step if edo is not set to 12)?
#"   Defaults to `TRUE`.
#' @returns Numeric vector of same length as set, if `reconvert` is `TRUE`. If
#'   `reconvert` is `FALSE`, returns a list with two elements. The first 
#'   element (`set`) expresses the defined set as integer values in some edo.
#'   The second element (`edo`) tells you which edo (mod k universe) the set
#'   is defined in.
#'
#' @examples
#' dim7 <- realize_setword(c(1,1,1,1))
#' four_on_the_floor <- realize_setword(c(1,1,1,1), edo=16)
#' my_luggage <- realize_setword(c(1,2,3,4,5))
#' my_luggage_in_15edo <- realize_setword(c(1,2,3,4,5),reconvert=FALSE)
#' dim7
#' four_on_the_floor
#' my_luggage
#' my_luggage_in_15edo
#'
#' pwf_scale <- realize_setword(c(3,2,1,3,2,3,1))
#' asword(pwf_scale)
#' 
#' @export
realize_setword <- function(setword, edo=12, reconvert=TRUE) {
  set <- cumsum(setword)
  wordedo <- set[length(set)]
  if (reconvert==FALSE) {
    set <- sort(set %% wordedo)
    res <- list("set"=set, "edo"=wordedo)
    return(res)
  }
  set <- convert(sort(set %% wordedo), wordedo, edo)
  return(set)
}