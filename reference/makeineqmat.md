# Define hyperplanes for the Modal Color Theory arrangements

As described in Appendix 1.2 of "Modal Color Theory," information about
the defining hyperplane arrangements is stored as a matrix containing
the hyperplanes' normal vectors as rows. (Because these are **mat**rices
and they correspond ultimately to the intervallic **ineq**ualities that
define MCT geometry, this package refers to them as ineqmats, and
sometimes to the individual hyperplanes as `ineq`s.) These have already
been computed and are stored as data in this package (`ineqmats`) for
cardinalities up to 53, but they can be recreated from scratch with
`makeineqmat`. This might be useful if for some reason you need to deal
with a huge scale and therefore want to use an arrangement whose matrix
isn't already saved. Note that a call like `makeineqmat(60)` may take a
dozen or more seconds to run (and at sizes that large, the arrangement
is terribly complex, with ~17K distinct hyperplanes).

`getineqmat` tests whether the matrix already exists for the desired
cardinality. If so, it is retrieved; if not, it is created using
`makeineqmat`.

## Usage

``` r
makeineqmat(card)

getineqmat(card)
```

## Arguments

- card:

  The cardinality of the scale(s) to be studied

## Value

A matrix with `card+1` columns and roughly `card^(3)/8` rows

## Examples

``` r
makeineqmat(2) # Simple: is step 1 > step 2?
#>      [,1] [,2] [,3]
#> [1,]   -2    2   -1
makeineqmat(3) # Simple: step 1 > step 2? step 1 > step 3? step 2 > step 3?
#>      [,1] [,2] [,3] [,4]
#> [1,]   -1    2   -1    0
#> [2,]   -2    1    1   -1
#> [3,]   -1   -1    2   -1
makeineqmat(7) # Okay...
#>       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
#>  [1,]   -1    2   -1    0    0    0    0    0
#>  [2,]   -1    1    1   -1    0    0    0    0
#>  [3,]    0   -1    2   -1    0    0    0    0
#>  [4,]   -1    1    0    1   -1    0    0    0
#>  [5,]    0   -1    1    1   -1    0    0    0
#>  [6,]    0    0   -1    2   -1    0    0    0
#>  [7,]   -1    1    0    0    1   -1    0    0
#>  [8,]    0   -1    1    0    1   -1    0    0
#>  [9,]    0    0   -1    1    1   -1    0    0
#> [10,]    0    0    0   -1    2   -1    0    0
#> [11,]   -1    1    0    0    0    1   -1    0
#> [12,]    0   -1    1    0    0    1   -1    0
#> [13,]    0    0   -1    1    0    1   -1    0
#> [14,]    0    0    0   -1    1    1   -1    0
#> [15,]    0    0    0    0   -1    2   -1    0
#> [16,]   -2    1    0    0    0    0    1   -1
#> [17,]   -1   -1    1    0    0    0    1   -1
#> [18,]   -1    0   -1    1    0    0    1   -1
#> [19,]   -1    0    0   -1    1    0    1   -1
#> [20,]   -1    0    0    0   -1    1    1   -1
#> [21,]   -1    0    0    0    0   -1    2   -1
#> [22,]   -1    0    2    0   -1    0    0    0
#> [23,]   -1    0    1    1    0   -1    0    0
#> [24,]    0   -1    0    2    0   -1    0    0
#> [25,]   -1    0    1    0    1    0   -1    0
#> [26,]    0   -1    0    1    1    0   -1    0
#> [27,]    0    0   -1    0    2    0   -1    0
#> [28,]   -2    0    1    0    0    1    0   -1
#> [29,]   -1   -1    0    1    0    1    0   -1
#> [30,]   -1    0   -1    0    1    1    0   -1
#> [31,]   -1    0    0   -1    0    2    0   -1
#> [32,]    0   -2    0    1    0    0    1   -1
#> [33,]    0   -1   -1    0    1    0    1   -1
#> [34,]    0   -1    0   -1    0    1    1   -1
#> [35,]    0   -1    0    0   -1    0    2   -1
#> [36,]   -1    0    0    2    0    0   -1    0
#> [37,]   -2    0    0    1    1    0    0   -1
#> [38,]   -1   -1    0    0    2    0    0   -1
#> [39,]    0   -2    0    0    1    1    0   -1
#> [40,]    0   -1   -1    0    0    2    0   -1
#> [41,]    0    0   -2    0    0    1    1   -1
#> [42,]    0    0   -1   -1    0    0    2   -1
ineqmat20 <- makeineqmat(20)
dim(ineqmat20) # Yikes!
#> [1] 1000   21
```
