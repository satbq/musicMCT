# Sum brightness

["Modal Color Theory"](https://doi.org/10.1215/00222909-11595194) (p. 6)
describes two ways to measure the brightness of a scale. Sum brightness
is the simpler of the two. It simply adds together the heights of all
scale degrees above the tonic. See also Section 3.2 of "Bright notes,
dark scales."

## Usage

``` r
sum_brightness(set, mode = 0, edo = 12, rounder = 10)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- mode:

  Which mode of the scale is desired? Integer, defaults to 0.
  Zero-indexed, so that the default is to return the sum brightness of
  the entered `set`.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

Single numeric value: the sum brightness of the specified mode.

## Examples

``` r
c_major <- c(0, 2, 4, 5, 7, 9, 11)
d_major <- tn(c_major, 2, optic="p") # NB octave equivalent must NOT be used
c_dorian <- c(0, 2, 3, 5, 7, 9, 10)

sum_brightness(c_major)
#> [1] 38
sum_brightness(d_major)
#> [1] 38
sum_brightness(c_major, mode=1)
#> [1] 36
sum_brightness(c_dorian)
#> [1] 36
```
