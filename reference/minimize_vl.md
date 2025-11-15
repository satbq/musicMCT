# Smallest voice leading between two sets

Given a `source` set and a `goal` to move to, find the voice leading
from `source` to `goal` with smallest size.

## Usage

``` r
minimize_vl(
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

Numeric array. In most cases, a vector the same length as `source`; or a
vector of `NA` the same length as `source` if `goal` and `source` have
different lengths. If `no_ties=FALSE` and multiple voice leadings are
equivalent, the array can be a matrix with `m` rows where `m` is the
number of equally small voice leadings.

## Details

Unless method="hamming", it is assumed that the minimal voice leading
should be strongly crossing-free, so you might get strange results if
your `source` and `goal` are not both in ascending order.

Using method="hamming" in principle should only care about preserving
common tones, with no other restrictions on how voices move. This gives
a profusion of tied voice leadings, which is not generally useful. This
function therefore eliminates many of the options by requiring that the
voices which aren't common tones make a minimal voice leading by the
taxicab metric. Nevertheless, for multisets, method="hamming" can still
return many tied possibilities.

## Examples

``` r
c_major <- c(0, 4, 7)
ab_minor <- c(8, 11, 3)
minimize_vl(c_major, ab_minor)
#> [1] -1 -1  1

diatonic_scale <- c(0, 2, 4, 5, 7, 9, 11)
minimize_vl(diatonic_scale, tn(diatonic_scale, 7))
#> [1] 0 0 0 1 0 0 0

d_major <- c(2, 6, 9)
minimize_vl(c_major, d_major)
#>      [,1] [,2] [,3]
#> [1,]    2    2    2
#> [2,]   -3   -2   -1
minimize_vl(c_major, d_major, no_ties=TRUE)
#> [1] 2 2 2
minimize_vl(c_major, d_major, method="euclidean", no_ties=FALSE)
#> [1] 2 2 2

minimize_vl(c(0, 4, 7, 10), c(7, 7, 11, 2), method="euclidean")
#>      [,1] [,2] [,3] [,4]
#> [1,]   -1   -2    0   -3
#> [2,]    2    3    0    1
minimize_vl(c(0, 4, 7, 10), c(7, 7, 11, 2), method="euclidean", no_ties=TRUE)
#> [1] -1 -2  0 -3

natural_hexachord <- c(0, 2, 4, 5, 7, 9)
hard_hexachord <- c(7, 9, 11, 0, 2, 4)
minimize_vl(natural_hexachord, hard_hexachord, method="hamming")
#> [1] 0 0 0 6 0 0
```
