# Subset varieties for all subsets of a fixed size

Applies
[`subset_varieties()`](https://satbq.github.io/musicMCT/reference/subset_varieties.md)
not just to a particular subset shape but to all possible subset shapes
given a fixed cardinality. For example, finds the specific varieties of
*all* trichordal subsets of the major scale, not than just the varieties
of the tonal triad. Comparable to
[`intervalspectrum()`](https://satbq.github.io/musicMCT/reference/intervalspectrum.md)
but for subsets larger than dyads.

## Usage

``` r
subsetspectrum(
  set,
  subsetcard,
  simplify = TRUE,
  mode = "tn",
  edo = 12,
  rounder = 10
)
```

## Arguments

- set:

  The scale to find subsets of, as a numeric vector

- subsetcard:

  Single integer defining the cardinality of subsets to consider

- simplify:

  Should "inversions" of a subset be ignored? Boolean, defaults to
  `TRUE`

- mode:

  String `"tn"` or `"tni"`. When defining subset shapes, use
  transposition or transposition & inversion to reduce the number of
  shapes to consider? Defaults to `"tn"`.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

A list whose length matches the number of distinct subset shapes (given
the chosen options). Each entry of the list is a matrix displaying the
varieties of some particular subset type.

## Details

The parameter `simplify` lets you control whether to consider different
"inversions" of a subset shape independently. For instance, with
`simplify=TRUE`, only root position triads (0, 2, 4) would be
considered; but with `simplify=FALSE`, the first inversion (0, 2, 5) and
second inversion (0, 3, 5) subset shapes would also be displayed.

## Examples

``` r
c_major_scale <- c(0, 2, 4, 5, 7, 9, 11)
subsetspectrum(c_major_scale, 3)
#> $`0, 1, 2`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    2    2    1
#> [3,]    4    3    3
#> 
#> $`0, 1, 3`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    2    1    2
#> [3,]    5    5    6
#> 
#> $`0, 1, 4`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    2    1    1
#> [3,]    7    7    6
#> 
#> $`0, 2, 3`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    4    3    4
#> [3,]    5    5    6
#> 
#> $`0, 2, 4`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    4    3    3
#> [3,]    7    7    6
#> 
subsetspectrum(c_major_scale, 3, simplify=FALSE)
#> $`0, 1, 2`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    2    2    1
#> [3,]    4    3    3
#> 
#> $`0, 1, 3`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    2    1    2
#> [3,]    5    5    6
#> 
#> $`0, 1, 4`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    2    1    1
#> [3,]    7    7    6
#> 
#> $`0, 1, 5`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    2    1    2
#> [3,]    9    8    8
#> 
#> $`0, 1, 6`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    2    2    1
#> [3,]   11   10   10
#> 
#> $`0, 2, 3`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    4    3    4
#> [3,]    5    5    6
#> 
#> $`0, 2, 4`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    4    3    3
#> [3,]    7    7    6
#> 
#> $`0, 2, 5`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    4    3    3
#> [3,]    9    9    8
#> 
#> $`0, 2, 6`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    4    3    4
#> [3,]   11   10   10
#> 
#> $`0, 3, 4`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    5    6    5
#> [3,]    7    7    6
#> 
#> $`0, 3, 5`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    5    5    6
#> [3,]    9    8    9
#> 
#> $`0, 3, 6`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    5    5    6
#> [3,]   11   10   11
#> 
#> $`0, 4, 5`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    7    7    6
#> [3,]    9    8    8
#> 
#> $`0, 4, 6`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    7    7    6
#> [3,]   11   10   10
#> 
#> $`0, 5, 6`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    9    9    8
#> [3,]   11   10   10
#> 
subsetspectrum(c_major_scale, 3, mode="tni") # Note the absence of a "0, 2, 3" matrix
#> $`0, 1, 2`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    2    2    1
#> [3,]    4    3    3
#> 
#> $`0, 1, 3`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    2    1    2
#> [3,]    5    5    6
#> 
#> $`0, 1, 4`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    2    1    1
#> [3,]    7    7    6
#> 
#> $`0, 2, 4`
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    4    3    3
#> [3,]    7    7    6
#> 
```
