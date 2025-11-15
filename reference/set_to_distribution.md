# Convert between pitch-class sets and distributions

For applications of the Discrete Fourier Transform to pitch-class set
theory, it's typically convenient to represent musical sets in terms of
*distributions* rather than lists of their elements. (See Chapter 1 of
Amiot 2016,
[doi:10.1007/978-3-319-45581-5](https://doi.org/10.1007/978-3-319-45581-5)
.) These functions convert back and forth between those representations.
s2d() and d2s() are shorthands for set_to_distribution() and
distribution_to_set(), respectively.

## Usage

``` r
set_to_distribution(set, edo = 12, rounder = 10)

distribution_to_set(
  distro,
  multiset = TRUE,
  reconvert = TRUE,
  edo = 12,
  rounder = 10
)

s2d(...)

d2s(...)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set. May be a multiset, in
  which case the result is different from the corresponding set with
  repetitions removed. Entries must be integers.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

- distro:

  Numeric vector representing a pitch-class distribution.

- multiset:

  Boolean. Should distribution_to_set() return a multiset if element
  weights are greater than 1? Defaults to `TRUE`.

- reconvert:

  Boolean. Should the scale be converted to the input edo? Defaults to
  `TRUE`.

- ...:

  Arguments to be passed from s2d() or d2s() to unabbreviated functions.

## Value

set_to_distribution() returns a numeric vector with length `edo`, whose
`i`th entry represents the weight assigned to pitch-class `i` in the
distribution. distribution_to_set() returns a (multi)set represented by
listing its elements in a vector. (Non-integer weights are rounded *up*
to the next highest integer if `multiset` is `TRUE`.)

## Examples

``` r
set_to_distribution(c(0, 4, 7))
#>  [1] 1 0 0 0 1 0 0 1 0 0 0 0
s2d(c(0, 4, 7)) # Same result but quicker to type
#>  [1] 1 0 0 0 1 0 0 1 0 0 0 0
s2d(c(0, 4, 4, 7)) # The doubled third is reflected by the value 2 in the result
#>  [1] 1 0 0 0 2 0 0 1 0 0 0 0

minor_triad_distro <- c(2, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0)
distribution_to_set(minor_triad_distro)
#> [1] 0 0 3 7
d2s(minor_triad_distro, multiset=FALSE)
#> [1] 0 3 7

# distribution_to_set automatically converts to 12edo, which
# can sometimes be undesirable, as in this case:
tresillo_distro <- c(1, 0, 0, 1, 0, 0, 1, 0)
d2s(tresillo_distro) 
#> [1] 0.0 4.5 9.0
d2s(tresillo_distro, reconvert=FALSE)
#> $set
#> [1] 0 3 6
#> 
#> $edo
#> [1] 8
#> 
```
