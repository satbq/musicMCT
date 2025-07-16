#' Algebraic word of a set's step sizes
#' 
#' Among others, Carey & Clampitt (1989) and Clampitt (1997) have shown that
#' much can be learned about a set by representing it as a word on \eqn{m}
#' "letters" which represent the \eqn{m} distinct steps between adjacent
#' members of the set. This is more or less what is done in theory fundamentals
#' classes when a major scale is represented as TTSTTTS (if we temporarily 
#' forget that T and S represent specific interval sizes). In scholarship
#' the algebraic letters are usually represented as letters of the Latin
#' alphabet, but for some computational purposes it is useful for these to
#' be explicitly ordered. That is, the major scale should be represented as
#' integers 2212221, which is distinct from 1121112. (Thus `asword` makes finer 
#' distinctions than you might expect coming from a word-theoretic context.)
#'
#' @inheritParams tnprime
#' @inheritParams fpunique
#' @returns Vector of integers of the same length as `set`. `1` should always
#'   be the lowest value, representing the smallest step size in the set.
#' @examples
#' dia_12edo <- c(0, 2, 4, 5, 7, 9, 11)
#' qcm_fifth <- meantone_fifth()
#' qcm_dia <- sort(((0:6)*qcm_fifth)%%12)
#' just_dia <- j(dia)
#' asword(dia_12edo)
#' asword(qcm_dia)
#' asword(just_dia)
#' 
#' #### asword() is less discriminating than colornum(). 
#' #### See "Modal Color Theory," 16
#' set1 <- c(0, 1, 4, 7, 8)
#' set2 <- c(0, 1, 3, 5, 6)
#' set1_word <- asword(set1)
#' set2_word <- asword(set2)
#' isTRUE(all.equal(set1_word, set2_word))
#' colornum(set1) == colornum(set2) 
#' # (Last line only works with representative_signvectors loaded.)
#' @export
asword <- function(set, edo=12, rounder=10) {
  card <- length(set)
  result <- rep(0, card)

  setsteps <- sim(set, edo=edo)[2, ]
  stepvals <- sort(fpunique(setsteps, 0, rounder))

  for (i in 1:card) {
    result[which(abs(setsteps - stepvals[i]) < 10^(-1*rounder) )] <- i
  }

  check_for_rounding_error <- isTRUE(all.equal(sort(unique(result)), 1:max(result)))

  if (!check_for_rounding_error) {
    old_letters <- unique(result)
    reduce_letter <- function(n, word) sum(word <= n)
    reduced_letters <- sapply(old_letters, reduce_letter, word=old_letters)
    new_result <- result
    for (i in 1:length(old_letters)) {
      new_result[which(result==old_letters[i])] <- reduced_letters[i]
    }
    result <- new_result
  }

  result
}