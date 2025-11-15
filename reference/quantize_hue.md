# Find a scale mod k that matches a given hue

Given any scale, attempts to find a scale defined as integers mod k
which belongs to the same hue as the input (i.e. would return `TRUE`
when
[`same_hue()`](https://satbq.github.io/musicMCT/reference/same_hue.md)
is applied). This function thus is similar in spirit to
[`quantize_color()`](https://satbq.github.io/musicMCT/reference/quantize_color.md)
but seeks a more precise structural match between input and
quantization. Note, though, that while
[`quantize_color()`](https://satbq.github.io/musicMCT/reference/quantize_color.md)
should always be able to find a suitable quantization (if `nmax` is set
high enough), this is not necessarily true for `quantize_hue()`. There
are lines in \\\mathbb{R}^n\\ which pass through no rational points but
the origin, so some hues (including ones of musical interest like the
5-limit just diatonic scale) may not have any quantization.

## Usage

``` r
quantize_hue(
  set,
  nmax = 12,
  reconvert = FALSE,
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
Values may be NA if no suitable quantization was found beneath the limit
given by nmax or in target_edo (if specified).

## Examples

``` r
meantone_diatonic <- sort(((0:6)*meantone_fifth())%%12)
quantize_hue(meantone_diatonic) # Succeeds
#> $set
#> [1]  0  2  4  6  7  9 11
#> 
#> $edo
#> [1] 12
#> 
quantize_hue(j(dia), nmax=15) # Fails no matter how high you set nmax.
#> $set
#> [1] NA NA NA NA NA NA NA
#> 
#> $edo
#> [1] NA
#> 

quasi_guido <- convert(c(0, 2, 4, 5, 7, 9), 13, 12)
quantize_color(quasi_guido)
#> $set
#> [1] 0 2 4 5 7 9
#> 
#> $edo
#> [1] 12
#> 
quantize_hue(quasi_guido)
#> $set
#> [1] 0 2 4 5 7 9
#> 
#> $edo
#> [1] 13
#> 

quantize_hue(c(0, 1, 4, 6))
#> $set
#> [1] 0 1 4 6
#> 
#> $edo
#> [1] 12
#> 
quantize_hue(c(0, 1, 4, 6), target_edo=16)
#> $set
#> [1] 0 2 6 9
#> 
#> $edo
#> [1] 16
#> 
```
