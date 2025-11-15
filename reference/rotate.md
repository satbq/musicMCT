# Circular rotation of an ordered tuple

Changes which element of a circularly-ordered series is in the first
position without otherwise changing the order. Used primarily to
generate the modes of a scale. Single application moves one element from
the beginning of a tuple to the end.

## Usage

``` r
rotate(x, n = 1, transpose_up = FALSE, edo = 12)
```

## Arguments

- x:

  Vector to be rotated

- n:

  Number of positions the vector should be rotated left. Defaults to
  `1`. May be negative.

- transpose_up:

  Boolean, defaults to `FALSE` which leaves entries unchanged. If set to
  `TRUE`, elements moved from the head to the tail of the vector are
  increased in value by `edo`.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

## Value

(Rotated) vector of same length as x

## Examples

``` r
rotate(c(0, 2, 4, 5, 7, 9, 11), n=2)
#> [1]  4  5  7  9 11  0  2
rotate(c(0, 2, 4, 5, 7, 9, 11), n=-2)
#> [1]  9 11  0  2  4  5  7
rotate(c(0, 2, 4, 5, 7, 9, 11), n=2, transpose_up=TRUE)
#> [1]  4  5  7  9 11 12 14
rotate(c(0, 2, 4, 5, 7, 9, 11), n=2, transpose_up=TRUE, edo=15)
#> [1]  4  5  7  9 11 15 17
rotate(c("father", "charles", "goes", "down", "and", "ends", "battle"),
  n=4)
#> [1] "and"     "ends"    "battle"  "father"  "charles" "goes"    "down"   
```
