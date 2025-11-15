# Scalar (and interscalar) interval matrix

As defined by Tymoczko 2008 ("Scale Theory, Serial Theory and Voice
Leading")
[doi:10.1111/j.1468-2249.2008.00257.x](https://doi.org/10.1111/j.1468-2249.2008.00257.x)
, the **s**calar **i**nterval **m**atrix represents the "rotations" of a
set, transposed to begin on 0, in its columns. Its nth row represents
the specific intervals which represent its generic interval of size n.
If changed from its default (`NULL`), the parameter `goal` calculates
Tymoczko's *interscalar* interval matrix from `set` to `goal`.

## Usage

``` r
sim(set, goal = NULL, edo = 12, rounder = 10)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- goal:

  Numeric vector of same length as set. Defaults to `NULL`.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

Numeric `n` by `n` matrix where `n` is the number of notes in `set`

## Examples

``` r
diatonic_modes <- sim(c(0, 2, 4, 5, 7, 9, 11))
print(diatonic_modes)
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7]
#> [1,]    0    0    0    0    0    0    0
#> [2,]    2    2    1    2    2    2    1
#> [3,]    4    3    3    4    4    3    3
#> [4,]    5    5    5    6    5    5    5
#> [5,]    7    7    7    7    7    7    6
#> [6,]    9    9    8    9    9    8    8
#> [7,]   11   10   10   11   10   10   10

miyakobushi_modes <- sim(c(0, 1, 5, 7, 8)) # rows show trivalence
print(miyakobushi_modes)
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,]    0    0    0    0    0
#> [2,]    1    4    2    1    4
#> [3,]    5    6    3    5    5
#> [4,]    7    7    7    6    9
#> [5,]    8   11    8   10   11

# Interscalar Interval Matrix:
sim(c(0, 3, 6, 10), c(0, 4, 7, 10))
#>      [,1] [,2] [,3] [,4]
#> [1,]    0    1    1    0
#> [2,]    4    4    4    2
#> [3,]    7    7    6    6
#> [4,]   10    9   10    9

# Note that the interscalar matrices factor out transposition:
minor <- c(0, 3, 7)
major <- c(0, 4, 7)
sim(minor, major)
#>      [,1] [,2] [,3]
#> [1,]    0    1    0
#> [2,]    4    4    5
#> [3,]    7    9    9
sim(minor-1, major)
#>      [,1] [,2] [,3]
#> [1,]    0    1    0
#> [2,]    4    4    5
#> [3,]    7    9    9
sim(minor, major+2)
#>      [,1] [,2] [,3]
#> [1,]    0    1    0
#> [2,]    4    4    5
#> [3,]    7    9    9

# But not permutation:
major_64 <- c(0, 5, 9)
major_open <- c(0, 7, 4)
sim(minor, major_64)
#>      [,1] [,2] [,3]
#> [1,]    0    2    2
#> [2,]    5    6    5
#> [3,]    9    9   10
sim(minor, major_open)
#>      [,1] [,2] [,3]
#> [1,]    0    4   -3
#> [2,]    7    1    5
#> [3,]    4    9   12
```
