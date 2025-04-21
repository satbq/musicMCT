#' Minimal voice leadings to all transpositions of some Tn-type mod k
#'
#' Given a starting set (`source`) and some tn-type as a voice leading goal
#' (`goal_type`), find the minimal voice leading to every transposition
#' (in some mod k universe) of the goal. If a goal is not specified, the
#' goal is assumed to be the tn-type of the `source` set. This lets you see,
#' for example, the minimal voice leading from C7 to other dominant
#' seventh chords mod 12. I couldn't think of a suitably serious and clear name
#' for this information, so the metaphor behind "rolodex" is that these voice leadings
#' are the contact information that `source` has for all its acquaintances in `goal_type`.
#'
#' @inheritParams minimizeVL
#' @param goal_type Numeric vector, any pitch-class set
#'   representing the tn-type of your voice leading goal
#' @param reorder Should the results be listed from smallest to largest voice leading size?
#'   Defaults to `TRUE`. If `FALSE` results are listed in transposition order (i.e. 
#'   \eqn{T_1}, \eqn{T_2}, ..., \eqn{T_{edo-1}}, \eqn{T_0}).
#' @returns A list of length `edo`, each entry of which represents a voice leading (or group of 
#'   tied voice leadings). List entries are named by their transposition level.
#'
#' @examples
#' VL_rolodex(c(0,4,7))
#'
#' VL_rolodex(c(0,4,7), reorder=FALSE)
#'
#' #Multisets sort of work! Best resolutions from dom7 to triads with doubled root:
#' VL_rolodex(c(0,4,7,10), c(0, 0, 4, 7))
#'
#' @export
VL_rolodex <- function(source, 
                       goal_type=NULL, 
                       reorder=TRUE, 
                       method=c("taxicab", "euclidean", "chebyshev", "hamming"), 
                       edo=12, 
                       rounder=10,
                       no_ties=FALSE) {
  if (is.null(goal_type)) { 
    goal_type <- source 
  }
  goals <- sapply(1:edo, tn, set=goal_type, edo=edo)

  tiny <- 10^(-1*rounder)
  method <- match.arg(method)

  res <- apply(goals, 2, minimizeVL, source=source, method=method, edo=edo, no_ties=no_ties)
  if ("matrix" %in% class(res)) { 
    res <- as.list(as.data.frame(res)) 
  }
  names(res) <- 1:edo
  names(res)[edo] <- 0

  dist_func <- function(x) {
    switch(method,
           taxicab = sum(abs(x)),
           euclidean = sqrt(sum(x^2)),
           chebyshev = max(abs(x)),
           hamming = sum(abs(x) > tiny))
  }

  if (reorder == TRUE) {
    index <- rep(NA,edo)
    for (i in 1:edo) {
      if ("matrix" %in% class(res[[i]])) {
        index[i] <- apply(res[[i]], 1, dist_func)[1]
      } else {
        index[i] <- dist_func(res[[i]])
      }
    }
    res <- res[order(index)]
  }

  res
}
