# Find a scale mod k that matches a given color

Modal Color Theory is useful for analyzing scales in continuous
pitch-class space with irrational values, but sometimes those irrational
values can be inconvenient to work with. Therefore it's often quite
useful to find a scale that has the same color as the one you're
studying, but which can be represented by integers in some mod k
universe. See "Modal Color Theory," 27.

## Usage

``` r
quantize_color(
  set,
  nmax = 12,
  reconvert = FALSE,
  ineqmat = NULL,
  target_edo = NULL,
  edo = 12,
  rounder = 10
)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

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
vector of integers representing the quantized scale; element 2 is `edo`
representing the number k of unit steps in the mod k universe. If
`reconvert=TRUE`, returns a single numeric vector measured relative to
the unit step size input as `edo`: these generally will not be integers.
Values may be `NA` if no suitable quantization was found beneath the
limit given by `nmax` or in `target_edo` (if specified).

## Examples

``` r
qcm_fifth <- meantone_fifth()
qcm_lydian <- sort(((0:6)*qcm_fifth)%%12)
quantize_color(qcm_lydian)
#> $set
#> [1]  0  2  4  6  7  9 11
#> 
#> $edo
#> [1] 12
#> 

# Let's approximate the Werckmeister III well-temperament
werck_ratios <- c(1, 256/243, 64*sqrt(2)/81, 32/27, (256/243)*2^(1/4), 4/3, 
  1024/729, (8/9)*2^(3/4), 128/81, (1024/729)*2^(1/4), 16/9, (128/81)*2^(1/4))
werck3 <- z(werck_ratios)
quantize_color(werck3)
#> $set
#>  [1]  0  1  4  7  9 13 14 18 20 22 26 28
#> 
#> $edo
#> [1] 32
#> 
quantize_color(werck3, reconvert=TRUE)
#>  [1]  0.000  0.375  1.500  2.625  3.375  4.875  5.250  6.750  7.500  8.250
#> [11]  9.750 10.500

quantize_color(j(dia))
#> $set
#> [1]  0  3  5  6  9 11 14
#> 
#> $edo
#> [1] 15
#> 
quantize_color(j(dia), target_edo=22)
#> $set
#> [1]  0  4  7  9 13 16 20
#> 
#> $edo
#> [1] 22
#> 
```
