# Test for inversional symmetry

Is the pc-set **i**nversionally **sym**metrical? That is, does it map
onto itself under \\T_n I\\ for some appropriate \\n\\? `isym()` can
return either `TRUE`/`FALSE` or an index of symmetry but defaults to the
former. `isym_index()` is a simple wrapper for `isym()` that returns the
latter. `isym_degree()` counts the total number of inversional
symmetries (i.e. the number of distinct inversional axes of symmetry).

## Usage

``` r
isym(set, return_index = FALSE, edo = 12, rounder = 10)

isym_index(set, ...)

isym_degree(set, ...)
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

  Arguments to be passed to `isym()`

## Value

`isym()` returns the Boolean value from testing for symmetry, unless
`return_index=TRUE`, in which case isym() and `isym_index()` return a
numeric value for one index of inversion at which the set is
symmetrical. If the set is not inversionally symmetrical, they will
return `NA`. `isym_degree()` gives the degree of inversional symmetry.

## Details

`isym()` is evaluated by asking whether, for some appropriate rotation,
the step-interval series of the given set is equal to the step-interval
series of the set's inversion. This is designed to work for sets in
continuous pc-space, not just integers mod k. Note also that this
calculates abstract pitch-class symmetry, not potential symmetry in
pitch space. (See the second example.)

## Examples

``` r
#### Mod 12
isym(c(0, 1, 5, 8))
#> [1] TRUE
isym(c(0, 2, 4, 8))
#> [1] TRUE

#### Continuous Values
qcm_fifth <- meantone_fifth()
qcm_dia <- sort(((0:6)*qcm_fifth)%%12)
just_dia <- j(dia)
isym(qcm_dia)
#> [1] TRUE
isym(just_dia)
#> [1] FALSE

#### Rounding matters:
isym(qcm_dia, rounder=15)
#> [1] FALSE

### Index and Degree
hexatonic_scale <- c(0, 1, 4, 5, 8, 9)
isym_index(hexatonic_scale) # Only returns one suitable index
#> [1] 9
isym_degree(hexatonic_scale)
#> [1] 3
```
