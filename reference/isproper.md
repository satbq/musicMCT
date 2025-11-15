# Rothenberg propriety

Rothenberg (1978,
[doi:10.1007/BF01768477](https://doi.org/10.1007/BF01768477) )
identifies a potentially desirable trait for scales which he calls
"propriety." Loosely speaking, a scale is proper if its specific
intervals are well sorted in terms of the generic intervals they belong
to. A scale is *strictly* proper if, given two generic sizes g and h
such that g \< h, every specific size corresponding to g is smaller than
every specific size corresponding to h. A scale if improper if any
specific size of g is larger than any specific size of h. An *ambiguity*
occurs if any size of g equals any size of h: scales with ambiguities
are weakly but not strictly proper.

## Usage

``` r
isproper(set, strict = FALSE, edo = 12, rounder = 10)

has_contradiction(set, edo = 12, rounder = 10)

strictly_proper(set, edo = 12, rounder = 10)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- strict:

  Boolean: should only strictly proper scales pass?

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

Boolean which answers whether the input satisfies the property named by
the function

## See also

[`make_roth_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_roth_ineqmat.md)
creates an `ineqmat` for a hyperplane arrangement that lets you explore
propriety-related issues in finer detail.

## Examples

``` r
c_major <- c(0, 2, 4, 5, 7, 9, 11)
has_contradiction(c_major)
#> [1] FALSE
strictly_proper(c_major)
#> [1] FALSE
isproper(c_major)
#> [1] TRUE
isproper(c_major, strict=TRUE)
#> [1] FALSE

isproper(j(dia), strict=TRUE)
#> [1] TRUE

pythagorean_diatonic <- sort(((0:6)*z(3/2))%%12)
isproper(pythagorean_diatonic)
#> [1] FALSE
has_contradiction(pythagorean_diatonic)
#> [1] TRUE
```
