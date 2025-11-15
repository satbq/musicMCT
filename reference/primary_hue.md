# Primary colors

In traditional pitch-class set theory, concepts like normal order and
[`primeform()`](https://satbq.github.io/musicMCT/reference/primeform.md)
establish a canonical representative for each equivalence class of
pitch-class sets. It's useful to do something similar in MCT as well:
given a family of scales, such as the collection of modes or a
[`scale_palette()`](https://satbq.github.io/musicMCT/reference/scale_palette.md),
we can define the "primary color" of the family as the one that comes
first when the scales' sign vectors are ordered lexicographically.
`primary_hue()` uses
[`ineqsym()`](https://satbq.github.io/musicMCT/reference/ineqsym.md) to
return a specific representative of the primary color which belongs to
the same palette of hues as the input. Because `primary_hue()` focuses
on hues rather than colors, it may not highlight the fact that two
scales have the same primary color. Thus, for information about broader
families, `primary_colornum()` returns the color number of the primary
color, `primary_signvector()` returns the sign vector, and
`primary_color()` itself uses
[`quantize_color()`](https://satbq.github.io/musicMCT/reference/quantize_color.md)
to return a consistent representative of each color.

## Usage

``` r
primary_hue(
  set,
  type = c("all", "half_palette", "modes"),
  ineqmat = NULL,
  edo = 12,
  rounder = 10
)

primary_colornum(set, type = "all", signvector_list = NULL, ...)

primary_signvector(set, type = "all", ...)

primary_color(set, type = "all", nmax = 12, reconvert = FALSE, ...)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- type:

  How broad of an equivalence class should be considered? May be one of
  three options:

  - "all", the default, uses the full range of
    [`scale_palette()`](https://satbq.github.io/musicMCT/reference/scale_palette.md)
    relationships

  - "half_palette" uses
    [`scale_palette()`](https://satbq.github.io/musicMCT/reference/scale_palette.md)
    with `include_involution=FALSE`

  - "modes" uses only the n modes of `set`

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

- signvector_list:

  A list of signvectors to use as the reference by which `colornum`
  assigns a value. Defaults to `NULL` and will attempt to use
  `representative_signvectors`, which needs to be downloaded and
  assigned separately from the package musicMCT. (If a named `ineqmat`
  other than "mct" is chosen, the function attempts to replace a `NULL`
  signvector list with a corresponding object in the global environment.
  For instance, if `ineqmat="pastel"` then the function tries to use
  `pastel_signvectors` for `signvector_list`.)

- ...:

  Arguments to be passed to `primary_hue()`

- nmax:

  Integer, essentially a limit to how far the function should search
  before giving up. Although every real color should have a rational
  representation in some mod k universe, for some colors that k must be
  very high. Increasing nmax makes the function run longer but might be
  necessary if small chromatic universes don't produce a result.
  Defaults to `12`.

- reconvert:

  Boolean. Should the scale be converted to the input edo? Defaults to
  `FALSE`.

## Value

A numeric vector representing a scale for `primary_hue()`; a single
integer for `primary_colornum()`; a
[`signvector()`](https://satbq.github.io/musicMCT/reference/signvector.md)
for `primary_signvector()`; and a list like
[`quantize_color()`](https://satbq.github.io/musicMCT/reference/quantize_color.md)
for `primary_color()`.

## Examples

``` r
major_64 <- c(0, 5, 9)
primary_hue(major_64)
#> [1] 0 3 7
primary_hue(major_64, type="modes")
#> [1] 0 3 8

viennese_trichord <- c(0, 6, 11)
# Same primary color as major_64:
apply(cbind(major_64, viennese_trichord), 2, primary_signvector)
#>      major_64 viennese_trichord
#> [1,]       -1                -1
#> [2,]       -1                -1
#> [3,]       -1                -1

# But a different primary hue:
primary_hue(viennese_trichord)
#> [1] 0 2 5

# Only works with representative_signvectors loaded:
primary_colornum(major_64) == primary_colornum(viennese_trichord)
#> logical(0)

primary_color(major_64)
#> $set
#> [1] 0 1 3
#> 
#> $edo
#> [1] 6
#> 
primary_color(viennese_trichord)
#> $set
#> [1] 0 1 3
#> 
#> $edo
#> [1] 6
#> 
```
