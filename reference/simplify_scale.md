# Best ways to regularize a scale

Given an input scale, identify which adjacent colors represent good
approximations of it, in a sense consistent with "Modal Color Theory,"
pp. 31-32.

## Usage

``` r
simplify_scale(
  set,
  start_zero = TRUE,
  ineqmat = NULL,
  scales = NULL,
  signvector_list = NULL,
  adjlist = NULL,
  method = c("euclidean", "taxicab", "chebyshev", "hamming"),
  display_digits = 2,
  edo = 12,
  rounder = 10
)

best_simplification(set, ...)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- start_zero:

  Boolean: should the result be transposed so that its pitch initial is
  zero? Defaults to `TRUE`.

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

- scales:

  List of scales representing the faces of your hyperplane arrangement.
  Defaults to `NULL` in which case the function looks for
  `representative_scales` in the global environment.

- signvector_list:

  A list of signvectors to use as the reference by which `colornum`
  assigns a value. Defaults to `NULL` and will attempt to use
  `representative_signvectors`, which needs to be downloaded and
  assigned separately from the package musicMCT. (If a named `ineqmat`
  other than "mct" is chosen, the function attempts to replace a `NULL`
  signvector list with a corresponding object in the global environment.
  For instance, if `ineqmat="pastel"` then the function tries to use
  `pastel_signvectors` for `signvector_list`.)

- adjlist:

  Adjacency list structured in the same way as `color_adjacencies`.
  Defaults to `NULL` in which case the function looks for
  `color_adjacencies` in the global environment.

- method:

  What distance metric should be used? Defaults to `"euclidean"` (unlike
  most functions with a method parameter in musicMCT) but can be
  `"taxicab"`, `"chebyshev"`, or `"hamming"`.

- display_digits:

  Integer: how many digits to display when naming any non-integral
  interval sizes. Defaults to 2.

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

- ...:

  Other arguments to be passed from `best_simplification()` to
  `simplify_scale()`.

## Value

A matrix with `n+6` rows, where `n` is the number of notes in the scale.
Each column represents a scale which is a potential simplification of
the input `set`, together with details about that simplified scale. The
first `n` entries of the column represent the pitches of the scale
itself:

- The `n+1`th row indicates the color number of the simplification.

- The `n+2`th row shows how many degrees of freedom the simplification
  has (always between `0` and `d-1` where `d` is `set`'s degree of
  freedom).

- The `n+3`th row calculates the voice-leading distance from `set` to
  the simplified scale (according to the chosen `method`, for which
  Euclidean distance is the default because it corresponds to the
  assumption that orthogonal projection finds the closest point on a
  neighboring flat).

- The `n+4`th row counts how many more hyperplanes the simplified scale
  lies on compared to `set`.

- The `n+5`th row is a quotient of the previous two rows (distance
  divided by number of new regularities).

- The `n+6`th row calculates a final "score" which is used to order the
  columns from best (first) to worst (last) simplifications. This score
  is the inverse of the previous row divided by the total number of
  hyperplanes in the arrangement. (Without this normalization, scores
  for higher cardinalities quickly become much larger than scores for
  low cardinalities.)

If `display_digits` is a value other than `NULL`, the function prints to
console a suitably rounded representation of the data, while invisibly
returning the unrounded information.

`best_simplification()` returns simply a numeric vector with the scale
judged optimal by `simplify_scale()` (i.e. the first `n` entries of its
first column, without all the other information).

## Details

Suppose that you've gathered data on how a particular instrument is
tuned. Two intervals in its scale differ by about 12 cents: does it make
sense to consider those intervals to be essentially the same, up to some
combination of measurement error and the permissiveness of cognitive
categories? `simplify_scale()` helps to answer such a question by
considering whether eliding a precisely measured difference results in a
significant simplification of the overall scale structure.

It accomplishes this by starting from two premises:

- Any simplification should move to an adjacent color with fewer degrees
  of freedom.

- There's a tradeoff between moving farther (i.e. requiring more
  measurement fuzziness) and achieving greater regularity. Therefore it
  starts by projecting the input scale onto all neighboring flats with
  fewer degrees of freedom. Some projections can be rejected immediately
  because the closest point on the flat isn't actually an adjacent
  color. The non-rejected projections can therefore be ranked by
  calculating the "cost" of each additional regularity: for every `1` or
  `-1` in the sign vector that is converted to a `0`, how far does one
  have to move in voice leading space?

To answer this question, `simplify_signvector` needs access to data
about the hyperplane arrangement in question. For the basic "Modal Color
Theory" arrangements, this is the data in `representative_scales.rds`,
`representative_signvectors.rds`, and `color_adjacencies.rds`. The
function assumes that, if you don't specify other data, you have those
three files loaded into your workspace. It can't function without them.

## Examples

``` r
if (FALSE) { # exists("representative_scales") && exists("representative_signvectors") && exists("color_adjacencies")
# For this example to run, you need the necessary data files loaded.
# Let's see what happens if we try to simplify the 5-limit just diatonic:

simplify_scale(j(dia))

# So the best option is color number 942659, which is the "well-formed"
# structure of the familiar diatonic scale. The particular saturation of
# that meantone structure is very close to 1/5-comma meantone:

simplified_jdia <- best_simplification(j(dia))
fifth_comma_dia <- sim(sort((meantone_fifth(1/5)*(0:6))%%12))[,5]
vl_dist(simplified_jdia, fifth_comma_dia)
}
```
