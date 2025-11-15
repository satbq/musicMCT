# Distinguish different types of interval equalities

Not all hyperplanes are made equal. Those which represent "formal
tritone" comparisons and those which are "exceptional" because they
check a scale degree twice ("Modal Color Theory," 40-41) play a
different role in the structure of the hyperplane arrangement than the
rest. This function returns a "fingerprint" of a scale which is like
[`countsvzeroes()`](https://satbq.github.io/musicMCT/reference/whichsvzeroes.md)
but which counts the different types of hyperplane separately.

## Usage

``` r
svzero_fingerprint(set, ineqmat = NULL, edo = 12, rounder = 10)
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

Numeric vector with 3 entries: the number of 'normal' hyperplanes the
set lies on, the number of 'exceptional' hyperplanes, and the number of
hyperplanes which compare a formal tritone to itself.

## Examples

``` r
# Two hexachords on the same number of hyperplanes but with different fingerprints
hex1 <- c(0, 1, 3, 5, 8, 9)
hex2 <- c(0, 1, 3, 5, 6, 9)
countsvzeroes(hex1) == countsvzeroes(hex2)
#> [1] TRUE
svzero_fingerprint(hex1)
#> [1] 3 4 1
svzero_fingerprint(hex2)
#> [1] 1 6 1

# Their brightness graphs make their difference more apparent:
brightnessgraph(hex1)

brightnessgraph(hex2)

```
