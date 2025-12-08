# Random scales uniformly distributed on a hypersphere around an input

Sometimes you want to explore what other scale structures a given scale
is *close* to. This can be done by studying the network of color
adjacencies in suitably low cardinalities (see "Modal Color Theory,"
31-37), but it can also be rewarding simply to randomly sample scales
that are suitably close to the one you started with.

The larger your starting scale, the more complicated is the geometry of
the color space it lives in. Therefore this function generates a larger
number of random scales for larger cardinalities: by default, if the
length of the input `set` is `card`, `surround_set` gives `card * 100`
output scales. The parameter `magnitude` controls the order of magnitude
of your sample (i.e. if you want ~1000 scales rather than ~100, set
`magnitude=3`).

The size of the hypersphere which the function samples is, by
default, 1. When we're working with a unit of 12 semitones per octave, 1
semitone of voice leading work can get you pretty far away from the
original set, especially in higher cardinalities. (For instance, C major
to C melodic minor is just 1 semitone of motion, but there are 3 other
colors that intervene between these two scales along a direct path.)
Depending on your goals, you might want to try a couple different orders
of magnitude for `distance`.

## Usage

``` r
surround_set(set, magnitude = 2, distance = 1)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- magnitude:

  Numeric value specifying how many sets to return. Defaults to `2`.

- distance:

  How far (in units of voice leading work, using the Euclidean metric)
  should the sampled scales be from the input `set`?

## Value

a Matrix with `length(set)` rows and `10^magnitude` columns,
representing `10^magnitude` different scales

## Examples

``` r
# First we sample 30 trichords surrounding the minor triad 037.
chords_near_minor <- surround_set(c(0,3,7), magnitude=1, distance=.5)
chords_near_minor
#>          [,1]     [,2]     [,3]     [,4]     [,5]     [,6]     [,7]     [,8]
#> [1,] 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000
#> [2,] 3.493721 3.499343 2.971543 3.342546 2.506902 2.524288 2.586732 3.093497
#> [3,] 7.078991 7.025617 6.500810 7.364228 7.082793 6.846058 6.718558 6.508819
#>          [,9]    [,10]    [,11]    [,12]    [,13]    [,14]    [,15]    [,16]
#> [1,] 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000
#> [2,] 2.741607 3.061349 3.013718 2.532818 2.593822 2.776470 3.398752 2.516498
#> [3,] 7.428057 6.503778 7.499812 6.821840 7.291581 6.552748 6.698343 7.127381
#>         [,17]    [,18]    [,19]    [,20]    [,21]    [,22]    [,23]    [,24]
#> [1,] 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000
#> [2,] 3.212266 3.094961 3.375735 2.959655 2.669231 2.775124 3.444603 2.796047
#> [3,] 6.547293 6.509100 7.329884 7.498370 6.625044 7.446577 6.771247 7.456512
#>         [,25]    [,26]    [,27]    [,28]    [,29]    [,30]
#> [1,] 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000
#> [2,] 2.502848 3.453407 2.611042 2.515419 3.395293 2.552206
#> [3,] 7.053294 7.210765 6.685816 7.123211 7.306176 7.222443

# The next two commands will plot the sampled trichords on an x-y plane as
# circles; the minor triad that they surround is marked with a "+" sign.
plot(chords_near_minor[2,], chords_near_minor[3,], 
  xlab="Third", ylab="Fifth", asp=1)
points(3, 7, pch="+")

# The following two commands will plot the two lines (i.e. hyperplanes) that
# demarcate the boundaries of the minor triad's color. Most but not all
# of our randomly generated points should fall in the space between the 
# two lines, in the same region as the "+" representing 037.
abline(0, 2)
abline(6, 1/2)
```
