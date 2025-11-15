# Specific sizes corresponding to each generic interval

As defined by Clough and Myerson 1986
([doi:10.1080/00029890.1986.11971924](https://doi.org/10.1080/00029890.1986.11971924)
), an "interval spectrum" is a list of all the specific (or "chromatic")
intervals that occur as instances of a single generic (or "diatonic")
interval within some reference scale. For instance, in the usual
diatonic scale, the generic interval 1 (a "step" in the scale) comes in
two specific sizes: 1 semitone and 2 semitones. Therefore its interval
spectrum \\\langle 1 \rangle = \\ 1, 2 \\\\. These functions calculates
the spectrum for every generic interval within a set and return either a
list of specific values in each spectrum or a summary of how many
distinct values there are.

## Usage

``` r
intervalspectrum(set, edo = 12, rounder = 10)

spectrumcount(set, edo = 12, rounder = 10)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

`intervalspectrum` returns a list of length one less than `length(set)`.
The nth entry of the list represents the specific sizes of generic
interval n. `spectrumcount` returns a vector that reports the length of
each entry in that list (i.e. the number of distinct specific intervals
for each generic interval).

## Examples

``` r
intervalspectrum(sc(7,35))
#> [[1]]
#> [1] 1 2
#> 
#> [[2]]
#> [1] 3 4
#> 
#> [[3]]
#> [1] 5 6
#> 
#> [[4]]
#> [1] 6 7
#> 
#> [[5]]
#> [1] 8 9
#> 
#> [[6]]
#> [1] 10 11
#> 
qcm_fifth <- meantone_fifth()
qcm_dia <- sort(((0:6)*qcm_fifth)%%12)
intervalspectrum(qcm_dia)
#> [[1]]
#> [1] 1.171079 1.931569
#> 
#> [[2]]
#> [1] 3.102647 3.863137
#> 
#> [[3]]
#> [1] 5.034216 5.794706
#> 
#> [[4]]
#> [1] 6.205294 6.965784
#> 
#> [[5]]
#> [1] 8.136863 8.897353
#> 
#> [[6]]
#> [1] 10.06843 10.82892
#> 
just_dia <- 12 * log2(c(1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8))
intervalspectrum(just_dia)
#> [[1]]
#> [1] 1.117313 1.824037 2.039100
#> 
#> [[2]]
#> [1] 2.941350 3.156413 3.863137
#> 
#> [[3]]
#> [1] 4.980450 5.195513 5.902237
#> 
#> [[4]]
#> [1] 6.097763 6.804487 7.019550
#> 
#> [[5]]
#> [1] 8.136863 8.843587 9.058650
#> 
#> [[6]]
#> [1]  9.96090 10.17596 10.88269
#> 

spectrumcount(just_dia) # The just diatonic scale is trivalent.
#> [1] 3 3 3 3 3 3

# Melodic minor nearly has "Myhill's Property" except for its 3 sizes of fourth and fifth
spectrumcount(sc(7,34)) 
#> [1] 2 2 3 3 2 2
```
