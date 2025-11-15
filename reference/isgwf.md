# Is a scale n-wise well formed?

Tests whether a scale has a generalized type of well formedness
(pairwise or n-wise well formedness).

## Usage

``` r
isgwf(set, stepword = NULL, allow_de = FALSE, edo = 12, rounder = 10)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- stepword:

  A vector representing the ranked step sizes of a scale (e.g.
  `c(2, 2, 1, 2, 2, 2, 1)` for the diatonic). The distinct values of the
  `setword` should be consecutive integers. If you want to test a step
  word instead of a list of pitch classes, `set` must be entered as
  `NULL`.

- allow_de:

  Should the function test for degenerate well-formed and
  distributionally even scales too? Defaults to `FALSE`.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

Boolean: is the set n-wise well formed?

## Details

David Clampitt's 1997 dissertation ("Pairwise Well-Formed Scales:
Structural and Transformational Properties," SUNY Buffalo) offers a
generalization of the notion of well-formedness from 1-dimensional
structures with a single generator to 2-dimensional structures that
mediate between two well-formed scales. Ongoing research suggests that
this can be extended further to "n-wise" or "general" well-formedness,
though n-wise well-formed scales are increasingly rare as n grows
larger.

## Examples

``` r
meantone_diatonic <- c(0, 2, 4, 5, 7, 9, 11)
just_diatonic <- j(dia)
some_weird_thing <- convert(c(0, 1, 3, 6, 8, 12, 14), 17, 12)
example_scales <- cbind(meantone_diatonic, just_diatonic, some_weird_thing)

apply(example_scales, 2, howfree)
#> meantone_diatonic     just_diatonic  some_weird_thing 
#>                 1                 2                 3 
apply(example_scales, 2, isgwf)
#> meantone_diatonic     just_diatonic  some_weird_thing 
#>              TRUE              TRUE              TRUE 
```
