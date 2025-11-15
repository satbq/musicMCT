# How far apart are two scales?

Using the chosen `method` to measure distance, determines how far apart
two scales are in voice-leading space.

## Usage

``` r
vl_dist(
  set_1,
  set_2,
  method = c("taxicab", "euclidean", "chebyshev", "hamming"),
  rounder = 10
)
```

## Arguments

- set_1, set_2:

  Numeric vectors of pitch-classes in the sets. Must be of same length.

- method:

  What distance metric should be used? Defaults to `"taxicab"` but can
  be `"euclidean"`, `"chebyshev"`, or `"hamming"`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

Numeric: distance between `set_1` and `set_2`

## Examples

``` r
c_major <- c(0, 4, 7)
a_minor_63 <- c(0, 4, 9)
f_minor_64 <- c(0, 5, 8)
vl_dist(c_major, a_minor_63)
#> [1] 2
vl_dist(c_major, f_minor_64)
#> [1] 2
vl_dist(c_major, a_minor_63, method="euclidean")
#> [1] 2
vl_dist(c_major, f_minor_64, method="euclidean")
#> [1] 1.414214
```
