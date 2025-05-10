#' Create a Scala tuning file from a given scale
#'
#' @description
#' You mean you don't want to play around in R forever?
#' This function lets you export any scale you've defined in R
#' as a .scl tuning file for use in Scala or by any synth that can read
#' .scl files. Will write to your working directory.
#'
#' In addition to saving the necessary tuning data, the function
#' will attempt to add as comments extra information that can be derived
#' from MCT functions, like the color number, degrees of freedom, number of sign-vector zeroes, etc.
#'
#' @inheritParams tnprime
#' @inheritParams fpunique
#' @inheritParams signvector
#' @param x Numeric vector: the scale to export
#' @param filename String (in quotation marks): what to name your Scala file. Defaults to using
#'   the name of `x` as the file name if you enter nothing.
#' @param period The frequency ratio at which your scale repeats; defaults to `2` which
#'   indicates an octave-repeating scale.
#' @returns Invisible `NULL`
#' @examples
#' neat_pentachord <- convert(c(0, 1, 4, 9, 11), 15, 12)
#' \dontrun{
#'   writeSCL(neat_pentachord, "neat_pentachord.scl")
#' }
#' @export
writeSCL <- function(x, filename, period=2, ineqmat=NULL, edo=12, rounder=10) {
  # Period defined as a frequency ratio (i.e. 2 for octave-repeading scales)
  periodCents <- z(period, edo=1200)

  if (missing(filename)) {
    filename <- deparse(substitute(x))
    filename <- paste0(filename, ".scl")
  }

  if (substr(filename, nchar(filename)-3, nchar(filename)) != ".scl") {
    filename <- paste0(filename, ".scl")
  }

  ###Comment with the filename

  line0 <- paste0("! ",filename)

  ###The scale description
  card <- length(x)
  freedom <- howfree(x)
  svzeroes <- countsvzeroes(x, ineqmat=ineqmat, edo=edo, rounder=rounder)
  scaleratio <- round(ratio(x, edo=edo, rounder=rounder),3)
  how_even <- round(evenness(x, edo=edo), 3)

  nameColor <- FALSE
  if (exists("representative_signvectors")) {
    if (card <= length(get("representative_signvectors"))) {
      color <- colornum(x,
                        ineqmat=ineqmat, 
                        edo=edo, 
                        rounder=rounder,
                        signvector_list=NULL)
      nameColor <- TRUE
    }
  }


  if (freedom==1) { 
    degree <- "degree" 
  } else { 
    degree <- "degrees" 
  }

  if (svzeroes==1) { 
    zeroes <- "hyperplane" 
  } else { 
    zeroes <- "hyperplanes" 
  }

  if (nameColor==TRUE) {
    line1 <- paste0("A ", card, "-note scale of color ", color, " with ", freedom, " ", degree, " of freedom. Period: ", round(periodCents,3), " cents. Ratio: ", scaleratio, "; evenness: ", how_even, " (wrt. ", edo, " steps to period); on ", svzeroes, " ", zeroes, ".")
  } else {
    line1 <- paste0("A ", card, "-note scale with ", freedom, " ", degree, " of freedom. Period: ", round(periodCents,3), " cents. Ratio: ", scaleratio, "; evenness: ", how_even, " (wrt. ", edo, " steps to period); on ", svzeroes, " ", zeroes, ".")
  }

  if (how_even < 10^-rounder) { line1 <- paste0("A ", card, "-note equal division of ", round(periodCents, 3), " cents.") }

  ###The data for Scala

  line2 <- paste(card)
  line3 <- "! "
  x <- c(x, edo)
  scaledef <- convert(x, edo, periodCents)[-1]
  scaledef <- format(scaledef, nsmall=1, digits=(rounder+2))

  fileConn <- file(filename)
  writeLines(c(line0, line1, line2, line3, scaledef), fileConn)
  close(fileConn)
  invisible()
}


#' Import a Scala (.scl) file as a scale
#'
#' This function allows you to import scales that have been defined in the Scala tuning format
#' (*.scl) into R to analyze with the functions of `musicMCT`. Scales can be defined in .scl files
#' in different ways, some of which may lack the precision that computations in `musicMCT` normally
#' assume. If you import a scale that seems to have less regularity than you expected (i.e. it's on 0 
#' hyperplanes even though it seems to be very regular), try increasing your rounding tolerance (i.e. lower
#' the value of `rounder` arguments in the functions you apply to the imported scale).
#'
#' @param filename String with the path to the file to be imported
#' @param scaleonly Boolean: should `readSCL` return only a vector of pitches, not
#' additional information from the file? Defaults to `TRUE`
#' @inheritParams tnprime
#'
#' @returns A numeric vector with the scale's pitches if `scaleonly=TRUE`; else a list
#'   in which the scale's pitches are the first entry, the length of the scale is the second,
#'   and the size of the period is the third.
#' 
#' @examples
#' # We'll read a sample .scl file that comes with the `musicMCT` package.
#' demo_filepath <- system.file("extdata", "sample_pentachord.scl", package="musicMCT")
#' fun_pentachord <- readSCL(demo_filepath)
#' sim(fun_pentachord)
#' brightnessgraph(fun_pentachord)
#' 
#' @export
readSCL <- function(filename, scaleonly=TRUE, edo=12) {
  contents <- scan(filename, what="character", sep="\n", quiet=TRUE, blank.lines.skip=FALSE)

  removeAfterChar <- function(string,charToRemove) {
    charindex <- as.vector(regexpr(charToRemove, string, fixed=TRUE))
    charindex[charindex ==-1] <- nchar(string[charindex == -1]) + 1
    charindex <- charindex - 1
    res <- do.call(substr, list(x=string, start=rep(0, length(string)), stop=charindex))
    res[res!=""]
  }

  # Fill in description line if blank
  bangindex <- as.vector(grepl("!", contents, fixed=TRUE))
  firstrealline <- contents[which(bangindex==FALSE)[1]]
  if (firstrealline == "") { 
    contents[which(bangindex==FALSE)[1]] <- "blank description" 
  }

  # Remove comments marked by !
  contents <- removeAfterChar(contents, "!")
  contents <- trimws(contents)

  # Read scale length & remove description header
  card <- strtoi(contents[2])
  if (class(card)[1] != "integer") { 
    warning(".scl file not formatted as expected. Scale length not found.") 
  }
  contents <- contents[-(1:2)]

  # Locate the degrees defined as ratios vs. those defined by cents
  ratioindex <- grepl("/", contents, fixed=TRUE)
  centsindex <- grepl(".", contents, fixed=TRUE)

  # Remove whitespace-prefixed comments
  contents <- trimws(contents)
  contents <- removeAfterChar(contents, " ")

  # Check for integers (e.g. an octave defined as "2" rather than "2/1")
  integerindex <- !is.na(strtoi(contents))

  if (sum(ratioindex, centsindex, integerindex) != card) { 
    warning(".scl file not formatted as expected. Cents or ratios incorrectly identified.") 
  }

  # Convert the ratios to scale degrees
  ratioToLog <- function(ratioString, edo=edo) {
    dividends <- unlist(strsplit(ratioString, split="/"))
    if ( length(dividends) != 2 ) { 
      warning(".scl file not formatted as expected. Apparent ratio with more or less than 2 arguments.") 
    }
    dividends <- as.numeric(dividends)
    res <- dividends[1]/dividends[2]
    edo * log2(res)
  }

  # Convert integers to scale degrees
  intToLog <- function(intString, localedo=edo) {
    val <- strtoi(intString)
    localedo * log2(val)
  }

  # Apply above functions and convert cents to global EDO
  if (sum(ratioindex) > 0) { 
    contents[ratioindex] <- sapply(contents[ratioindex], ratioToLog, edo=edo) 
  }
  if (sum(integerindex) > 0) {
    contents[integerindex] <- sapply(contents[integerindex], intToLog) 
  }
  if (sum(centsindex) > 0) { 
    contents[centsindex] <- sapply(contents[centsindex], as.numeric) * (edo/1200) 
  }
  contents <- as.numeric(contents)

  # Format & output results
  names(contents) <- NULL
  octave <- contents[length(contents)]
  contents <- c(0, contents[-length(contents)])

  if (scaleonly==TRUE) { 
    return(contents) 
  }

  list(scale=contents, length=card, period=octave)
}
