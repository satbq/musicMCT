# Which hyperplanes affect a given generic interval?

Given an `ineqmat` (i.e. a matrix representing a hyperplane
arrangement), this function tells us which of those hyperplanes affect a
specific generic interval size. (One specific application of this is is
[`step_signvector()`](https://satbq.github.io/musicMCT/reference/step_signvector.md),
which pays attention only to the comparisons between step sizes in a
scale.)

## Usage

``` r
get_relevant_rows(generic_intervals, ineqmat)
```

## Arguments

- generic_intervals:

  A vector of one or more integers representing generic intervals that
  can be found within the scale. Unisons are `0`, generic steps are `1`,
  etc.

- ineqmat:

  The matrix of hyperplane normal vectors that you want to search.

## Value

Vector of integers indicating the relevant hyperplanes from `ineqmat`

## Examples

``` r
heptachord_ineqmat <- getineqmat(7)
heptachord_step_comparisons <- get_relevant_rows(1, heptachord_ineqmat)

# Create an ineqmat that attends only to the quality of (024) trichordal
# subsets in a heptachord.
heptachord_triads <- get_relevant_rows(c(0, 2, 4), heptachord_ineqmat)
triads_in_7_ineqmat <- heptachord_ineqmat[heptachord_triads,]

# Now, the following two heptachords have different colors
# but the same pattern of (024) trichordal subsets, so their signvector
# using triads_in_7_ineqmat is identical:
heptachord_1 <- convert(c(0, 1, 3, 6, 8, 12, 13), 17, 12)
heptachord_2 <- convert(c(0, 1, 3, 5, 7, 10, 11), 14, 12)
colornum(heptachord_1) == colornum(heptachord_2)
#> logical(0)
sv_1 <- signvector(heptachord_1, ineqmat=triads_in_7_ineqmat)
sv_2 <- signvector(heptachord_2, ineqmat=triads_in_7_ineqmat)
isTRUE(all.equal(sv_1, sv_2))
#> [1] TRUE
subset_varieties(c(0, 2, 4), heptachord_1, unique=FALSE)
#>          [,1]     [,2]     [,3]     [,4]     [,5]     [,6]     [,7]
#> [1,] 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000
#> [2,] 2.117647 3.529412 3.529412 4.235294 3.529412 3.529412 3.529412
#> [3,] 5.647059 7.764706 7.058824 7.764706 7.058824 5.647059 7.058824
subset_varieties(c(0, 2, 4), heptachord_2, unique=FALSE)
#>          [,1]     [,2]     [,3]     [,4]     [,5]     [,6]     [,7]
#> [1,] 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000 0.000000
#> [2,] 2.571429 3.428571 3.428571 4.285714 3.428571 3.428571 3.428571
#> [3,] 6.000000 7.714286 6.857143 7.714286 6.857143 6.000000 6.857143
# Both have identical qualities for triads on scale degree 3, 5, and 7,
# which you can see by comparing columns 3, 5, and 7 in the two
# matrices above.
```
