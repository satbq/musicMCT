# Reference numbers for scale structures

As described on p. 28 of "Modal Color Theory," it's convenient to have a
systematic labeling system ("color numbers") to refer to the distinct
colors in the hyperplane arrangements. This serves a similar function as
Forte's set class numbers do in traditional pitch-class set theory.
Color numbers are defined with reference to a complete list of the
possible sign vectors for each cardinality, so they depend on the
extensive prior computation that is stored in the object
`representative_signvectors`. (This is a large file that cannot be
included in the package musicMCT itself. It needs to be downloaded
separately, saved in your working directory, and loaded by entering
`representative_signvectors <- readRDS("representative_signvectors.rds")`.
Color numbers are currently only defined for scales with 7 or fewer
notes.

## Usage

``` r
colornum(set, ineqmat = NULL, signvector_list = NULL, edo = 12, rounder = 10)
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

- signvector_list:

  A list of signvectors to use as the reference by which `colornum`
  assigns a value. Defaults to `NULL` and will attempt to use
  `representative_signvectors`, which needs to be downloaded and
  assigned separately from the package musicMCT. (If a named `ineqmat`
  other than "mct" is chosen, the function attempts to replace a `NULL`
  signvector list with a corresponding object in the global environment.
  For instance, if `ineqmat="pastel"` then the function tries to use
  `pastel_signvectors` for `signvector_list`.)

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

Single non-negative integer (the color number) if a `signvector_list` is
specified or `representative_signvectors` is loaded; otherwise `NULL`

## Details

Note that the perfectly even "white" scale is number `0` for every
cardinality by definition.

The function assumes that you don't need to be reminded of the
cardinality of the set you've entered. That is, there's a color number 2
for every cardinality, so you can get that value returned by entering a
trichord, tetrachord, etc.

## Examples

``` r
colornum(edoo(5))
#> [1] 0
colornum(c(0, 3, 7))
#> NULL
colornum(c(0, 2, 7))
#> NULL
colornum(c(0, 1, 3, 7))
#> NULL
colornum(c(0, 1, 3, 6, 10, 15, 21), edo=33)
#> NULL
colornum(c(0, 2, 4, 5, 7, 9, 11))
#> NULL
```
