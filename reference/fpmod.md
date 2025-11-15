# Modulo division with rounding

When working with sets in continuous pitch-class spaces (i.e., where
octave equivalence is needed), R's normal operator for modulo division
`%%` does not always give ideal results. Values that are very close to
(but below) the octave appear to be far from 0. This function uses
rounding to give octave-equivalent results that music theorists expect.

## Usage

``` r
fpmod(set, edo = 12, rounder = 10)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

Numeric vector the same length as `set`

## Examples

``` r
really_small <- 1e-13
c_major <- c(0, 4, 7, 12-really_small)
c_major %% 12
#> [1]  0  4  7 12
fpmod(c_major, 12)
#> [1] 0 4 7 0
```
