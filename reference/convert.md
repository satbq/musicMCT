# Convert between octave measurements

By default the period of a scale (normally the octave) has a size of 12
units (semitones). But it can be useful to convert to a different
measurement unit, e.g. to compare a scale defined in 19-tone equal
temperament (19edo) to the size of its intervals when measured in normal
12edo semitones, or vice versa.

## Usage

``` r
convert(x, edo1, edo2)
```

## Arguments

- x:

  The set to convert as a numeric vector.

- edo1:

  The size of the period measured in the same units as the input `x`.
  Numeric.

- edo2:

  The period size to convert to. Numeric.

## Value

A numeric vector the same length as `x` representing the input set
converted to the desired cardinality (`edo2`).

## Examples

``` r
maqam_rast <- c(0, 2, 3.5, 5, 7, 9, 10.5)
convert(maqam_rast, 12, 24)
#> [1]  0  4  7 10 14 18 21

perfect_fifth <- z(3/2)
lydian_scale <- sort((perfect_fifth * (0:6)) %% 12)
convert(lydian_scale, 12, 53)
#> [1]  0.000000  9.006025 18.012050 27.018075 31.003013 40.009038 49.015063
```
