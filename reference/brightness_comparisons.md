# Voice-leading brightness relationships for a scale's modes

The essential step in creating the brightness graph of a scale's modes
is to compute the pairwise comparisons between all the modes. Which ones
are strictly brighter than others according to "voice-leading
brightness" (see "Modal Color Theory," 6-7)? This function makes those
pairwise comparisons in a manner that's useful for more computation.

## Usage

``` r
brightness_comparisons(set, goal = NULL, edo = 12, rounder = 10)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- goal:

  Numeric vector of same length as set. Defaults to `NULL`.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

If `goal=NULL`, an n-by-n matrix where n is the size of the scale. Row i
represents mode i of the scale in comparison to all n modes. If the
entry in row i, column j is `-1`, then mode i is "voice-leading darker"
than mode j. If `1`, mode i is "voice-leading brighter". If 0, mode i is
neither brighter nor darker, either because contrary motion is involved
or because mode i is identical to mode j. (Entries on the principal
diagonal are always 0.)

If `goal` is a set, the result is a 2n-by-2n matrix whose first n rows
and columns represent the modes of `set` and whose last n rows and
columns represent the modes of `goal`. (Thus the upper left n-by-n
square is the same as if `goal` were `NULL` and the lower right n-by-n
square is the result of entering `goal` as `set` with an empty goal
parameter. The upper-right and lower-left quadrants of the matrix make
comparisons between the modes of `set` and `goal`.) The meaning of
entries `-1`, `0`, and `1` are as above.

## Details

Note that the returned value shows all voice-leading brightness
comparisons, not just the transitive reduction of those comparisons.
(That is, dorian is shown as darker than ionian even though mixolydian
intervenes in the brightness graph.)

## See also

[`brightnessgraph()`](https://satbq.github.io/musicMCT/reference/brightnessgraph.md)
for a human-readable presentation of the same information.

## Examples

``` r
# Because the diatonic scale, sc7-35, is non-degenerate well-formed, the only
# 0 entries should be on its diagonal.
brightness_comparisons(sc(7, 35))
#>   1  2  3  4  5  6  7
#> 1 0 -1 -1 -1 -1 -1 -1
#> 2 1  0  1  1 -1  1  1
#> 3 1 -1  0  1 -1 -1  1
#> 4 1 -1 -1  0 -1 -1 -1
#> 5 1  1  1  1  0  1  1
#> 6 1 -1  1  1 -1  0  1
#> 7 1 -1 -1  1 -1 -1  0

mystic_chord <- sc(6,34)
colSums(sim(mystic_chord)) # The sum brightnesses of the mystic chord's 6 modes
#> [1] 25 31 31 31 31 31
brightness_comparisons(mystic_chord) 
#>   1  2  3  4  5  6
#> 1 0 -1 -1 -1 -1 -1
#> 2 1  0  0  0  0  0
#> 3 1  0  0  0  0  0
#> 4 1  0  0  0  0  0
#> 5 1  0  0  0  0  0
#> 6 1  0  0  0  0  0
# Almost all 0s because very few mode pairs are comparable.
# That's because nearly all modes have the same sum, which means they have sum-brightness
# ties, and voice-leading brightness can't break a sum-brightness tie.
# (See "Modal Color Theory," 7.)

major <- c(0, 4, 7)
minor <- c(0, 3, 7)
brightness_comparisons(major, minor)
#>    1  2  3 4  5  6
#> 1  0  0 -1 1 -1 -1
#> 2  0  0 -1 1 -1 -1
#> 3  1  1  0 1  1  1
#> 4 -1 -1 -1 0 -1 -1
#> 5  1  1 -1 1  0  0
#> 6  1  1 -1 1  0  0
```
