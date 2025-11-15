# How even is a scale?

Calculates the distance from a set to the nearest perfectly even
division of the octave, which will *not* be the one with a first entry
of 0, unlike almost every other usage in this package. That's because,
for most purposes, we do want to distinguish between different modes of
a set, but it seems counterintuitive to me to say that one mode of a
scale is less even than another. Since this value is a distance from the
perfectly even ("white") scale, lower values indicate more evenness.

## Usage

``` r
evenness(
  set,
  method = c("euclidean", "taxicab", "chebyshev", "hamming"),
  edo = 12,
  rounder = 10
)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- method:

  What distance metric should be used? Defaults to `"euclidean"` (unlike
  most functions with a method parameter in musicMCT) but can be
  `"taxicab"`, `"chebyshev"`, or `"hamming"`.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

Single non-negative numeric value

## Details

Note that the values this function returns depend on what measurement
unit you're using (i.e. are you in 12edo or 16edo?). Their absolute
value isn't terribly significant: you should only make relative
comparisons between calculations done with the same value for `edo`.

Currently, `method`s other than "Euclidean" are somewhat experimental.

## Examples

``` r
evenness(c(0, 4, 8))
#> [1] 0
evenness(c(0, 4, 7)) < evenness(c(0, 1, 2))
#> [1] TRUE

dim_triad <- c(0, 3, 6)
sus_2 <- c(0, 2, 7)
coord_to_edo(dim_triad)
#> [1]  0 -1 -2
coord_to_edo(sus_2)
#> [1]  0 -2 -1
evenness(dim_triad) == evenness(sus_2)
#> [1] TRUE
```
