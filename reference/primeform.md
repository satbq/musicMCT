# Prime form of a set using Rahn's algorithm

Takes a set (in any order, inversion, and transposition) and returns the
canonical ("prime") form that represents the \\T_n /T_n I\\-type to
which the set belongs. Uses the algorithm from Rahn 1980 rather than
Forte 1973.

## Usage

``` r
primeform(set, edo = 12, rounder = 10)
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

Numeric vector of same length as `set`

## Details

In principle this should work for sets in continuous pitch-class space,
not just those in a mod k universe. But watch out for rounding errors:
if you can manage to work with integer values, that's probably safer.
Otherwise, try rounding your set to various decimal places to test for
consistency of result.

## Examples

``` r
primeform(c(0, 3, 4, 8))
#> [1] 0 1 4 8
primeform(c(0, 1, 3, 7, 8))
#> [1] 0 1 5 6 8
primeform(c(0, 3, 6, 9, 12, 14), edo=16)
#> [1]  0  2  4  7 10 13
```
