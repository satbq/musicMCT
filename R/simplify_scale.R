#' Simplify a scale
#' 
#' simplify_scale description
#'
#' @inheritParams tnprime
#' @inheritParams signvector
#' @inheritParams ifunc
#' @inheritParams project_onto
#' @param scales List of scales representing the faces of your hyperplane
#'   arrangement. Defaults to `NULL` in which case the function looks for
#'   `representative_scales` in the global environment.
#' @inheritParams colornum
#' @param adjlist Adjacency list structed in the same way as `color_adjacencies`.
#'   Defaults to `NULL` in which case the function looks for `color_adjacencies`
#'   in the global environment.
#' @param method What distance metric should be used? Defaults to `"euclidean"` 
#'   (unlike most functions with a method parameter in musicMCT) 
#'   but can be `"taxicab"`, `"chebyshev"`, or `"hamming"`.
#' @param ... Other arguments to be passed from `best_simplification()`
#'   to `simplify_scale()`.
#'
#' @returns A complicated matrix
#'
#' @examples
#' \dontrun{
#'   simplify_scale(c(0,5))
#' }
#' @export
simplify_scale <- function(set,
                           start_zero=TRUE, 
                           ineqmat=NULL,
                           scales=NULL,
                           signvector_list=NULL, 
                           adjlist=NULL,
                           method=c("euclidean", "taxicab", "chebyshev", "hamming"),
                           display_digits=2,
                           edo=12, 
                           rounder=10) {
  method <- match.arg(method)
  if (is.null(signvector_list)) {
    signvector_list <- get0("representative_signvectors")
    if (is.null(signvector_list)) {
      stop("representative_signvectors must exist if signvector_list isn't defined")
    }
  }

  if (is.null(scales)) {
    scales <- get0("representative_scales")
    if (is.null(scales)) {
      stop("representative_scales must exist if scales isn't defined")
    }
  }

  if (is.null(adjlist)) {
    adjlist <- get0("color_adjacencies")
    if (is.null(adjlist)) {
      stop("color_adjacencies must exist if adjlist isn't defined")
    }
  }

  card <- length(set)
  if (is.null(ineqmat)) ineqmat <- getineqmat(card)

  set_colornum <- colornum(set, 
                           ineqmat=ineqmat, 
                           signvector_list=signvector_list, 
                           edo=edo,
                           rounder=rounder)
  set_freedom <- howfree(set, ineqmat=ineqmat, edo=edo, rounder=rounder)
  set_zerocount <- countsvzeroes(set, ineqmat=ineqmat, edo=edo, rounder=rounder) 

  set_neighbors <- scales[[card]][, adjlist[[card]][[set_colornum]]]

  if (edo != 12) {
    set_neighbors <- apply(set_neighbors, 2, convert, edo1=12, edo2=edo)
  }

  nei_free <- apply(set_neighbors, 2, howfree, ineqmat=ineqmat, edo=edo, rounder=rounder)
  useful_neighbors <- which(nei_free < set_freedom)

  set_neighbors <- set_neighbors[,useful_neighbors]
  nei_free <- nei_free[useful_neighbors]
  set_neighbors <- cbind(edoo(card, edo=edo), set_neighbors)
  nei_free <- c(0, nei_free)

  nei_colornums <- apply(set_neighbors, 
                         2, 
                         colornum, 
                         ineqmat=ineqmat,
                         signvector_list=signvector_list, 
                         edo=edo, 
                         rounder=rounder)
  
  projections <- apply(set_neighbors, 
                       2, 
                       match_flat,
                       set=set,
                       start_zero=FALSE, # NB must always be false!
                       ineqmat=ineqmat,
                       edo=edo,
                       rounder=rounder)

  proj_nums <- apply(projections, 
                     2, 
                     colornum, 
                     ineqmat=ineqmat, 
                     signvector_list=signvector_list,
                     edo=edo,
                     rounder=rounder)
  rejection_index <- which(nei_colornums != proj_nums)
  accepted_index <- setdiff(1:length(nei_colornums), rejection_index)
  rejected_neighbors <- nei_colornums[rejection_index]
  projections <- projections[, accepted_index]

  get_costs <- function(set1) {
    distance <- vl_dist(set1, set_2=set, method=method, rounder=rounder)
    new_0s <- countsvzeroes(set1, ineqmat=ineqmat, edo=edo, rounder=rounder)-set_zerocount
    cost_per_0 <- distance / new_0s

    c(distance, new_0s, cost_per_0)
  } 
  
  projections <- insist_matrix(projections)
  all_costs <- apply(projections, 2, get_costs)
  if (start_zero) {
    projections <- apply(projections, 2, startzero, edo=edo, sorted=FALSE)
    projections <- insist_matrix(projections)
  }

  proj_nums <- proj_nums[accepted_index]
  nei_free <- nei_free[accepted_index]
  scores <- (all_costs[3,]^(-1)) / dim(ineqmat)[1]
  res <- rbind(projections, proj_nums, nei_free, all_costs, scores) 

  sd_names <- cbind(rep("sd", card), 1:card)
  sd_names <- apply(sd_names, 1, paste0, collapse=" ")
  rownames(res) <- c(sd_names, 
                     "colornum", 
                     "freedom", 
                     "distance", 
                     "new 0s", 
                     "cost per 0",
                     "score")

  sorted_index <- order(all_costs[3,])
  res <- res[, sorted_index] 
  res <- insist_matrix(res)
  if (is.null(display_digits)) {
    return(res)
  } else {
    print(round(res, digits=display_digits))
    invisible(res)
  }
}

#' @rdname simplify_scale
#' @export
best_simplification <- function(set, ...) {
  card <- length(set)
  res <- simplify_scale(set, display_digits=NULL, ...)[1:card, 1]
  names(res) <- NULL
  res
}

