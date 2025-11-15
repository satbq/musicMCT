# Forte number from set class

Given a pitch-class set (in 12edo only), look up Forte 1973's catalog
number for the corresponding set class.

## Usage

``` r
fortenum(set)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

## Value

Character string in the form "n-x" where n is the number of notes in the
set and x is the ordinal position in Forte's list.

## Examples

``` r
fortenum(c(0, 4, 7))
#> [1] "3-11"
fortenum(c(0, 3, 7))
#> [1] "3-11"
fortenum(c(4, 8, 11))
#> [1] "3-11"
```
