# Coordinate systems for scale representation

Usually, it is most intuitive to music theorists to represent a scale as
a vector of the pitch-classes it contains. However, for certain
computations in the setting of Modal Color Theory, it is more convenient
to use a coordinate system with the "white" perfectly even scale as the
origin (because this is the point where all of the hyperplanes in the
arrangement defining scalar "colors" intersect). Therefore, these two
functions convert between the two coordinate systems: `coord_to_edo`
takes in a scale represented by its pitch classes and returns its
displacement vector from "white" and `coord_from_edo` does the reverse.

## Usage

``` r
coord_to_edo(set, edo = 12)

coord_from_edo(set, edo = 12)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- edo:

  Number of unit steps in an octave. Defaults to `12`.

## Value

Numeric vector of same length as `set`. Same scale, new coordinate
system.

## Details

It should be noted that the representative "white" scale used is not
necessarily the *closest* one to the scale in question. Instead, it is
the unique transposition of white that has 0 as its first coordinate.
This is natural in the context of Modal Color Theory, which essentially
always assumes transpositional equivalence with \\x_0 = 0\\. The closest
transposition of "white" to `set` will be the one that has the same sum
class as `set`, guaranteeing that the voice leading between them is
"pure contrary" (Tymoczko 2011, 81ff; explored further in Straus 2018
[doi:10.1215/00222909-7127694](https://doi.org/10.1215/00222909-7127694)
).

## Examples

``` r
dominant_seventh_chord <- c(0, 2, 6, 9)
coord_to_edo(dominant_seventh_chord)
#> [1]  0 -1  0  0

ait1 <- c(0, 1, 4, 6)
ait2 <- c(0, 1, 3, 7)
coord_to_edo(ait1)
#> [1]  0 -2 -2 -3
coord_to_edo(ait2) # !
#> [1]  0 -2 -3 -2

weitzmann_pentachord <- coord_from_edo(c(0, -1, 0, 0, 0)) # See note 53 of "Modal Color Theory"
convert(weitzmann_pentachord, 12, 60)
#> [1]  0  7 24 36 48
coord_to_edo(weitzmann_pentachord)
#> [1]  0 -1  0  0  0
```
