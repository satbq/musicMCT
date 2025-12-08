# Generate one point on arbitrary combination of hyperplanes

Given a hyperplane arrangement (specified by `ineqmat`) and a subset of
those hyperplanes (specified numerically as the `rows` of `ineqmat`),
determine some point that lies on the intersection of those hyperplanes.
If the chosen hyperplanes do not all intersect in at least one point,
returns `NA`s and throws a warning. This function exists mostly for the
sake of calculations about a hyperplane arrangement itself, not for
musical applications: its results are often not very scale-like (e.g.,
they often fail
[`optc_test()`](https://satbq.github.io/musicMCT/reference/OPTC_test.md)).

## Usage

``` r
point_on_flat(rows, card, ineqmat = NULL, edo = 12, rounder = 10)
```

## Arguments

- rows:

  Integer vector: which rows of `ineqmat` should be taken as hyperplanes
  defining the target flat?

- card:

  Integer: the number of notes in your desired scale.

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

Numeric vector of length `card` which lies on the specified hyperplanes.
If the intersection of the hyperplanes is empty, throws a warning and
returns a vector of `NA`s with length `card`.

## See also

[`match_flat()`](https://satbq.github.io/musicMCT/reference/project_onto.md)
and
[`populate_flat()`](https://satbq.github.io/musicMCT/reference/populate_flat.md)
are intended for more concretely musical applications, returning a set
on the chosen flat which is similar to an input set.

## Examples

``` r
# Works essentially like an inverse of whichsvzeroes():
test_set <- sc(5, 32)
whichsvzeroes(test_set)
#> [1]  5  8 10
generated_point <- point_on_flat(c(5, 8, 10), card=5)
whichsvzeroes(generated_point)
#> [1]  5  8 10

# But note that the given point might lie on any face of the flat:
signvector(test_set)
#>  [1] -1 -1  1 -1  0 -1 -1  0 -1  0 -1 -1 -1  1  1
signvector(generated_point)
#>  [1]  1  1 -1  1  0  1  1  0  1  0  1  1  1 -1 -1

# Works for other hyperplane arrangements:
point_on_flat(c(2, 3, 6), card=3, ineqmat="roth")
#> [1] -6 -6  0
point_on_flat(c(2, 4), card=4, ineqmat="black")
#> [1] 0.02795603 3.00000000 0.46938430 9.00000000

# Not all combinations of hyperplanes admit a solution:
try(point_on_flat(c(1, 2, 3), card=4, ineqmat="roth"))
#> [1] 0 0 0 0
```
