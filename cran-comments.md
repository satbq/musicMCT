## Resubmission
This is a resubmission. In this version I have:

* Replaced \dontrun with \donttest in the Examples for writeSCL.Rd

* Changed writeSCL() in R/scala.R so that it requires the user to specify a path when writing a file.

* Updated tests/testthat/test-scala.R and the Examples for writeSCL() so that they write to a temp directory.

* Changed the vignette inst/doc/visualizing_higher_dimensions.R so that it resets changes to par().

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a resubmission of a new release.
