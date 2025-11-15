# Voice leadings between inversions with maximal common tones

Clampitt (2007, 467;
[doi:10.1007/978-3-642-04579-0_46](https://doi.org/10.1007/978-3-642-04579-0_46)
) defines two \\n\\-note sets to be Q-related if they:

- Have all but one tone in common

- Are related by
  [`tni()`](https://satbq.github.io/musicMCT/reference/tn.md)

- Have a strictly crossing-free voice leading which preserves all
  \\n-1\\ common tones This function finds all sets which are Q-related
  to an input `set` in this sense. The relation is defined to generalize
  the smooth voice leadings between consonant triads and diatonic scales
  to other sets, in particular demonstrating that non-singular pairwise
  well-formed scales (see
  [`isgwf()`](https://satbq.github.io/musicMCT/reference/isgwf.md))
  demonstrate similarly nice voice leading properties.

(Strictly speaking, Clampitt includes
[`tn()`](https://satbq.github.io/musicMCT/reference/tn.md) in the second
part of the definition. However, the first criterion is only possible
under [`tn()`](https://satbq.github.io/musicMCT/reference/tn.md) if the
set is generated and therefore inversionally symmetrical. Therefore if a
set satisfies Clampitt's definition by
[`tn()`](https://satbq.github.io/musicMCT/reference/tn.md), it also
satisfies the
[`tni()`](https://satbq.github.io/musicMCT/reference/tn.md)
requirement.)

If the third part of the definition is relaxed, allowing the voice
leading to involve voice crossing, Clampitt (1997, 121) identifies this
as the Q\*-relation. The Q\*-relation can be computed with this function
by setting `method="hamming"`. (All other methods provided by
[`vl_dist()`](https://satbq.github.io/musicMCT/reference/vl_dist.md)
give equivalent results in this context.)

## Usage

``` r
clampitt_q(
  set,
  index = NULL,
  method = c("taxicab", "euclidean", "chebyshev", "hamming"),
  edo = 12,
  rounder = 10
)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- index:

  Integer: which Q-related set and voice leading should be returned?
  Defaults to `NULL`, in which case all options are returned.

- method:

  What distance metric should be used? Defaults to `"taxicab"` but can
  be `"euclidean"`, `"chebyshev"`, or `"hamming"`.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

A list with two entries, `"sets"` and `"vls"`. The former is a matrix
whose columns are the sets which are Q-related to the input `set`, in
OPC-normal form. The latter is a matrix whose rows represent the
voice-leading motions which transform `set` into its goals. (This
follows the general practice of musicMCT of representing scales as
columns and voice leadings as rows.) The rows of `"vls"` correspond to
the columns of `"sets"`, but the columns of `"vls"` correspond to the
order of the input `set`, which may not match the normal form of the
output `sets`. (See the last example.)

## See also

[`isgwf()`](https://satbq.github.io/musicMCT/reference/isgwf.md),
[`minimize_vl()`](https://satbq.github.io/musicMCT/reference/minimize_vl.md),
[`normal_form()`](https://satbq.github.io/musicMCT/reference/normal_form.md)

## Examples

``` r
# The Neo-Riemannian P, L, and R transformations on triads are all Q-relations:
major_triad <- c(0, 4, 7)
clampitt_q(major_triad)
#> $sets
#>      [,1] [,2] [,3]
#> [1,]    9    0    4
#> [2,]    0    3    7
#> [3,]    4    7   11
#> 
#> $vls
#>      [,1] [,2] [,3]
#> [1,]    0    0    2
#> [2,]    0   -1    0
#> [3,]   -1    0    0
#> 

# A well-formed scale like the diatonic has two Q-relations given by its signature transformations:
major_scale <- c(0, 2, 4, 5, 7, 9, 11)
clampitt_q(major_scale)
#> $sets
#>      [,1] [,2]
#> [1,]    4    6
#> [2,]    5    7
#> [3,]    7    9
#> [4,]    9   11
#> [5,]   10    0
#> [6,]    0    2
#> [7,]    2    4
#> 
#> $vls
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7]
#> [1,]    0    0    0    0    0    0   -1
#> [2,]    0    0    0    1    0    0    0
#> 

# A non-singular pairwise well-formed scale also has Q-relations:
clampitt_q(j(dia))
#> $sets
#>           [,1]      [,2]
#> [1,]  5.902237 10.882687
#> [2,]  7.019550  0.000000
#> [3,]  8.843587  1.824037
#> [4,] 10.882687  3.863137
#> [5,]  0.000000  4.980450
#> [6,]  2.039100  7.019550
#> [7,]  3.863137  8.843587
#> 
#> $vls
#>      [,1]       [,2] [,3]      [,4] [,5] [,6] [,7]
#> [1,]    0  0.0000000    0 0.9217872    0    0    0
#> [2,]    0 -0.2150629    0 0.0000000    0    0    0
#> 

# Set-class 7-31 is pairwise well-formed:
clampitt_q(sc(7, 31))
#> $sets
#>      [,1] [,2]
#> [1,]   10    1
#> [2,]    0    3
#> [3,]    1    4
#> [4,]    3    6
#> [5,]    4    7
#> [6,]    6    9
#> [7,]    7   10
#> 
#> $vls
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7]
#> [1,]    0    0    0    0    0    0    1
#> [2,]   -2    0    0    0    0    0    0
#> 
# It also has two additional Q*-related sets:
clampitt_q(sc(7, 31), method="hamming")
#> $sets
#>      [,1] [,2] [,3] [,4]
#> [1,]   10    7    4    1
#> [2,]    0    9    6    3
#> [3,]    1   10    7    4
#> [4,]    3    0    9    6
#> [5,]    4    1   10    7
#> [6,]    6    3    0    9
#> [7,]    7    4    1   10
#> 
#> $vls
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7]
#> [1,]    0    0    0    0    0    0    1
#> [2,]    0    0    0    0    4    0    0
#> [3,]    0    0   -5    0    0    0    0
#> [4,]   -2    0    0    0    0    0    0
#> 

# Most other types of scales have at most one Q-relation:
dominant_seventh <- c(0, 4, 7, 10)
clampitt_q(dominant_seventh)
#> $sets
#>      [,1]
#> [1,]    2
#> [2,]    4
#> [3,]    7
#> [4,]   10
#> 
#> $vls
#>      [,1] [,2] [,3] [,4]
#> [1,]    2    0    0    0
#> 

# The order of "sets" may not match the order of "vls":
clampitt_q(c(0, 1, 4, 7))
#> $sets
#>      [,1]
#> [1,]    1
#> [2,]    4
#> [3,]    7
#> [4,]    8
#> 
#> $vls
#>      [,1] [,2] [,3] [,4]
#> [1,]   -4    0    0    0
#> 
```
