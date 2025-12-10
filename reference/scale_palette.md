# Orbit of a scale under symmetries of hyperplane arrangement

Given an input scale, return a "palette" of related scalar colors. All
the returned scales are the image of the input under some
[`ineqsym()`](https://satbq.github.io/musicMCT/reference/ineqsym.md).
The symmetry group used to define the orbit is the symmetries of the
modal color theory arrangements given by
[`makeineqmat()`](https://satbq.github.io/musicMCT/reference/makeineqmat.md).
Although `scale_palette()` gives the option of finding palettes with
respect to other hyperplane arrangements, not that they may not all have
the same underlying symmetries. It may not be the case that all scales
in a palette have the same properties with respect to an arbitrary
arrangement.

## Usage

``` r
scale_palette(
  set,
  include_involution = TRUE,
  ineqmat = NULL,
  edo = 12,
  rounder = 10
)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- include_involution:

  Should involutional symmetry be included in the applied transformation
  group? Defaults to `TRUE`.

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

A matrix whose columns represent the colors in `set`'s palette.

## Examples

``` r
# The palette of a minor triad is all inversions of major and minor:
minor_triad <- c(0, 3, 7)
scale_palette(minor_triad)
#>      [,1] [,2] [,3] [,4] [,5] [,6]
#> [1,]    0    0    0    0    0    0
#> [2,]    3    4    5    5    4    3
#> [3,]    7    9    8    9    7    8

# But 12edo is a little too convenient. The palette of the just minor triad
# involves some less-consonant intervals:
just_minor <- j(1, m3, 5)
scale_palette(just_minor)
#>          [,1]     [,2]     [,3]     [,4]     [,5]     [,6]
#> [1,] 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000
#> [2,] 3.156413 3.863137 4.980450 4.843587 4.136863 3.019550
#> [3,] 7.019550 8.843587 8.136863 8.980450 7.156413 7.863137

# The palette of the diatonic scale includes all 42 well-formed heptachord colors:
dia_palette <- scale_palette(sc(7, 35))
dim(dia_palette)
#> [1]  7 42
table(apply(dia_palette, 2, iswellformed))
#> 
#> TRUE 
#>   42 

# The Rothenberg arrangements do not have the same symmetries as the MCT arrangements,
# so Rothenberg properties are not preserved in a palette:
proper_trichord <- c(0, 5, 10)
roth_palette <- suppressWarnings(scale_palette(proper_trichord, ineqmat="roth"))
apply(roth_palette, 2, isproper)
#> [1] TRUE TRUE TRUE TRUE
# Not all the scales in this palette are "proper" even though the input was!
```
