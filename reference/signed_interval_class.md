# Ordered pitch-class interval represented as interval class with sign

Represents an ordered interval between two pitch-classes as a value
between `-edo/2` and `edo/2`, i.e. with an absolute value that matches
its interval class as well as a sign (plus or minus) that disambiguates
between the two OPCIs included in the interval-class. That is, C-\>D is
`2` whereas C-\>B-flat is `-2`. Exactly half the octave is represented
as a positive value.

## Usage

``` r
signed_interval_class(x, edo = 12)
```

## Arguments

- x:

  Single numeric value, representing an ordered pitch-class interval

- edo:

  Number of unit steps in an octave. Defaults to `12`.

## Value

Single numeric value

## Examples

``` r
signed_interval_class(8)
#> [1] -4
signed_interval_class(6)
#> [1] 6
signed_interval_class(-6)
#> [1] 6
signed_interval_class(3*pi)
#> [1] -2.575222
```
