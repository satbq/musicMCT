# Do two sign vectors represent adjacent colors?

As "Modal Color Theory" (pp. 31ff.) describes, it can be useful to know
whether two colors are adjacent to each other in the MCT space. That is,
can one scalar color be continuously modified until it becomes the
other, without crossing through any third color? For instance, the
5-limit just diatonic scale is a two-dimensional color that is adjacent
to the 1-d line of meantone diatonic scales. This means, in some sense,
that the meantone structure is a good approximation of the 5-limit just
structure.

## Usage

``` r
comparesignvecs(signvecX, signvecY)
```

## Arguments

- signvecX, signvecY:

  A pair of sign vectors to be compared. Note that these must be sign
  vectors, not scales themselves.

## Value

Integer: `0` if the sign vectors represent the same color, `1` if they
are adjacent, and `-1` if they are neither adjacent nor identical.

## Examples

``` r
meantone_major_sv <- signvector(c(0, 2, 4, 5, 7, 9, 11))
meantone_dorian_sv <- signvector(c(0, 2, 3, 5, 7, 9, 10))
just_major <- j(dia)
just_dorian <- sim(just_major)[,2] 
just_major_sv <- signvector(just_major)
just_dorian_sv <- signvector(just_dorian)

comparesignvecs(meantone_major_sv, just_major_sv)
#> [1] 1
comparesignvecs(meantone_dorian_sv, just_major_sv)
#> [1] -1
comparesignvecs(meantone_dorian_sv, just_dorian_sv)
#> [1] 1
```
