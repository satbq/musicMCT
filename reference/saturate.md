# Modify evenness without changing hue

Saturation parameterizes scale structures along a single degree of
freedom which corresponds to size of the vector from the "white"
perfectly even scale to the scale in question. Variation in a scale's
saturation minimally affects its structural properties. The function
`saturate()` takes in a scale and a saturation parameter (`r`) and
returns another scale along the same line (i.e. including the scale's
hue and its scalar involution–see "Modal Color Theory," 32).

## Usage

``` r
saturate(r, set, edo = 12)
```

## Arguments

- r:

  Numeric: the relative proportion to (de)saturate the set by. If r is
  set to 0, returns white; if r = 1, returns the input set. If 0 \< r \<
  1, the saturation is decreased. If r \> 1, the saturation is
  increased, potentially to the point where the set moves past some
  OPTIC boundary. If r \< 0, the result is an "involution" of the set.

- set:

  Numeric vector of pitch-classes in the set

- edo:

  Number of unit steps in an octave. Defaults to `12`.

## Value

Numeric vector of same length as `set` (another scale on the same hue)

## Examples

``` r
lydian <- c(0, 2, 4, 6, 7, 9, 11)
qcm_fifth <- meantone_fifth()
qcm_dia <- sort(((0:6)*qcm_fifth)%%12)
evenness_ratio <- evenness(qcm_dia) / evenness(lydian)
desaturated_lydian <- saturate(evenness_ratio, lydian)
desaturated_lydian
#> [1]  0.000000  1.931569  3.863137  5.794706  6.965784  8.897353 10.828921
qcm_dia
#> [1]  0.000000  1.931569  3.863137  5.794706  6.965784  8.897353 10.828921

ionian <- c(0, 2, 4, 5, 7, 9, 11)
involution_of_ionian <- saturate(-2, ionian)
convert(involution_of_ionian, 12, 42)
#> [1]  0  4  8 19 23 27 31
asword(ionian)
#> [1] 2 2 1 2 2 2 1
asword(involution_of_ionian)
#> [1] 1 1 2 1 1 1 2
```
