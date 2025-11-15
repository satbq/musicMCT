# Smallest crossing-free voice leading between two pitch-class sets

Given source and goal pitch-class sets, which mode of the goal is
closest to the source (assuming crossing-free voice leadings and the
given `method` for determining distance).

## Usage

``` r
whichmodebest(
  source,
  goal,
  method = c("taxicab", "euclidean", "chebyshev", "hamming"),
  no_ties = FALSE,
  edo = 12,
  rounder = 10
)
```

## Arguments

- source:

  Numeric vector, the pitch-class set at the start of your voice leading

- goal:

  Numeric vector, the pitch-class set at the end of your voice leading

- method:

  What distance metric should be used? Defaults to `"taxicab"` but can
  be `"euclidean"`, `"chebyshev"`, or `"hamming"`.

- no_ties:

  If multiple VLs are equally small, should only one be returned?
  Defaults to `FALSE`, which is generally what an interactive user
  should want.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

Numeric value(s) identifying the modes of `goal`. Single value if
`no_ties` is `TRUE`, otherwise n values for an n-way tie.

## Examples

``` r
c_53 <- c(0, 4, 7)
c_64 <- c(7, 0, 4)
d_53 <- c(2, 6, 9)
e_53 <- c(4, 8, 11)

whichmodebest(c_53, c_64)
#> [1] 2
whichmodebest(c_64, c_53)
#> [1] 3
whichmodebest(c_53, e_53)
#> [1] 3
whichmodebest(c_53, d_53)
#> [1] 1 3
whichmodebest(c_53, d_53, method="euclidean")
#> [1] 1

# See "Modal Color Theory," p. 12, note 21
pyth_dia_modes <- sim(sort((j(5) * 0:6)%%12))
pyth_lydian <- pyth_dia_modes[,1]
pyth_locrian <- pyth_dia_modes[,4]
whichmodebest(pyth_locrian, pyth_lydian) 
#> [1] 7
```
