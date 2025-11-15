# Algebraic word of a set's step sizes

Among others, Carey & Clampitt (1989) and Clampitt (1997) have shown
that much can be learned about a set by representing it as a word on
\\m\\ "letters" which represent the \\m\\ distinct steps between
adjacent members of the set. This is more or less what is done in theory
fundamentals classes when a major scale is represented as TTSTTTS (if we
temporarily forget that T and S represent specific interval sizes). In
scholarship the algebraic letters are usually represented as letters of
the Latin alphabet, but for some computational purposes it is useful for
these to be explicitly ordered. That is, the major scale should be
represented as integers 2212221, which is distinct from 1121112. (Thus
`asword` makes finer distinctions than you might expect coming from a
word-theoretic context.)

## Usage

``` r
asword(set, edo = 12, rounder = 10)
```

## Arguments

- set:

  Numeric vector of pitch-classes in the set

- edo:

  Number of unit steps in an octave. Defaults to `12`.

- rounder:

  Numeric (expected integer), defaults to `10`: number of decimal places
  to round to when testing for equality.

## Value

Vector of integers of the same length as `set`. `1` should always be the
lowest value, representing the smallest step size in the set.

## Examples

``` r
dia_12edo <- c(0, 2, 4, 5, 7, 9, 11)
qcm_fifth <- meantone_fifth()
qcm_dia <- sort(((0:6)*qcm_fifth)%%12)
just_dia <- j(dia)
asword(dia_12edo)
#> [1] 2 2 1 2 2 2 1
asword(qcm_dia)
#> [1] 2 2 2 1 2 2 1
asword(just_dia)
#> [1] 3 2 1 3 2 3 1

#### asword() is less discriminating than colornum(). 
#### See "Modal Color Theory," 16
set1 <- c(0, 1, 4, 7, 8)
set2 <- c(0, 1, 3, 5, 6)
set1_word <- asword(set1)
set2_word <- asword(set2)
isTRUE(all.equal(set1_word, set2_word))
#> [1] TRUE
colornum(set1) == colornum(set2) 
#> logical(0)
# (Last line only works with representative_signvectors loaded.)
```
