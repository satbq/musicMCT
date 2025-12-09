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
#> [2,] 2.789168 2.797885 3.288326 3.450480 2.520147 3.428006 3.124236 3.465923
#> [3,] 6.546624 7.457329 7.408495 7.216952 6.859496 6.741522 6.515680 6.818573
#>          [,9]    [,10]    [,11]    [,12]    [,13]    [,14]    [,15]    [,16]
#> [1,] 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000
#> [2,] 2.944907 3.270939 2.900610 3.327283 2.978990 3.130979 2.831112 3.429341
#> [3,] 6.503044 6.579771 6.509978 7.378003 7.499558 7.482540 6.529387 6.743745
#>         [,17]    [,18]    [,19]    [,20]    [,21]    [,22]    [,23]    [,24]
#> [1,] 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000
#> [2,] 2.846127 3.399585 2.506605 2.842339 2.544667 3.214640 3.119971 3.120649
#> [3,] 6.524266 7.300552 7.081005 7.474492 6.793428 6.548414 7.485394 7.485226
#>         [,25]    [,26]    [,27]    [,28]    [,29]    [,30]
#> [1,] 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000
#> [2,] 2.568959 2.673112 2.656797 2.500078 2.934808 3.465186
#> [3,] 6.746616 6.621656 7.363609 7.008818 6.504268 6.816692

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
