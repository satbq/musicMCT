# Transpositional combination & pitch multiplication

Cohn (1988, [doi:10.2307/745790](https://doi.org/10.2307/745790) )
defines transpositional combination as a procedure that generates a
pc-set as the union of two (or more) transpositions of some smaller set.
`tc()` takes the small set and a vector of transposition levels,
returning the larger pc-set that results. (Pierre Boulez referred to
this procedure as pitch "multiplication", which Amiot (2016,
[doi:10.1007/978-3-319-45581-5](https://doi.org/10.1007/978-3-319-45581-5)
) shows to be not at all fanciful, as a convolution of two pitch-class
sets.)

## Usage

``` r
tc(set, multiplier = NULL, edo = 12, rounder = 10)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- multiplier:

  Numeric vector of transposition levels to apply to `set`. If not
  specified, defaults to `set`.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

Numeric vector of length \\\leq\\ `length(set)` \\\cdot\\
`length(multiplier)`

## Examples

``` r
tc(c(0, 4), c(0, 7))
#> [1]  0  4  7 11
tc(c(0, 7), c(0, 4))
#> [1]  0  4  7 11

pyth_tetrachord <- j(1, t, dt, 4)
pyth_dia <- tc(pyth_tetrachord, j(1, 5))
same_hue(pyth_dia, c(0, 2, 4, 5, 7, 9, 11))
#> [1] TRUE
```
