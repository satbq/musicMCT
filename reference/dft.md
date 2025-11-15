# The musical Discrete Fourier Transform of a pitch-class set

Computes the magnitudes and phases of the DFT components for a given
(multi)set which can be input as either a vector of elements or as a
distribution. (See Amiot (2016,
[doi:10.1007/978-3-319-45581-5](https://doi.org/10.1007/978-3-319-45581-5)
) for an overview of applications of the DFT in this vein.) Entering a
distribution takes priority over an entered `set`.

## Usage

``` r
dft(set, distro = NULL, edo = 12, rounder = 10)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- distro:

  Numeric vector representing a pitch-class distribution. Defaults to
  `NULL` and overrides `set` and `edo` if entered.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

A 2-by-k real matrix, where k is the number of independent components.
The ith column corresponds to the (i-1)th component (so that the first
column gives the zeroth component). The first row gives the magnitudes
of the components and the second row gives the phases. (See details
regarding interpretation of the values: they are scaled by edo/(2\*pi)
from radians.)

## Details

The scaling and orientation of phases corresponds to that used in Yust
(2021) <doi:10.1093/mts/mtaa0017>: phases are reported as multiples of
one kth of an octave (where the set is entered in k-edo), and oriented
so that the \\\hat{f}\_1\\ component of a singleton points in the
direction of the singleton (i.e. the phase of \\\hat{f}\_1\\ for pitch
class 4 is 4). This differs from the phase values use in other
publications, such as Yust (2015,
[doi:10.1215/00222909-2863409](https://doi.org/10.1215/00222909-2863409)
). Magnitudes are not squared, following Amiot (2016) rather than Yust
(2021).

## Examples

``` r
# Compare to Yust (2021), Example 10
reich_signature <- c(0, 1, 2, 4, 5, 7, 9, 10)
dft(reich_signature)
#>           f0        f1 f2 f3 f4        f5 f6
#> magnitude  8 0.7320508  0  2  2  2.732051  0
#> phase      0 1.0000000  0  3  4 11.000000  0
# Magnitudes differ from Yust by squaring:
round(dft(reich_signature)[1, ]^2, digits=3)
#>     f0     f1     f2     f3     f4     f5     f6 
#> 64.000  0.536  0.000  4.000  4.000  7.464  0.000 

reich_sig_distribution <- c(1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0)
dft(distro=reich_sig_distribution)
#>           f0        f1 f2 f3 f4        f5 f6
#> magnitude  8 0.7320508  0  2  2  2.732051  0
#> phase      0 1.0000000  0  3  4 11.000000  0

# Z-related AITs differ in phase but not magnitude:
ait1 <- c(0, 1, 4, 6)
ait2 <- c(0, 1, 3, 7)
dft(ait1)
#>           f0       f1 f2       f3 f4       f5 f6
#> magnitude  4 1.414214  2 1.414214  2 1.414214  2
#> phase      0 2.500000  0 1.500000  2 6.500000  0
dft(ait2)
#>           f0       f1 f2        f3 f4       f5 f6
#> magnitude  4 1.414214  2  1.414214  2 1.414214  2
#> phase      0 1.500000  2 10.500000  2 1.500000  6
```
