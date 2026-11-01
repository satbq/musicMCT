# Define hyperplanes for ultraviolet arrangements

Named to draw a parallel with the the "infrared" arrangements (see
[`make_infrared_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_infrared_ineqmat.md)),
the "ultraviolet" arrangements are also primarily intended to study
voice leadings in conjunction with
[`vl_signvector()`](https://satbq.github.io/musicMCT/reference/signvector.md).
They evaluate whether a voice leading involves contrary motion in equal
but opposite amounts, such as when the soprano rises two semitones while
the bass falls 2 semitones. In this, the ultraviolet arrangements are
complementary to the white arrangements of
[`make_white_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_white_ineqmat.md).
Unlike many hyperplane arrangements in musicMCT, the ultraviolet
arrangements do not reflect transpositional equivalence.

## Usage

``` r
make_ultraviolet_ineqmat(card)
```

## Arguments

- card:

  The cardinality of the scale(s) to be studied

## Value

A matrix with `card+1` columns and k rows, where k is the nth triangular
number

## Details

Combinatorial features of these arrangements are described in Richard
Stanley, "A Zonotope Associated with Graphical Degree Sequences," in
*Applied Geometry and Discrete Mathematics: The Victor Klee
Festschrift*, 555-570, edited by Peter Gritzmann and Bernd Sturmfels
(American Mathematical Society, 1990).

## See also

[`make_infrared_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_infrared_ineqmat.md)
and
[`make_white_ineqmat()`](https://satbq.github.io/musicMCT/reference/make_white_ineqmat.md)
for related hyperplane arrangements.

## Examples

``` r
uv_trichord_ineqmat <- make_ultraviolet_ineqmat(3)
voice_leading_1 <- c(-1, 1, 0)
vl_signvector(voice_leading_1, ineqmat=uv_trichord_ineqmat)
#> [1]  0 -1  1

# The first entry of the sign vector is 0 because the bass and alto voices
# move in a perfectly counterbalanced wedge. The second entry of the sign vector
# compares bass and soprano; the third entry compares alto and soprano:
print(uv_trichord_ineqmat)
#>      [,1] [,2] [,3]       [,4]
#> [1,]    1    1    0 -0.3333333
#> [2,]    1    0    1 -0.6666667
#> [3,]    0    1    1 -1.0000000

# If this voice leading is transposed ("Tinctoris transformed") up a semitone,
# then it will lie on no ultraviolet hyperplanes.
voice_leading_2 <- voice_leading_1 + 1
vl_signvector(voice_leading_2, ineqmat=uv_trichord_ineqmat)
#> [1] 1 1 1
```
