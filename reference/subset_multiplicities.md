# Count the multiplicities of a subset-type's varieties

Given the varieties of a subset type returned by
[`subset_varieties()`](https://satbq.github.io/musicMCT/reference/subset_varieties.md),
`subset_multiplicities()` counts how many times each one occurs in the
scale. These are the multiplicities of the subsets in the sense of
[Clough and Myerson (1985)'s](https://www.jstor.org/stable/843615)
result "structure yields multiplicity" for well-formed scales.

## Usage

``` r
subset_multiplicities(
  subsetdegrees,
  set,
  edo = 12,
  rounder = 10,
  display_digits = 2
)
```

## Arguments

- subsetdegrees:

  Vector of integers indicating the generic shape to use, e.g.
  `c(0, 2, 4)` for tertian triads in a heptachord. Expected to begin
  with `0` and must have length \> 1.

- set:

  The scale to find subsets of, as a numeric vector

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

- display_digits:

  Integer: how many digits to display when naming any non-integral
  interval sizes. Defaults to 2.

## Value

Numeric vector whose names indicate the `k` varieties of the subset type
and whose entries count how often each variety occurs.

## Examples

``` r
subset_multiplicities(c(0, 2, 4), sc(7, 35))
#> (0, 3, 6) (0, 3, 7) (0, 4, 7) 
#>         1         3         3 
subset_multiplicities(c(0, 1, 4), sc(7, 35))
#> (0, 1, 6) (0, 1, 7) (0, 2, 7) 
#>         1         1         5 

subset_multiplicities(c(0, 2, 4), j(dia))
#>  (0, 2.94, 6.8)  (0, 3.16, 6.1) (0, 3.16, 7.02) (0, 3.86, 7.02) 
#>               1               1               2               3 
```
