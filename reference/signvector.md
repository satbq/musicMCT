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

`vl_signvector()` is a convenience wrapper that computes the sign vector
of a voice leading rather than a set. It applies
[`coord_from_edo()`](https://satbq.github.io/musicMCT/reference/coord_to_edo.md)
to its first argument and defaults to "infrared" for its `ineqmat`
argument.

## Usage

``` r
signvector(set, ineqmat = NULL, edo = 12, rounder = 10)

vl_signvector(vl, ineqmat = "infrared", edo = 12, rounder = 10)
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

- vl:

  Numeric vector representing a voice leading, whose entries should
  represent the motions of voices in registral order from low to high.
  (That is, the first entry should represent the motion of the lowest
  voice, and the last entry should represent the motion of the highest
  voice.) Only used by `vl_signvector()`, where it substitutes for
  `signvector()`'s `set` argument.

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

# For voice leadings, consider the opening of *Tristan und Isolde*:
tristan_chord <- c(5, 11, 3, 8)
v7_of_a <- c(4, 8, 2, 11)
tristan_vl <- v7_of_a - tristan_chord
vl_signvector(tristan_vl)
#>  [1] -1 -1 -1  1  1  1  0  1 -1  1  1  1 -1  1  1  1 -1  1  1  1  1
# which is identical to
signvector(coord_from_edo(tristan_vl), ineqmat="infrared")
#>  [1] -1 -1 -1  1  1  1  0  1 -1  1  1  1 -1  1  1  1 -1  1  1  1  1
```
