# Specify a scale's step pattern with a sign vector

Rather than calculate the full sign vector from the "modal color"
hyperplane arrangement, sometimes it's advantageous to use a sign vector
that reflects only the pairwise comparisons on a scale's steps. This
function does that.

## Usage

``` r
step_signvector(set, ineqmat = NULL, edo = 12, rounder = 10)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

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

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

A vectors of signs, `-1`, `0`, and `1`, corresponding to the
step-related hyperplanes in the defined `ineqmat`.

## Examples

``` r
step_signvector(sc(7, 35)) # Half the length of a full sign vector for heptachords:
#>  [1] -1 -1  0  0  1  1 -1  0  0 -1 -1  0  0 -1  0 -1  0  0 -1  0  0
signvector(sc(7, 35))
#>  [1] -1 -1  0  0  1  1 -1  0  0 -1 -1  0  0 -1  0 -1  0  0 -1  0  0  0  0  1 -1
#> [26]  0 -1 -1  0 -1 -1  1  0  0  1  0 -1 -1  0  0  0  0
```
