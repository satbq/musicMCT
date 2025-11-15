# Voice-leading inflection points

When considering an n-note set's potential voice leadings to
transpositions of a goal (along the lines of
[`vl_rolodex()`](https://satbq.github.io/musicMCT/reference/VL_rolodex.md)
and
[`tndists()`](https://satbq.github.io/musicMCT/reference/tndists.md)),
there will always be some transposition in continuous pc-space for which
a given modal rotation is the best potential target for voice leading.
(That is, there is always some `x` such that
`whichmodebest(set, tn(set, x)) == k` for any `k` between `1` and `n`.)
Moreover, there will always be a transposition level at the boundary
between two different ideal modes, where both modes require the same
amount of voice leading work. `flex_points()` identifies those
inflection points where one mode gives way to another. (Note:
`flex_points()` identifies these points by numerical approximation, so
it may not give exact values. For more precision, increase the value of
`subdivide`.)

## Usage

``` r
flex_points(
  set,
  goal = NULL,
  method = c("taxicab", "euclidean", "chebyshev", "hamming"),
  subdivide = 100,
  edo = 12,
  rounder = 10
)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- goal:

  Numeric vector like set: what is the tn-type of the voice leading's
  destination? Defaults to `NULL`, in which case the function uses `set`
  as the tn-type.

- method:

  What distance metric should be used? Defaults to `"taxicab"` but can
  be `"euclidean"`, `"chebyshev"`, or `"hamming"`.

- subdivide:

  Numeric: how many small amounts should each `edo` step be divided
  into? Defaults to `100`.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

Numeric vector of the transposition indices that are inflection points.
Length of result matches size of `set`, except in the case of some
multisets, which can have fewer inflection points.

## Examples

``` r
major_triad_12tet <- c(0, 4, 7)
major_triad_just <- z(1, 5/4, 3/2)
major_triad_19tet <- c(0, 6, 11)

flex_points(major_triad_12tet, method="euclidean", subdivide=1000)
#> [1] 2.083 6.000 9.916
flex_points(major_triad_just, method="euclidean", subdivide=1000)
#> [1] 2.070 6.000 9.929

# Note that the units of measurement correspond to edo.
# The value 3.16 here corresponds to exactly 1/6 of an octave.
flex_points(major_triad_19tet, edo=19)
#> [1]  3.16  9.50 15.83
```
