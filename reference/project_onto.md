# Closest point on a given flat

Projects a scale onto the nearest point that lies on a target flat of
the hyperplane arrangement. `project_onto()` determines the target flat
from a list of linearly independent rows in `ineqmat` which define the
flat. `match_flat()` determines the target by extrapolating from a given
scale on that flat. Note that while the projection lies on the desired
flat (i.e. it will have all of the necessary `0`s in its sign vector),
it will not necessarily belong to any particular *color*. (That is,
projection doesn't give you control over the `1`s and `-1`s of the sign
vector.)

## Usage

``` r
project_onto(
  set,
  target_rows,
  ineqmat = NULL,
  start_zero = TRUE,
  edo = 12,
  rounder = 10
)

match_flat(
  set,
  target_scale,
  start_zero = TRUE,
  ineqmat = NULL,
  edo = 12,
  rounder = 10
)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- target_rows:

  An integer vector: each integer specifies a row of `ineqmat` which
  helps to determine the target flat. The rows must be linearly
  independent.

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

- start_zero:

  Boolean: should the result be transposed so that its pitch initial is
  zero? Defaults to `TRUE`.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

- target_scale:

  A numeric vector which represents a scale on the target flat.

## Value

A numeric vector of same length as `set`, representing the projection of
`set` onto the flat determined by `target_rows` or `target_scale`.

## Examples

``` r
minor_triad <- c(0, 3, 7)
project_onto(minor_triad, 3)
#> [1] 0.0 3.0 7.5
project_onto(minor_triad, 1)
#> [1] 0.0 3.5 7.0
project_onto(minor_triad, c(1, 3))
#> [1] 0 4 8
# This last projection results in the perfectly even scale
# because that's the only scale on both hyperplanes 1 and 3.

major_scale <- c(0, 2, 4, 5, 7, 9, 11)
projected_just_dia <- match_flat(j(dia), major_scale)
print(projected_just_dia)
#> [1]  0.000000  1.946930  3.893860  5.026535  6.973465  8.920395 10.867326

# This is very close to fifth-comma meantone:
fifth_comma_meantone <- sim(sort(((0:6) * meantone_fifth(1/5))%%12))[,5]
vl_dist(projected_just_dia, fifth_comma_meantone)
#> [1] 0.04915723
```
