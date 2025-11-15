# Create a scale from a sign vector

This function attempts to take in a sign vector (and associated
cardinality and `ineqmat`) and create a scale whose sign vector matches
the input. This is not always possible because not all sign vectors
correspond to colors that actually exist (just like there is no Fortean
set class with the interval-class vector `<1 1 0 1 0 0>`). The function
will do its best but may eventually time out, using a similar process as
[`quantize_color()`](https://satbq.github.io/musicMCT/reference/quantize_color.md).
You can increase the search time by increasing `nmax`, but in some cases
you could search forever and still find nothing. I don't advise trying
to use this function on many sign vectors at the same time.

## Usage

``` r
set_from_signvector(
  signvec,
  card,
  nmax = 12,
  reconvert = FALSE,
  ineqmat = NULL,
  target_edo = NULL,
  edo = 12,
  rounder = 10
)
```

## Arguments

- signvec:

  Vector of `0`, `-1`, and `1`s: the sign vector that you want to
  realize.

- card:

  Integer: the number of notes in your desired scale.

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

- target_edo:

  Numeric (expected integer) determining a specific equal division of
  the octave to quantize to. Defaults to `NULL`, in which any potential
  `edo` will be accepted.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

If `reconvert=FALSE`, a list of two elements: element 1 is `set` with a
vector of integers representing the realized scale; element 2 is `edo`
representing the number k of unit steps in the mod k universe. If
`reconvert=TRUE`, returns a single numeric vector converted to
measurement relative to 12-tone equal tempered semitones. Values may be
`NA` if no suitable quantization was found beneath the limit given by
nmax or in target_edo (if specified).

## Examples

``` r
# This first command produces a real tetrachord:
set_from_signvector(c(-1, 1, 1, -1, -1, -1, 0, -1), 4)
#> $set
#> [1] 0 2 5 6
#> 
#> $edo
#> [1] 10
#> 

# But this one, which changes only the last entry of the previous sign vector
# has no solution so will return only `NA`s.
set_from_signvector(c(-1, 1, 1, -1, -1, -1, 0, 1), 4)
#> $set
#> [1] NA NA NA NA
#> 
#> $edo
#> [1] NA
#> 
  
```
