# Define a tempered fifth for various meantone scales

Creates an interval that approximates a pure 3:2 fifth which has been
tempered smaller by some fraction of a syntonic comma, making it easy to
construct diatonic meantone scales. The default is to create a
quarter-comma meantone fifth (i.e. about 697 cents).

## Usage

``` r
meantone_fifth(frac = 1/4)
```

## Arguments

- frac:

  The fraction of a syntonic comma that the fifth should be tempered by.
  Defaults to `1/4`. Numeric.

## Value

Single numeric value of the tempered fifth measured in 12edo semitones.

## Examples

``` r
zarlino_fifth <- meantone_fifth(2/7)
zarlino_diatonic <- sort((0:6 * zarlino_fifth) %% 12)
print(zarlino_diatonic)
#> [1]  0.000000  1.916207  3.832414  5.748621  6.958103  8.874310 10.790517

fifth_in_19edo <- convert(11, 19, 12)
meantone_fifth(1/3) - fifth_in_19edo
#> [1] 0.0004939556
```
