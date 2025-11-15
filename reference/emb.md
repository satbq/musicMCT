# How many instances of a subset-type exist within a scale? How many scales embed a subset?

David Lewin's EMB and COV functions: see Lewin, *Generalized Musical
Intervals and Transformations* (New Haven, CT: Yale University Press,
1987), 105-120. For EMB, given a group ("CANON") of transformations
which are considered to preserve a set's type, find the number of
instances of that type in a larger set (`scale`). Lewin characterizes
this generally, but `emb()` only offers \\T_n\\ and \\T_n / T_nI\\
transformation groups as available canonical groups. Conversely, Lewin's
COV function asks how many instances of a `scale` type include `subset`:
this is implemented as `cover()` (not
[`cov()`](https://rdrr.io/r/stats/cor.html)!).

## Usage

``` r
emb(subset, scale, canon = c("tni", "tn"), edo = 12, rounder = 10)

cover(subset, scale, canon = c("tni", "tn"), edo = 12, rounder = 10)
```

## Arguments

- subset:

  Numeric vector of pitch-classes in any representative of the subset
  type (Lewin's X)

- scale:

  Numeric vector of pitch-classes in the larger set to embed into
  (Lewin's Y)

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

Integer: count of `subset` or `scale` types satisfying the desired
relation.

## Examples

``` r
emb(c(0, 4, 7), sc(7, 35))
#> [1] 6
emb(c(0, 4, 7), sc(7, 35), canon="tn")
#> [1] 3

# Works for continuous pc-space too:
emb(j(1, 3, 5), j(dia))
#> [1] 5
emb(j(1, 2, 3, 5, 6), j(dia))
#> [1] 2
emb(j(1, 2, 4, 5, 6), j(dia), canon="tn")
#> [1] 1

emb(c(0, 4, 7), c(0, 1, 3, 7))
#> [1] 1
emb(c(0, 4, 7), c(0, 1, 3, 7), canon="tn")
#> [1] 0

emb(c(0, 4), c(0, 4, 8))
#> [1] 3
cover(c(0, 4), c(0, 4, 8))
#> [1] 1

harmonic_minor <- c(0, 2, 3, 5, 7, 8, 11)
cover(c(0, 4, 8), harmonic_minor)
#> [1] 6
cover(c(0, 4, 8), harmonic_minor, canon="tn")
#> [1] 3
```
