# Intersection of a line with a hyperplane

Navigate scale space by finding the point where a given line intersects
with a given hyperplane. Hyperplanes are specified by the `row` and
`ineqmat` parameters. That is, the hyperplane is given by the `row`th
row of the specified `ineqmat`. An arbitrary hyperplane can be specified
by entering `row=1` with the desired hyperplane as a 1-row matrix as the
input to `ineqmat`.

For the line, two different use cases are available. In the first, `set`
is specified. In this case, the line in question is the given `set`'s
"hue" (i.e., the line which runs from
[`edoo()`](https://satbq.github.io/musicMCT/reference/edoo.md) to
`set`). This is useful when exploring non-central arrangements such as
the Rothenberg arrangements
([`make_roth_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_roth_ineqmat.md));
for an arrangement centered on
[`edoo()`](https://satbq.github.io/musicMCT/reference/edoo.md), it will
simply return
[`edoo()`](https://satbq.github.io/musicMCT/reference/edoo.md). In the
second, `set` is left `NULL` and both `point` and `direction` must be
specified. Here, the given line is the one which runs through `point`
parallel to the vector specified by `direction`.

## Usage

``` r
move_to_hyperplane(
  row,
  set = NULL,
  point = NULL,
  direction = NULL,
  ineqmat = NULL,
  method = c("taxicab", "euclidean", "chebyshev", "hamming"),
  edo = 12,
  rounder = 10
)
```

## Arguments

- row:

  Integer specifying the hyperplane to be intersected as a row of
  `ineqmat`.

- set:

  Numeric vector representing a scale. Defaults to `NULL`; if specified,
  will give the intersecting line as the scale's "hue."

- point:

  Numeric vector representing a point on the line. Overridden by `set`.

- direction:

  Numeric vector representing the direction of the line. Overridden by
  `set`.

- ineqmat:

  Specifies which hyperplane arrangement to consider. By default (or by
  explicitly entering "mct") it supplies the standard "Modal Color
  Theory" arrangements of
  [`getineqmat()`](https://satbq.github.io/musicMCT/reference/makeineqmat.md),
  but can be set to strings "white," "black", "gray", "roth",
  "infrared", "pastel", "rosy", "infrared", or "anaglyph", giving the
  `ineqmat`s of
  [`make_white_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_white_ineqmat.md),
  [`make_black_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_black_ineqmat.md),
  [`make_gray_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_black_ineqmat.md),
  [`make_roth_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_roth_ineqmat.md),
  [`make_infrared_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_infrared_ineqmat.md),
  [`make_pastel_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_white_ineqmat.md),
  [`make_rosy_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_roth_ineqmat.md),
  [`make_infrared_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_infrared_ineqmat.md),
  or
  [`make_anaglyph_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_anaglyph_ineqmat.md).
  For other arrangements, this parameter accepts explicit matrices.

- method:

  What distance metric should be used? Defaults to `"taxicab"` but can
  be `"euclidean"`, `"chebyshev"`, or `"hamming"`.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

A list with three entries: `set`, `dist`, and `sign`. `set` is a numeric
vector with the intersection point of the given line and hyperplane.
`dist` gives the voice-leading distance (as measured using `method`)
from input `set` or `point` to the result `set`. `sign` indicates
whether the intersection point lies along the given `direction` or
opposite it. (For instance, when a hue is specified by input `set`, a
positive `sign` indicates that the intersection belongs to the same
color as input `set`, whereas a negative `sign` indicates that the
intersection is a scalar involution of the input.)

If the line lies entirely on the given hyperplane, the returned `set`
simply matches the input, while `dist` and `sign` are 0. If the line and
hyperplane do not intersect, the result `set` is a vector of `NA`s the
same length as the input `set` or `point`; `dist` is `Inf` and `sign` is
`NA`. In both of these cases, a warning is given.

## Examples

``` r
major_triad <- c(0, 4, 7)
# Let's fine the first point at which the major triad's hue intersects a Rothenberg hyperplane:
move_to_hyperplane(3, set=major_triad, ineqmat="roth")
#> $set
#> [1] 0 4 6
#> 
#> $dist
#> [1] 1
#> 
#> $sign
#> [1] 1
#> 
same_hue(major_triad, c(0, 4, 6))
#> [1] TRUE
strictly_proper(major_triad)
#> [1] TRUE
strictly_proper(c(0, 4, 6))
#> [1] FALSE

# But the major triad's hue intersects every MCT hyperplane at the center of the space:
move_to_hyperplane(3, set=major_triad, ineqmat="mct")
#> $set
#> [1] 0 4 8
#> 
#> $dist
#> [1] 1
#> 
#> $sign
#> [1] 0
#> 

# Let's move away from the major triad in other directions than its hue:
lower_third <- c(0, -1, 0)
move_to_hyperplane(1, point=major_triad, direction=lower_third)
#> $set
#> [1] 0.0 3.5 7.0
#> 
#> $dist
#> [1] 0.5
#> 
#> $sign
#> [1] 1
#> 
move_to_hyperplane(2, point=major_triad, direction=lower_third)
#> $set
#> [1] 0 5 7
#> 
#> $dist
#> [1] 1
#> 
#> $sign
#> [1] -1
#> 
move_to_hyperplane(3, point=major_triad, direction=lower_third)
#> $set
#> [1] 0 2 7
#> 
#> $dist
#> [1] 2
#> 
#> $sign
#> [1] 1
#> 
```
