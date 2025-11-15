# Define hyperplanes for white arrangements

Although the hyperplane arrangements of Modal Color Theory determine
most scalar properties, there are some potentially interesting questions
which require different arrangements. This function makes "white"
arrangements which consider how many of a scale's intervals correspond
exactly to the "white" or perfectly even color for their generic size.
That is, for an interval `x` belonging to generic size `g` in an `n`
note scale, does \\x = g \cdot \frac{edo}{n}\\? This may be relevant,
for instance, because two modes have identical sum brightnesses when the
interval that separates their tonics is "white" in this way. Mostly you
will want to use these matrices as inputs to functions with an `ineqmat`
parameter.

In many cases, it is desirable to use a combination of the MCT `ineqmat`
from
[`makeineqmat()`](https://satbq.github.io/musicMCT/reference/makeineqmat.md)
and the quasi-white `ineqmat` from `make_white_ineqmat()`. Generally
these are distinct, but they do have some shared hyperplanes in even
cardinalities related to formal tritones (intervals that divide the
scale exactly in half). Therefore, the function `make_pastel_ineqmat()`
exists to give the result of combining them with duplicates removed.
(The moniker "pastel" is meant to suggest combining the colors of MCT
arrangements with a white pigment from white arrangements.)

Just as the MCT arrangements are concretized by the files
"representative_scales" and "representative_signvectors," the white and
pastel arrangements are represented by
[offwhite_scales](https://github.com/satbq/modalcolortheory/blob/main/offwhite_scales.rds),
[offwhite_signvectors](https://github.com/satbq/modalcolortheory/blob/main/offwhite_signvectors.rds),
[pastel_scales](https://github.com/satbq/modalcolortheory/blob/main/pastel_scales.rds),
and
[pastel_signvectors](https://github.com/satbq/modalcolortheory/blob/main/pastel_signvectors.rds).
This data has not been as thoroughly vetted as the files for the MCT
arrangements, and currently white and pastel arrangements are only
represented up through cardinality 6. The files are hosted at the
[modalcolortheory repo](https://github.com/satbq/modalcolortheory) like
representative_scales because they are too large to include in musicMCT.

## Usage

``` r
make_white_ineqmat(card)

make_pastel_ineqmat(card)
```

## Arguments

- card:

  The cardinality of the scale(s) to be studied

## Value

A matrix with `card+1` columns and k rows, where k is the nth triangular
number

## Examples

``` r
major_triad <- c(0, 4, 7)
howfree(major_triad)
#> [1] 2
howfree(major_triad, ineqmat=make_white_ineqmat(3))
#> [1] 1
# Because it's now constrained to preserve its step of exactly 1/3 the octave.

just_major_triad <- j(1, 3, 5)
howfree(just_major_triad)
#> [1] 2
howfree(just_major_triad, ineqmat=make_white_ineqmat(3))
#> [1] 2
# Because this triad's major third isn't identical to 400 cents which equally
# divide the octave.

ait1 <- c(0, 1, 4, 6)
quantize_color(ait1, reconvert=TRUE)
#> [1] 0.000000 1.090909 4.363636 6.545455
# quantize_color() doesn't match (0146) exactly because it's only looking for
# any set in the same 3-dimensional color as 0146.

quantize_color(ait1, ineqmat=make_white_ineqmat(4), reconvert=TRUE)
#> [1] 0 1 4 6
# Now that it's constrained to respect ait1's minor third from 1 to 4, the set 0146
# is now the first satisfactory result that quantize_color() finds.
```
