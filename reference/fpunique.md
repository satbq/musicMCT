# Unique real values up to some tolerance

Working with scales in continuous pitch space, many pitches and
intervals are irrationals represented as **f**loating **p**oint numbers.
This can cause arithmetic and rounding errors, leading to it looking
like there are more distinct pitches/intervals in the set than there
really are. Use `fpunique` rather than
[`base::unique()`](https://rdrr.io/r/base/unique.html) whenever you
handle scales in continuous pitch space.

## Usage

``` r
fpunique(x, MARGIN = 0, rounder = 10)
```

## Arguments

- x:

  Numeric array whose unique elements are to be determined

- MARGIN:

  Numeric `0`, `1`, or `2` depending on whether you want unique
  individual numbers, unique rows, or unique columns, respectively.
  Defaults to `0`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

Numeric array of unique elements (vector if `MARGIN` is 0; matrix
otherwise)

## Details

Sometimes you may need to adjust the tolerance (`rounder`) to get
correct results, especially if you have done several operations in a row
which may have introduced rounding errors.

## Examples

``` r
just_dia <- j(dia)
intervals_in_just_dia <- sort(as.vector(sim(just_dia)))
failed_unique_intervals <- unique(intervals_in_just_dia)
fpunique_intervals <- fpunique(intervals_in_just_dia)
length(failed_unique_intervals)
#> [1] 36
length(fpunique_intervals)
#> [1] 19
```
