# Elementary voice leadings

Calculate elementary voice leadings which represent motion by a single
arrow on a
[`brightnessgraph()`](https://satbq.github.io/musicMCT/reference/brightnessgraph.md).
`vlsig()` finds "**v**oice-**l**eading **sig**nature" of a set moving to
transpositions of itself, as determined by
[`vl_generators()`](https://satbq.github.io/musicMCT/reference/vl_generators.md).
`inter_vlsig()` finds the elementary voice leadings from a set to some
other set, i.e. where the `goal` parameter of
[`brightnessgraph()`](https://satbq.github.io/musicMCT/reference/brightnessgraph.md)
is not `NULL`. By default, `inter_vlsig()` finds voice leadings for
contextual inversions of a set.

## Usage

``` r
vlsig(set, index = NULL, display_digits = 2, edo = 12, rounder = 10)

inter_vlsig(
  set,
  goal = NULL,
  index = NULL,
  type = c("ascending", "commontone", "obverse"),
  display_digits = 2,
  edo = 12,
  rounder = 10
)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- index:

  Integer: which voice-leading generator should be displayed? Defaults
  to `NULL`, displaying all voice leadings.

- display_digits:

  Integer: how many digits to display when naming any non-integral
  interval sizes. Defaults to 2.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

- goal:

  For `inter_vlsig()` only, vector of the transposition type to voice
  lead to. Defaults to `NULL`, producing voice leadings to the inversion
  of `set`.

- type:

  For `inter_vlsig()` only. String: "ascending", "commontone", or
  "obverse". Defaults to "ascending", which makes the result prefer
  ascending voice leadings (as for `vlsig()`). The second makes the
  result prefer common tones (as might be expected for contextual
  inversions). The third option, "obverse", gives the obverse of a
  voice-leading in a sense that generalizes Morris (1998,
  [doi:10.2307/746047](https://doi.org/10.2307/746047) )'s concept for
  Neo-Riemannian PLR transformations. This option returns voice leadings
  that lead *to* `set` rather than away from it.

## Value

List with three elements:

- "vl" which shows the distance (in `edo` steps) that each voice moves,

- "tn" which indicates the (chromatic) transposition achieved by the
  voice leading,

- "rotation" which indicates the scalar transposition caused by the
  voice leading.

If `index=NULL`, returns instead a matrix whose rows are all the
elementary voice leadings.

## Details

Note that the voice leadings determined by `vlsig()` can be different
from the corresponding ones at the same \\T_n\\ level in
[`vl_rolodex()`](https://satbq.github.io/musicMCT/reference/VL_rolodex.md).
The latter function prioritizes minimal voice leadings, whereas
`vlsig()` prioritizes *elementary* voice leadings derived from a set's
[`brightnessgraph()`](https://satbq.github.io/musicMCT/reference/brightnessgraph.md).
In particular, this means that `vlsig()` voice leadings will always be
ascending, involve at least one common tone, and involve no contrary
motion. See the `odd_pentachord` voice leadings in the Examples.

For `vlsig()` the value "rotation" in the result is non-arbitrary: if
the rotation value is n, the voice leading takes `set` to the nth mode
of `set`. For `inter_vlsig()`, there is no canonical correspondence
between modes of `set` and `goal`, except to assume that the input modes
are the 1st mode of each scale. If `goal` is `NULL`, finding contextual
inversions of `set`, the first mode of the inversion is taken to be the
one that holds the first and last pitches of `set` in common. These
"rotation" values do not have a transparent relationship to the values
of `inter_vlsig()`'s index parameter.

For `inter_vlsig()` results are not as symmetric between `set` and
`goal` as you might expect. Since these voice-leading functions study
ascending arrows on a brightness graph the possibilities for *ascending
from X to Y* are in principle somewhat different from the possibilities
for *ascending from Y to X*. See the examples for the "Tristan genus."
Note that this is still true when `type="commontone"`, which might lead
to counterintuitive results.

## See also

[`vl_generators()`](https://satbq.github.io/musicMCT/reference/vl_generators.md)
and
[`brightnessgraph()`](https://satbq.github.io/musicMCT/reference/brightnessgraph.md)

## Examples

``` r
# Hook's elementary signature transformation
major_scale <- c(0, 2, 4, 5, 7, 9, 11)
vlsig(major_scale, index=1)
#> $vl
#> [1] 0 0 0 1 0 0 0
#> 
#> $tn
#> [1] 7
#> 
#> $rotation
#> [1] 4
#> 

pure_major_triad <- j(1, 3, 5)
vlsig(pure_major_triad, index=1)
#> $vl
#> [1] 0.00 1.12 1.82
#> 
#> $tn
#> [1] 4.98045
#> 
#> $rotation
#> [1] 1
#> 
vlsig(pure_major_triad, index=2)
#> $vl
#> [1] 0.71 0.00 1.82
#> 
#> $tn
#> [1] 8.843587
#> 
#> $rotation
#> [1] 2
#> 

odd_pentachord <- c(0, 1, 4, 9, 11) # in 15-edo
vlsig(odd_pentachord, index=2, edo=15)
#> $vl
#> [1] 2 3 4 0 1
#> 
#> $tn
#> [1] 8
#> 
#> $rotation
#> [1] 2
#> 
vl_rolodex(odd_pentachord, edo=15)$"8" 
#> [1] -3  1  0 -1 -2

# Contextual inversions for Tristan genus:
dom7 <- c(0, 4, 7, 10)
halfdim7 <- c(0, 3, 6, 10)
inter_vlsig(dom7, halfdim7)
#>      [,1] [,2] [,3] [,4]
#> [1,]    1    0    0    1
#> [2,]    2    0    0    0
#> [3,]    1    1    0    0
#> [4,]    1    0    1    0
inter_vlsig(halfdim7, dom7)
#>      [,1] [,2] [,3] [,4]
#> [1,]    0    1    1    0
#> [2,]    1    0    1    0
#> [3,]    1    1    0    0

# Elementary voice leadings between unrelated sets:
maj7 <- c(0, 4, 7, 11)
min7 <- c(0, 3, 7, 10)
inter_vlsig(min7, maj7)
#>      [,1] [,2] [,3] [,4]
#> [1,]    0    1    0    1
#> [2,]    2    0    0    0
brightnessgraph(min7, maj7)


# Elementary inversional VL for just diatonic which is NOT a Q-relation:
inter_vlsig(j(dia), index=3)
#> $vl
#> [1] 0.71 0.71 0.00 0.71 0.71 0.00 0.00
#> 
#> $tni
#> [1] 7.726274
#> 
#> $rotation
#> [1] 5
#> 

# Obverse voice leadings:
# First we see the Parallel transformation which leads from minor to major:
minor <- c(0, 3, 7)
P <- inter_vlsig(minor, index=1)
print(P)
#> $vl
#> [1] 0 1 0
#> 
#> $tni
#> [1] 7
#> 
#> $rotation
#> [1] 0
#> 
# Compare to its obverse, Slide, leading *to* minor from major:
S <- inter_vlsig(minor, index=1, type="obverse")
print(S)
#> $vl
#> [1] 1 0 1
#> 
#> $tni
#> [1] 6
#> 
#> $rotation
#> [1] 0
#> 
# A voice-leading plus its obverse is a chromatic transposition:
P$vl + S$vl
#> [1] 1 1 1
```
