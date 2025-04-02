#' Visualize brightness relationships among modes of a scale
#'
#' @description 
#' Discussed in "Modal Color Theory" (pp. 7-11), the brightness graph of a scale is a Hasse diagram
#' that represents the sum- and voice-leading brightness relationships between the modes of a scale.
#' Each node of the graph represents a mode. With default options, the large Roman numeral of each node
#' indicates which mode of the input scale it represents. (The input scale is roman numeral I.) Small
#' Arabic numerals beneath the Roman numeral indicate the pitch-classes of the mode (relative to scale
#' degree 1 as 0). In parentheses, the sum brightness of the mode is shown. Modes with higher sum
#' brightness are farther up on the graph. Arrows connect modes that can be compared by voice-leading
#' brightness. The arrows only show a transitive reduction of all VL-brightness comparisons, so that if 
#' you can travel between two sets by only going "up" or "down" the arrows, the source and destination
#' are indeed related by voice-leading brightness.
#'
#' Various visual parameters can be configured: `numdigits` determines how many digits of each pitch-class
#' to display; `show_sums` toggles on or off the sum brightness values; `show_pitches` toggles on or off
#' the individual pitch classes of each mode; `fixed_do`, if set to `TRUE` switches the graph from showing
#' "parallel" modes (e.g. C ionian vs C aeolian) to showing "relative" modes (e.g. C ionian to A aeolian).
#'
#' For now, the function doesn't have a smart way to determine the horizontal positioning of modes in the
#' graph. It uses a heuristic that works well for many sets, but sometimes it will create too much 
#' visual overlap or won't clarify underlying sturcture particularly well. Think of these automatically
#' generated graphs as the starting point for manual fine tuning.
#'
#' @inheritParams tnprime
#' @inheritParams fpunique
#' @param numdigits Integer: how many digits of each pitch-class to show? Defaults to `2`.
#' @param show_sums Boolean: should the graph show sum brightness values? Defaults to `TRUE`.
#' @param show_pitches Boolean: should the graph show values for each note of the scale? Defaults to `TRUE`.
#' @param fixed_do Boolean: should the graph use only the fixed pitches of the input set? Defaults to `FALSE`.
#'
#' @examples
#' brightnessgraph(c(0,2,4,5,7,9,11))
#' brightnessgraph(c(0,2,4,5,7,9,11), fixed_do=TRUE)
#' brightnessgraph(c(0,1,4,9,11),edo=15)
#'
#' #### A more complicated graph
#' werck_ratios <- c(1, 256/243, 64*sqrt(2)/81, 32/27, (256/243)*2^(1/4), 4/3, 
#'   1024/729, (8/9)*2^(3/4), 128/81, (1024/729)*2^(1/4), 16/9, (128/81)*2^(1/4))
#' werckmeister_3 <- 12 * log2(werck_ratios)
#' brightnessgraph(werckmeister_3, show_sums=FALSE, show_pitches=FALSE)
#' 
#' @returns `NULL` and plots a brightness graph in the graphic device

brightnessgraph <- function(set, numdigits=2, show_sums=TRUE, show_pitches=TRUE, fixed_do=FALSE,
                            edo=12, rounder=10) {
   card <- length(set)
  sums <- colSums(sim(set,edo))
  y_coords <- sums

  comparisons <- -1*brightnessComps(set, edo, rounder)
  comparisons[which(comparisons<0)] <- 0

  # This section, up through the definition of "reduced comparisons," is a hack-y way to approximate the
  # transitive reduction of the graph of all brightness comparisons. It works by using the idea that two comparable
  # modes are less likely to have an intermediate node if their sums are pretty close to each other. I'm not
  # confident the behavior will always be ideal, but any mistakes should involve drawing redundant arrows (e.g.
  # from phrygian directly to ionian), never removing arrows that are essential.
  diffs <- outer(sums, sums,'-')
  diffs <- abs(comparisons * diffs)
  min_diff <- min(diffs[diffs>10^(-rounder)])
  diffs <- diffs/min_diff
  diffs_nonzero <- !!diffs
  diffs <- 3^(diffs-1)
  diffs <- diffs_nonzero * diffs
  weighted_graph <- igraph::graph_from_adjacency_matrix(diffs, weighted=TRUE)

  get_neighbors <- function(i) {
    suppressWarnings(path_lengths <- unlist(lapply(igraph::shortest_paths(weighted_graph, i, mode="out")[[1]], length)))
    return(which(path_lengths==2))
  }

  reduced_comparisons <- matrix(0, nrow=card, ncol=card)
  for (i in 1:card) {
    reduced_comparisons[i, get_neighbors(i)] <- 1
  }

  # Below determines labels and visual layout for the brightness graph.

  middle <- ceiling(card/2)
  if (card%%2) {
    pillars <- rbind(order(sums)[1:middle], order(sums)[card:middle])
  } else {
    pillars <- rbind(order(sums)[1:middle], order(sums)[card:(middle+1)])

    if (sums[pillars[2,middle]]-sums[pillars[1, middle]] < 10^(-rounder)) {
      # This conditional checks for the most common type of overlap, which happens when two modes share the median
      # sum brightness for scales of even cardinality.
      # In principle this could be fixed by the while loop (using "bad_rows") below but I like the appearance that this
      # produces better, when this is the only type of overlap in the graph.
      tempvals <- c(pillars[2, 1], pillars[2, middle])
      pillars[2, middle] <- tempvals[1]
      pillars[2, 1] <- tempvals[2]
    }
  }
  pick_pillar <- function(n) {
    height <- n
    res <- which(pillars==height, arr.ind=TRUE)[1, 2]
    return(res)
  }
  x_coords <- sapply(1:card, pick_pillar)
  x_offsets <- (x_coords %% 2) - .5
  x_coords <- x_coords * x_offsets

  # In some cases, e.g. set class 6-30, more than 2 modes have the same sum brightness.
  # This will offset the x_coord of overlapping nodes.
  rounded_coordinates <- round(cbind(x_coords, y_coords), rounder)
  bad_rows <- duplicated(rounded_coordinates, MARGIN=1)
  layout_matrix <- cbind(x_coords, y_coords)
  while(sum(bad_rows)) {
    layout_matrix[bad_rows, 1] <- max(layout_matrix[,1]) + 1
    new_rounded_coordinates <- round(layout_matrix, rounder)
    bad_rows <- duplicated(new_rounded_coordinates, MARGIN=1)
  }

  if (fixed_do==TRUE) {
    pitch_labels <- sapply(0:(card-1), rotate, x=set, edo=edo)
  } else {
    pitch_labels <- sim(set,edo=edo)
  }
  pitch_labels <- apply(apply(pitch_labels,2, round, digits=numdigits), 2, paste, collapse=", ")

  label_matrix <- cbind(as.character(utils::as.roman(1:card)),
                        rep(" (",card),
                        round(sums,digits=numdigits),
                        rep(")",card),
                        rep("\n",card),
                        pitch_labels)

  pitches_start_index <- 5
  pitches_end_index <- 6
  sums_start_index <- 2
  sums_end_index <- 4

  if (show_pitches==FALSE) {
    label_matrix <- label_matrix[,-(pitches_start_index:pitches_end_index)]
  }
  if (show_sums==FALSE) {
    label_matrix <- label_matrix[,-(sums_start_index:sums_end_index)]
  }

  if (class(label_matrix)[1]=="character") label_matrix <- as.matrix(label_matrix)

  label_vector <- apply(label_matrix,1,paste,collapse="")

  bg <- igraph::graph_from_adjacency_matrix(reduced_comparisons)
  plot(bg,layout=layout_matrix, vertex.shape="none", vertex.label=label_vector)
  invisible()
}
