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
#> [2,] 2.528013 2.842687 2.770242 2.673174 3.491849 2.884829 3.338647 3.104378
#> [3,] 7.165010 6.525392 7.444085 7.378398 6.910087 7.486555 6.632144 7.488984
#>          [,9]    [,10]    [,11]    [,12]    [,13]    [,14]    [,15]    [,16]
#> [1,] 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000
#> [2,] 3.436879 3.173626 3.471889 2.813787 3.109156 2.513383 3.176991 2.538543
#> [3,] 6.756819 7.468886 6.834710 7.464031 7.487939 7.114910 6.532374 6.807497
#>         [,17]    [,18]    [,19]    [,20]    [,21]    [,22]    [,23]    [,24]
#> [1,] 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000
#> [2,] 3.330148 3.017879 2.554148 2.782837 2.899530 3.459538 3.026788 2.749056
#> [3,] 7.375503 7.499680 7.226310 7.450378 7.489802 7.197040 7.499282 6.567534
#>         [,25]    [,26]    [,27]    [,28]    [,29]    [,30]
#> [1,] 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000
#> [2,] 3.314333 2.535786 2.844229 3.163838 3.338861 2.916954
#> [3,] 6.611163 6.814245 6.524884 7.472395 6.632341 7.493055

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
