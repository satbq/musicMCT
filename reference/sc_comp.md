# Set class complement

Find the complement of a set class in a given mod k universe.
Complements have long been recognized in pitch-class set theory as
sharing many properties with each other. This is true to *some* extent
when considering scales in continuous pc-space, but sometimes it is not!
Therefore whenever you're exploring an odd property that a scale has, it
can be useful to check that scale's complement (if you've come across
the scale in some mod k context, of course).

## Usage

``` r
sc_comp(set, canon = c("tni", "tn"), edo = 12, rounder = 10)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- canon:

  What transformations should be considered equivalent? Defaults to
  "tni" (using standard set classes) but can be "tn" (using
  transposition classes)

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

Numeric vector representing a set class of length `edo - n` where `n` is
the length of the input `set`

## Examples

``` r
diatonic19 <- c(0, 3, 6, 9, 11, 14, 17)
chromatic19 <- sc_comp(diatonic19, edo=19)
icvecs_19 <- rbind(ivec(diatonic19, edo=19), ivec(chromatic19, edo=19))
rownames(icvecs_19) <- c("diatonic ivec", "chromatic ivec")
icvecs_19
#>                [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9]
#> diatonic ivec     0    2    5    0    4    3    0    6    1
#> chromatic ivec    5    7   10    5    9    8    5   11    6
```
