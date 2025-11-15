# Which interval-comparison equalities does a scale satisfy?

As "Modal Color Theory" (p. 26) describes, one useful measure of a
scale's **regularity** is the number of zeroes in its sign vector. This
indicates how many hyperplanes a scale lies *on*, a geometrical fact
whose musical interpretation is, roughly speaking, how many times two
generic intervals equal each other in specific size. (I say only
"roughly speaking" because one hyperplane usually represents multiple
comparisons: see Appendix 1.1.) Scales with a great degree of symmetry
or other forms of regularity such as well-formedness tend to be on a
very high number of hyperplanes compared to all sets of a given
cardinality.

`musicMCT` offers two convenience functions that return pertinent
information from
[`signvector()`](https://satbq.github.io/musicMCT/reference/signvector.md).
`countsvzeroes` returns this **count** of the number of
**s**ign-**v**ector **zeroes**, while `whichsvzeroes` gives a list of
the specific hyperplanes the scale lines on (numbered according to their
position on the given `ineqmat`). The specific information in
`whichsvzeroes` can be useful because it determines the "flat" of the
hyperplane arrangement that the scale lies on, which is a more general
kind of scalar structure than color (as determined by the entire sign
vector).

## Usage

``` r
whichsvzeroes(set, ineqmat = NULL, edo = 12, rounder = 10)

countsvzeroes(set, ineqmat = NULL, edo = 12, rounder = 10)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- ineqmat:

  Specifies which hyperplane arrangement to consider. By default (or by
  explicitly entering "mct") it supplies the standard "Modal Color
  Theory" arrangements of
  [`getineqmat()`](https://satbq.github.io/musicMCT/reference/makeineqmat.md),
  but can be set to strings "white," "black", "gray", "roth",
  "infrared", "pastel", "rosy", "infrared", or "anaglyph", giving the
  `ineqmat`s of
  [`make_white_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_white_ineqmat.md),
  [`make_black_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_black_ineqmat.md),
  [`make_gray_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_black_ineqmat.md),
  [`make_roth_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_roth_ineqmat.md),
  [`make_infrared_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_infrared_ineqmat.md),
  [`make_pastel_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_white_ineqmat.md),
  [`make_rosy_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_roth_ineqmat.md),
  [`make_infrared_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_infrared_ineqmat.md),
  or
  [`make_anaglyph_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_anaglyph_ineqmat.md).
  For other arrangements, this parameter accepts explicit matrices.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

Single numeric value for `countsvzeroes` and a numeric vector for
`whichsvzeroes`

## Examples

``` r
# Sort 12edo heptachords by how many sign vector zeroes they have (from high to low)
heptas12 <- unique(apply(utils::combn(12, 7), 2, primeform), MARGIN=2)
heptas12_svzeroes <- apply(heptas12, 2, countsvzeroes)
colnames(heptas12) <- apply(heptas12, 2, fortenum)
heptas12[, order(heptas12_svzeroes, decreasing=TRUE)]
#>      7-1 7-35 7-34 7-33 7-32 7-2 7-3 7-30 7-5 7-7 7-37 7-22 7-31 7-4 7-6 7-13
#> [1,]   0    0    0    0    0   0   0    0   0   0    0    0    0   0   0    0
#> [2,]   1    1    1    1    1   1   1    1   1   1    1    1    1   1   1    1
#> [3,]   2    3    3    2    3   2   2    2   2   2    3    2    3   2   2    2
#> [4,]   3    5    4    4    4   3   3    4   3   3    4    5    4   3   3    4
#> [5,]   4    6    6    6    6   4   4    6   5   6    5    6    6   4   4    5
#> [6,]   5    8    8    8    8   5   5    8   6   7    7    8    7   6   7    6
#> [7,]   6   10   10   10    9   7   8    9   7   8    8    9    9   7   8    8
#>      7-38 7-21 7-29 7-20 7-8 7-12 7-11 7-19 7-17 7-27 7-25 7-15 7-28 7-24 7-26
#> [1,]    0    0    0    0   0    0    0    0    0    0    0    0    0    0    0
#> [2,]    1    1    1    1   2    1    1    1    1    1    2    1    1    1    1
#> [3,]    2    2    2    2   3    2    3    2    2    2    3    2    3    2    3
#> [4,]    4    4    4    5   4    3    4    3    4    4    4    4    5    3    4
#> [5,]    5    5    6    6   5    4    5    6    5    5    6    6    6    5    5
#> [6,]    7    8    7    7   6    7    6    7    6    7    7    7    7    7    7
#> [7,]    8    9    9    9   8    9    8    9    9    9    9    8    9    9    9
#>      7-9 7-10 7-36 7-16 7-14 7-18 7-23
#> [1,]   0    0    0    0    0    0    0
#> [2,]   1    1    1    1    1    1    2
#> [3,]   2    2    2    2    2    4    3
#> [4,]   3    3    3    3    3    5    4
#> [5,]   4    4    5    5    5    6    5
#> [6,]   6    6    6    6    7    7    7
#> [7,]   8    9    8    9    8    9    9

# Multiple hexachords on the same flat but of different colors
hex1 <- c(0, 2, 4, 5, 7, 9)
hex2 <- convert(c(0, 1, 2, 4, 5, 6), 9, 12)
hex3 <- convert(c(0, 3, 6, 8, 11, 14), 15, 12)
hex_words <- rbind(asword(hex1), asword(hex2), asword(hex3))
rownames(hex_words) <- c("hex1", "hex2", "hex3")
c(colornum(hex1), colornum(hex2), colornum(hex3))
#> NULL
whichsvzeroes(hex1)
#> [1]  1  4  5  7  8 10 17
whichsvzeroes(hex2)
#> [1]  1  4  5  7  8 10 17
whichsvzeroes(hex3)
#> [1]  1  4  5  7  8 10 17
hex_words
#>      [,1] [,2] [,3] [,4] [,5] [,6]
#> hex1    2    2    1    2    2    3
#> hex2    1    1    2    1    1    3
#> hex3    3    3    2    3    3    1
```
