# Frequency ratios to logarithmic pitch intervals (e.g. semitones)

Simple convenience function for converting frequency ratios to
semitones. Useful to have in addition to
[`j()`](https://satbq.github.io/musicMCT/reference/j.md) because
[`j()`](https://satbq.github.io/musicMCT/reference/j.md) is only defined
for specific common values. Defaults to 12-tone equal temperament but
`edo` parameter allows other units.

## Usage

``` r
z(..., edo = 12)
```

## Arguments

- ...:

  One or more numerics values which represent frequency ratios.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

## Value

Numeric vector representing the input ratios converted to `edo` unit
steps per octave

## Details

The name `z()` doesn't make a lot of sense but has the virtue of being a
letter that isn't otherwise very common. `r` (for ratio) and `q` (for
the rationals) were both avoided because they're already used for other
functions.

## See also

[`j()`](https://satbq.github.io/musicMCT/reference/j.md) is a more
convenient input method for the most common frequency ratios.

## Examples

``` r
z(81/80) == j(synt)
#> [1] TRUE

mod_jdia <- z(1, 10/9, 5/4, 4/3, 3/2, 5/3, 15/8)
minimize_vl(j(dia), mod_jdia)
#> [1]  0.0000000 -0.2150629  0.0000000  0.0000000  0.0000000  0.0000000  0.0000000

z(1, 5/4, 3/2, edo=53)
#> [1]  0.00000 17.06219 31.00301
```
