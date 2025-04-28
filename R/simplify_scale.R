#' Best ways to regularize a scale
#' 
#' Given an input scale, identify which adjacent colors represent good
#' approximations of it, in a sense consistent with "Modal Color Theory,"
#' pp. 31-32.
#'
#' Suppose that you've gathered data on how a particular instrument is tuned.
#' Two intervals in its scale differ by about 12 cents: does it make sense
#' to consider those intervals to be essentially the same, up to some
#' combination of measurement error and the permissiveness of cognitive
#' categories? `simplify_scale()` helps to answer such a question by considering
#' whether eliding a precisely measured difference results in a significant
#' simplifcation of the overall scale structure.
#'
#' It accomplishes this by starting from two premises:
#'  * Any simplification should move to an adjacent color with fewer 
#'      degrees of freedom.
#'  * There's a tradeoff between moving farther (i.e. requiring more
#'      measurement fuzziness) and achieving greater regularity.
#' Therefore it starts by projecting the input scale onto all neighboring
#' flats with fewer degrees of freedom. Some projections can be rejected 
#' immediately because the closest point on the flat isn't actually an 
#' adjacent color. The non-rejected projections can therefore be ranked by
#' calculating the "cost" of each additional regularity: for every `1` or `-1`
#' in the sign vector that is converted to a `0`, how far does one have to
#' move in voice leading space?
#'
#' To answer this question, `simplify_signvector` needs access to data about
#' the hyperplane arrangement in question. For the basic "Modal Color Theory"
#' arrangements, this is the data in `representative_scales.rds`, 
#' `representative_signvectors.rds`, and `color_adjacencies.rds`. The function
#' assumes that, if you don't specify other data, you have those three files
#' loaded into your workspace. It can't function without them.
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
#' @returns A matrix with `n+6` rows, where `n` is the number of notes in the
#'   scale. Each column represents a scale which is a potential simplification
#'   of the input `set`, together with details about that simplified scale.
#'   The first `n` entries of the column represent the pitches of the scale
#'   itself:
#'
#'   * The `n+1`th row indicates the color number of the simplification.
#'   * The `n+2`th row shows how many degrees of freedom the simplification has
#'   (always between `0` and `d-1` where `d` is `set`'s degree of freedom).
#'   * The `n+3`th row calculates the voice-leading distance from `set` to the
#'   simplified scale (according to the chosen `method`, for which Euclidean
#'   distance is the default because it corresponds to the assumption that
#'   orthogonal projection finds the closest point on a neighboring flat).
#'   *  The `n+4`th row counts how many more hyperplanes the simplified scale
#'   lies on compared to `set`. 
#'   * The `n+5`th row is a quotient of the previous
#'   two rows (distance divided by number of new regularities). 
#'   * The `n+6`th row calculates a final "score" which is used to order the
#'   columns from best (first) to worst (last) simplifications. This score
#'   is the inverse of the previous row divided by the total number of 
#'   hyperplanes in the arrangement. (Without this normalization, scores
#'   for higher cardinalities quickly become much larger than scores for
#'   low cardinalities.)
#'  
#'   If `display_digits` is a value other than `NULL`, the function prints
#'   to console a suitably rounded representation of the data, while
#'   invisibly returning the unrounded information.
#'
#'   `best_simplification()` returns simply a numeric vector with the scale
#'    judged optimal by `simplify_scale()` (i.e. the first `n` entries of
#'    its first column, without all the other information).
#'
#' @examplesIf exists("representative_scales") && exists("representative_signvectors") && exists("color_adjacencies")
#' # For this example to run, you need the necessary data files loaded.
#' # Let's see what happens if we try to simplify the 5-limit just diatonic:
#' 
#' simplify_scale(j(dia))
#' 
#' # So the best option is color number 942659, which is the "well-formed"
#' # structure of the familiar diatonic scale. The particular saturation of
#' # that meantone structure is very close to 1/5-comma meantone:
#' 
#' simplified_jdia <- best_simplification(j(dia))
#' fifth_comma_dia <- sim(sort((meantone_fifth(1/5)*(0:6))%%12))[,5]
#' vl_dist(simplified_jdia, fifth_comma_dia)
#' 
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

