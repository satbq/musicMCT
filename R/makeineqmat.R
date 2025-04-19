#' Define hyperplanes for the Modal Color Theory arrangements
#'
#' @description
#' As described in Appendix 1.2 of "Modal Color Theory," information about the
#' defining hyperplane arrangements is stored as a matrix containing the 
#' hyperplanes' normal vectors as rows. (Because these are **mat**rices
#' and they correspond ultimately to the intervallic **ineq**ualities
#' that define MCT geometry, this package refers to them as ineqmats, and
#' sometimes to the individual hyperplanes as `ineq`s.) These have already been computed and
#' are stored as data in this package (`ineqmats`) for cardinalities up to 53,
#' but they can be recreated from scratch with `makeineqmat`. This might be
#' useful if for some reason you need to deal with a huge scale and therefore
#' want to use an arrangement whose matrix isn't already saved. Note that a
#' call like `makeineqmat(60)` may take a dozen or more seconds to run (and
#' at sizes that large, the arrangement is terribly complex, with ~17K 
#' distinct hyperplanes).
#'
#' `getineqmat` tests whether the matrix already exists for the desired 
#' cardinality. If so, it is retrieved; if not, it is created using `makeineqmat`.
#'
#' @param card The cardinality of the scale(s) to be studied
#' @returns A matrix with `card+1` columns and roughly `card^(3)/8` rows
#' @examples
#' makeineqmat(2) # Cute: is step 1 > step 2?
#' makeineqmat(3) # Cute: step 1 > step 2? step 1 > step 3? step 2 > step 3?
#' makeineqmat(7) # Okay...
#' ineqmat20 <- makeineqmat(20)
#' dim(ineqmat20) # Yikes!
#'
#' @export
makeineqmat <- function(card) {
  # Creates a row for the inequality matrix, given the "roots" of the two intervals to be compared
  # (specified as zero-indexed scale degrees) and the generic size of the interval (zero-indexed).
  generateRow <- function(firstroot, secondroot, genericival) {
    row <- rep(0, card+1)
    if ((secondroot %% card) <= firstroot) { 
      return(row) 
    }
    row[(firstroot %% card)+1] <- row[(firstroot %% card)+1] - 1
    row[(secondroot %% card)+1] <- row[(secondroot %% card)+1] + 1
    row[((firstroot + genericival) %% card) + 1] <- row[((firstroot + genericival) %% card) + 1] + 1
    row[((secondroot + genericival) %% card)+1] <- row[((secondroot + genericival) %% card)+1] - 1

    # Last column of the inequality matrix reflects whether the intervals in the comparison wrap around the octave.
    # For instance, comparing do-re to ti-do requires adding 12 to the higher do.
    w <- ((firstroot + genericival) >= card) - ((secondroot + genericival) >= card)
    row[card+1] <- w
    return(row)
  }

  roots <- 0:(card-1)
  intervals <- 1:(card/2)

  # Create all possible combinations of roots and interval sizes.
  combinations <- expand.grid(roots, roots, intervals)
  firstroots <- combinations[,1]
  secondroots <- combinations[,2]
  genericintervals <- combinations[,3]

  # Generate rows from all the combinations; many will be redundant.
  res <- t(mapply(generateRow, firstroot=firstroots, secondroot=secondroots, genericival=genericintervals))

  # Next two lines guarantee that we'll only generate each hyperplane in one orientation.
  # (We don't want to have separate hyperplanes for "first step bigger than second step" and "first step smaller...")
  # So arbitrarily we require the first nonzero entry of a row to be negative.
  rowSign <- function(row) row * -1 * sign(row[which(row!=0)])[1]
  res <- t(apply(res, 1, rowSign))

  # Remove redundant rows.
  res <- res[!duplicated(res, MARGIN=1),]

  # First row was all 0s -- unisons are identical -- so remove it.
  res <- res[-1,]

  return(res)
}

if(getRversion() >= "2.15.1")  utils::globalVariables(c("ineqmats"))

#' @rdname makeineqmat
#' @export
getineqmat <- function(card) {
  if (exists("ineqmats")) {
    if (card <= length(ineqmats)) {
      return(ineqmats[[card]])
    }
  }
 else {
    return(makeineqmat(card))
  }
}