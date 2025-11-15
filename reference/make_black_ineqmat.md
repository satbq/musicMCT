# Define hyperplanes for transposition-sensitive arrangements

The "black" hyperplane arrangement compares a set's scale degrees
individually to the pitches of `edoo(card)` (where `card` is the number
of notes in `set`). This primarily has the purpose of attending to the
overall transposition level of a set. Most applications of Modal Color
Theory assume transpositional equivalence, but occasionally it is useful
to relax that assumption. Sum class (Straus 2018,
[doi:10.1215/00222909-7127694](https://doi.org/10.1215/00222909-7127694)
) is a natural way to track this information, but the "black"
arrangements do so qualitatively in the spirit of modal color theory.
`make_black_ineqmat()` returns only the inequality matrix for the
"black" arrangement, while `make_gray_ineqmat()` for convenience
combines the results of
[`make_white_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_white_ineqmat.md)
and `make_black_ineqmat()`.

## Usage

``` r
make_black_ineqmat(card)

make_gray_ineqmat(card)
```

## Arguments

- card:

  The cardinality of the scale(s) to be studied

## Value

A `card` by `card+1` inequality matrix (for `make_black_ineqmat()`) or
the result of combining white and black inequality matrices (in that
order) for `make_gray_ineqmat()`.

## See also

[`make_white_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_white_ineqmat.md)

## Examples

``` r
# The set (1, 4, 7)'s elements are respectively below, equal to, and
# above the pitches of edoo(3).
test_set <- c(1, 4, 7)
signvector(test_set, ineqmat=make_black_ineqmat(3))
#> [1]  1  0 -1

# The result changes if you transpose test_set down a semitone:
signvector(test_set - 1, ineqmat=make_black_ineqmat(3))
#> [1]  0 -1 -1

# The results from signvector(..., ineqmat=make_black_ineqmat) can
# also be calculated with coord_to_edo():
sign(coord_to_edo(test_set))
#> [1]  1  0 -1
sign(coord_to_edo(test_set - 1))
#> [1]  0 -1 -1
```
