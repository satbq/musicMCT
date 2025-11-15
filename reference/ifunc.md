# All intervals from one set to another

David Lewin's interval function (IFUNC) calculates all the intervals
from some source set `x` to some goal set `y`. See Lewin, *Generalized
Musical Intervals and Transformations* (New Haven, CT: Yale University
Press, 1987), 88. Lewin's definition of the IFUNC depends on the GIS it
applies to, but this package's `ifunc()` is less flexible. It uses only
ordered pitch-class intervals as the group of IVLS to be measured. Its
intervals can, however, be any continuous value and are not restricted
to integers mod `edo`. The format of the result depends on whether
non-integer intervals occur.

## Usage

``` r
ifunc(
  x,
  y = NULL,
  edo = 12,
  rounder = 10,
  display_digits = 2,
  show_zeroes = TRUE
)
```

## Arguments

- x:

  The source set from which the intervals originate

- y:

  The goal set to which the intervals lead. Defaults to `NULL`, in which
  case `ifunc()` gives the intervals from `x` to itself.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

- display_digits:

  Integer: how many digits to display when naming any non-integral
  interval sizes. Defaults to 2.

- show_zeroes:

  Boolean: if `x` and `y` belong to a single mod `edo` universe, should
  `0` values be listed for any intervals mod `edo` which do not occur in
  their IFUNC? Defaults to `TRUE`.

## Value

Numeric vector counting the number of occurrences of each interval. The
[`names()`](https://rdrr.io/r/base/names.html) of the result indicate
which interval size is counted by each entry. If `x` and `y` both belong
to a single mod `edo` universe (and `show_zeroes=TRUE`), the result is a
vector of length `edo` and includes explicit `0` results for missing
intervals. If `x` and `y` must be measured in continuous pitch-class
space, no missing intervals are identified (since there would be
infinitely many to list).

## Examples

``` r
ifunc(c(0, 3, 7))
#>  0  1  2  3  4  5  6  7  8  9 10 11 
#>  3  0  0  1  1  1  0  1  1  1  0  0 
ifunc(c(0, 3, 7), c(0, 4, 7))
#>  0  1  2  3  4  5  6  7  8  9 10 11 
#>  2  1  0  0  2  1  0  1  0  2  0  0 
ifunc(c(0, 4, 7), c(0, 3, 7))
#>  0  1  2  3  4  5  6  7  8  9 10 11 
#>  2  0  0  2  0  1  0  1  2  0  0  1 

ifunc(c(0, 2, 4, 7, 9), show_zeroes=FALSE)
#>  0  2  3  4  5  7  8  9 10 
#>  5  3  2  1  4  4  1  2  3 

just_dia <- j(dia)
ifunc(just_dia)
#>     0  1.11  1.82  2.03  2.94  3.15  3.86  4.98  5.19  5.90  6.09  6.80  7.01 
#>     7     2     2     3     1     3     3     5     1     1     1     1     5 
#>  8.13  8.84  9.05  9.96 10.17 10.88 
#>     3     3     1     3     2     2 
ifunc(just_dia, display_digits=4)
#>       0  1.1173  1.8240  2.0391  2.9413  3.1564  3.8631  4.9804  5.1955  5.9022 
#>       7       2       2       3       1       3       3       5       1       1 
#>  6.0977  6.8044  7.0195  8.1368  8.8435  9.0586  9.9608 10.1759 10.8826 
#>       1       1       5       3       3       1       3       2       2 

# See Lewin, GMIT p. 89:
lewin_x <- c(4, 10)
lewin_y1 <- c(9, 1, 5)
lewin_y2 <- c(7, 11, 9)
isTRUE(all.equal(ifunc(lewin_x, lewin_y1), ifunc(lewin_x, lewin_y2)))
#> [1] TRUE
apply(cbind(lewin_y1, lewin_y2), 2, fortenum)
#> lewin_y1 lewin_y2 
#>   "3-12"    "3-6" 
```
