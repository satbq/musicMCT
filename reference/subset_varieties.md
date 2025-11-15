# Specific varieties of scalar subsets given a generic shape

Considered mod 7, the traditional triads of a diatonic scale are all
instances of the generic shape (0, 2, 4). They come in three varieties:
major, minor, and diminished. This function lists the distinct varieties
of any similarly defined generic shape which occur as subsets in some
specified scale (or larger set).

## Usage

``` r
subset_varieties(subsetdegrees, set, unique = TRUE, edo = 12, rounder = 10)
```

## Arguments

- subsetdegrees:

  Vector of integers indicating the generic shape to use, e.g.
  `c(0, 2, 4)` for tertian triads in a heptachord. Expected to begin
  with `0` and must have length \> 1.

- set:

  The scale to find subsets of, as a numeric vector

- unique:

  Should each variety be listed only once? Defaults to `TRUE`. If
  `FALSE`, each specific variety will be listed corresponding to how
  many times it occurs as a subset.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

A numeric matrix whose columns represent the specific varieties of the
subset

## Examples

``` r
c_major_scale <- c(0, 2, 4, 5, 7, 9, 11)
double_harmonic_scale <- c(0, 1, 4, 5, 7, 8, 11)

subset_varieties(c(0, 2, 4), c_major_scale)
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    4    3    3
#> [3,]    7    7    6
subset_varieties(c(0, 2, 4), c_major_scale, unique=FALSE)
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7]
#> [1,]    0    0    0    0    0    0    0
#> [2,]    4    3    3    4    4    3    3
#> [3,]    7    7    7    7    7    7    6
subset_varieties(c(0, 2, 4), double_harmonic_scale)
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,]    0    0    0    0    0
#> [2,]    4    3    4    4    2
#> [3,]    7    7    6    8    6
```
