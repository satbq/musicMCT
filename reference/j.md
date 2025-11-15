# Convenient just-intonation intervals and scales

It's not hard to define a just interval from a frequency ratio: it only
requires an input like `12*log2(freq_ratio)`. That gets pretty tiresome
if you're doing this a lot, though, so for convenience `musicMCT`
includes a `j()` function (not related to [Clough and Douthett's J
function](https://www.jstor.org/stable/843811) but it wishes it was).
`j()` is designed to behave a lot like base R's
[`c()`](https://rdrr.io/r/base/c.html) in the way that you'd use it to
define a scale (see the examples below). The inputs that this can take
are limited and hard-coded, since there's no systematic way to define
short hands for every potential just interval. In general, the logic is
that individual digits refer to major intervals up from the tonic in the
5-limit just diatonic scale. The prefix "m" to a number (e.g. "m3")
gives the equivalent minor version of the interval. If you just want the
entire 5-limit diatonic, you can enter `dia`.

## Usage

``` r
j(..., edo = 12)
```

## Arguments

- ...:

  One or more names that will be matched to just intervals. You can
  enter these as strings, but for convenience sake you needn't. Here are
  the currently accepted inputs, their meaning, and their return value:

  - `1`: perfect 1th (0 semitones)

  - `u`: unison (0 semitones)

  - `synt`: syntonic comma (~.215 semitones)

  - `pyth`: Pythagorean comma (~.235 semitones)

  - `l`: Pythagorean limma (256:243 or ~.9 semitones)

  - `s`: 5-limit just semitone (16:15 or ~1.12 semitones)

  - `st`: 5-limit just semitone (16:15 or ~1.12 semitones)

  - `m2`: 5-limit minor second (16:15 or ~1.12 semitones)

  - `h`: half step (16:15 or ~1.12 semitones)

  - `a`: Pythagorean apotome (2187:2048 or ~1.14 semitones)

  - `mt`: 5-limit minor tone (10:9 or ~1.82 semitones)

  - `2`: 3-limit major second (9:8 or ~2.04 semitones)

  - `t`: 3-limit whole tone (9:8 or ~2.04 semitones)

  - `w`: whole tone (9:8 or ~2.04 semitones)

  - `wt`: whole tone (9:8 or ~2.04 semitones)

  - `sept`: 7-limit (septimal) whole tone (8:7 or ~2.31 semitones)

  - `sdt`: 3-limit semiditone (32/27 or ~2.94 semitones)

  - `pm3`: Pythagorean minor third (32/27 or ~2.94 semitones)

  - `m3`: 5-limit minor third (6:5 or ~3.16 semitones)

  - `3`: 5-limit major third (5:4 or ~3.86 semitones)

  - `M3`: 5-limit major third (5:4 or ~3.86 semitones)

  - `dt`: 3-limit ditone (81/64 or ~4.08 semitones)

  - `4`: 3-limit perfect fourth (4:3 or ~4.98 semitones)

  - `utt`: 11-limit tritone (11:8 or ~5.51 semitones)

  - `stt`: 7-limit tritone (7:5 or ~5.83 semitones)

  - `jtt`: 5-limit tritone (45:32 or ~5.90 semitones)

  - `ptt`: 3-limit tritone (729:512 or ~6.12 semitones)

  - `pd5`: 3-limit diminished fifth (1024/729 or ~5.88 semitones)

  - `5`: 3-limit perfect fifth (3:2 or ~7.02 semitones)

  - `m6`: 5-limit minor sixth (8:5 or ~8.14 semitones)

  - `6`: 5-limit major sixth (5:3 or ~8.84 semitones)

  - `pm7`: Pythagorean minor seventh (16:9 or ~9.96 semitones)

  - `m7`: 5-limit minor seventh (9:5 or ~10.18 semitones)

  - `7`: 5-limit major seventh (15:8 or ~10.88 semitones)

  - `8`: 2-limit perfect octave (2:1 or 12 semitones)

  - `dia`: the complete 5-limit diatonic scale

- edo:

  Number of unit steps in an octave. Defaults to `12`.

## Value

Numeric vector representing the input just intervals converted to `edo`
unit steps per octave

## See also

[`z()`](https://satbq.github.io/musicMCT/reference/z.md) as a shortcut
for 12\*log2(x) when a just interval you need isn't defined for `j()`.

## Examples

``` r
major_triad <- j(1,3,5)
isTRUE(all.equal(major_triad, j(u, M3, "5")))
#> [1] TRUE

isTRUE(all.equal(j(dia), j(1,2,3,4,5,6,7)))
#> [1] TRUE

# How far is the twelve-equal major scale from the 5-limit just diatonic?
dist(rbind(c(0,2,4,5,7,9,11), j(dia)))
#>           1
#> 2 0.2434172

# Is 53-equal temperament a good approximation of the 5-limit just diatonic?
j(dia, edo=53)
#> [1]  0.000000  9.006025 17.062189 21.996987 31.003013 39.059176 48.065202
```
