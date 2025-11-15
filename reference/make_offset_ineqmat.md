# Translate a hyperplane arrangement to a new center

By default, the various hyperplane arrangements of musicMCT treat the
"white" perfectly even scale as their center. (It is the point where all
the hyperplanes of the MCT, white, and black arrangements intersect, and
although the Rothenberg arrangements do not pass through the scale by
definition, it is still a center of symmetry for them.) This function
let you construct hyperplane arrangements that have been shifted to
treat any other set as their center. (Details on why you might want this
to come.)

## Usage

``` r
make_offset_ineqmat(set, ineqmat = NULL, edo = 12)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set intended to be the center
  of the new arrangement

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

## Value

A matrix with the same shape as the ones that define the standard
arrangement of type `ineqmat`

## See also

[`makeineqmat()`](https://satbq.github.io/musicMCT/reference/makeineqmat.md)
for modal color theory arrangements;
[`make_white_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_white_ineqmat.md),
[`make_black_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_black_ineqmat.md),
and
[`make_roth_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_roth_ineqmat.md)
for other relevant arrangements.

## Examples

``` r
# When used for the sign vector with any central arrangement, the
# input `set` will have a sign vector of all 0s:
viennese_trichord <- c(0, 1, 6)
signvector(viennese_trichord, ineqmat=make_offset_ineqmat(viennese_trichord))
#> [1] 0 0 0

# Where does melodic minor lie in relation to major?
major <- c(0, 2, 4, 5, 7, 9, 11)
melmin <- c(0, 2, 3, 5, 7, 9, 11)
signvector(melmin, ineqmat=make_offset_ineqmat(major, ineqmat="white"))
#>  [1]  0 -1  0  0  0  0 -1  0  0  0  0  1  1  1  1  0  0  0  0  0  0
```
