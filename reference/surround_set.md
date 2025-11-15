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
#> [2,] 3.083813 2.501046 2.720217 2.563604 2.500808 3.315032 3.018807 3.495122
#> [3,] 6.507075 6.967678 6.585607 6.755953 7.028410 6.611728 7.499646 6.930325
#>          [,9]    [,10]    [,11]    [,12]    [,13]    [,14]    [,15]    [,16]
#> [1,] 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000
#> [2,] 2.601380 3.494183 3.039113 3.224196 2.620499 3.077897 2.573504 3.389612
#> [3,] 6.698169 7.076045 7.498468 7.446919 6.674456 6.506105 6.739038 6.686627
#>         [,17]    [,18]    [,19]    [,20]    [,21]    [,22]    [,23]    [,24]
#> [1,] 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000
#> [2,] 2.579265 3.482897 2.528547 2.818097 3.498024 3.131580 3.481920 3.359322
#> [3,] 6.729847 7.129656 7.166528 6.534263 7.044412 7.482376 6.866761 6.652311
#>         [,25]    [,26]    [,27]    [,28]    [,29]    [,30]
#> [1,] 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000
#> [2,] 3.483796 2.774007 3.065531 2.913186 2.517886 2.796639
#> [3,] 6.873739 7.446013 6.504313 6.507594 7.132536 6.543224

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
