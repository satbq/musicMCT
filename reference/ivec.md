# Interval-class vector

The classic summary of a set's dyadic subset content from pitch-class
set theory. The name `ivec` is short for **i**nterval-class **vec**tor.

## Usage

``` r
ivec(set, edo = 12)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- edo:

  Number of unit steps in an octave. Defaults to `12`.

## Value

Numeric vector of length `floor(edo/2)`

## Examples

``` r
ivec(c(0, 1, 4, 6))
#> [1] 1 1 1 1 1 1
ivec(c(0, 1, 3, 7))
#> [1] 1 1 1 1 1 1

#### Z-related sextuple in 24edo:
sextuple <- matrix(
  c(0, 1, 2, 6, 8, 10, 13, 16,
  0, 1, 3, 7, 9, 11, 12, 17,
  0, 1, 6, 8, 10, 13, 14, 16,
  0, 1, 7, 9, 11, 12, 15, 17,
  0, 1, 2, 4, 8, 10, 13, 18,
  0, 2, 3, 4, 8, 10, 15, 18), nrow=6, byrow=TRUE)
apply(sextuple, 1, ivec, edo=24) # The ic-vectors are the 6 identical columns of the output matrix
#>       [,1] [,2] [,3] [,4] [,5] [,6]
#>  [1,]    2    2    2    2    2    2
#>  [2,]    3    3    3    3    3    3
#>  [3,]    2    2    2    2    2    2
#>  [4,]    2    2    2    2    2    2
#>  [5,]    2    2    2    2    2    2
#>  [6,]    3    3    3    3    3    3
#>  [7,]    2    2    2    2    2    2
#>  [8,]    4    4    4    4    4    4
#>  [9,]    2    2    2    2    2    2
#> [10,]    3    3    3    3    3    3
#> [11,]    2    2    2    2    2    2
#> [12,]    1    1    1    1    1    1
```
