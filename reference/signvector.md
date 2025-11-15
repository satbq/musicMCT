# Detect a scale's location relative to a hyperplane arrangement

As "Modal Color Theory" describes (pp. 25-26), each distinct scalar
"color" is determined by its relationships to the hyperplanes that
define the space. For any scale, this function calculates a sign vector
that compares the scale to each hyperplane and returns a vector
summarizing the results. If the scale lies on hyperplane 1, then the
first entry of its sign vector is `0`. If it lies below hyperplane 2,
then the second entry of its sign vector is `-1`. If it lies above
hyperplane 3, then the third entry of its sign vector is `1`. Two scales
with identical sign vectors belong to the same "color".

## Usage

``` r
signvector(set, ineqmat = NULL, edo = 12, rounder = 10)
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

A vector whose entries are `0`, `-1`, or `1`. Length of vector equals
the number of hyperplanes in `ineqmat`.

## Examples

``` r
# 037 and 016 have identical sign vectors because they belong to the same trichordal color
signvector(c(0, 3, 7))
#> [1] -1 -1 -1
signvector(c(0, 1, 6))
#> [1] -1 -1 -1

# Just and equal-tempered diatonic scales have different sign vectors because they have 
# different internal structures (e.g. 12edo dia is generated but just dia is not). 
dia_12edo <- c(0, 2, 4, 5, 7, 9, 11)
just_dia <- j(dia)
isTRUE( all.equal( signvector(dia_12edo), signvector(just_dia) ) )
#> [1] FALSE
```
