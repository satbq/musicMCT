# Transposition class of a given pc-set

Uses Rahn's algorithm to calculate the best normal order for the
transposition class represented by a given set. Reflects transpositional
but not inversional equivalence, i.e. all major triads return (0, 4, 7)
and all minor triads return (0, 3, 7).

## Usage

``` r
tnprime(set, edo = 12, rounder = 10)
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

Numeric vector of same length as `set` representing the set's Tn-prime
form

## Examples

``` r
tnprime(c(2, 6, 9))
#> [1] 0 4 7
tnprime(c(0, 3, 6, 9, 14), edo=16)
#> [1]  0  2  5  8 11
```
