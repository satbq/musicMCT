# Test for transpositional symmetry

Does the set map onto itself at some transposition other than \\T_0\\?
That is, does it map onto itself under \\T_n\\ for some appropriate
\\n\\? `tsym()` can return either `TRUE`/`FALSE` or an index of symmetry
but defaults to the former. `tsym_index()` is a simple wrapper for
`tsym()` that returns the latter. `tsym_degree()` counts the total
number of transpositional symmetries.

## Usage

``` r
tsym(set, return_index = FALSE, edo = 12, rounder = 10)

tsym_index(set, ...)

tsym_degree(set, ...)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- return_index:

  Should the function return a specific index at which the set is
  symmetrical? Defaults to `FALSE`.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

- ...:

  Arguments to be passed to `tsym()`

## Value

By default, `tsym()` returns `TRUE` if the set has non-trivial
transpositional symmetry, `FALSE` otherwise. If `return_index` is
`TRUE`, returns a vector of transposition levels at which the set is
symmetric, including `0`. `tsym_index()` is a wrapper for `tsym()` which
sets `return_index` to `TRUE`. `tsym_degree()` gives the degree of
symmetry, which is simply the length of `tsym_index()`'s value.

## Examples

``` r
tsym(sc(6, 34))
#> [1] FALSE
tsym(sc(6, 35))
#> [1] TRUE
tsym(edoo(5))
#> [1] TRUE

# Works for continuous values:
tsym(tc(j(dia), edoo(3)))
#> [1] TRUE


# Index and Degree:
tsym_index(c(0, 1, 3, 6, 7, 9))
#> [1] 0 6
tsym_degree(edoo(7))
#> [1] 7
```
